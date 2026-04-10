// Production-ready logging using Talker for auth flows

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:myitihas/core/config/env.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/services/deep_link_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Minimum password length requirement (OWASP recommends 8+)
const int kMinPasswordLength = 8;

/// Canonical message used when sign-up fails due to duplicate email.
///
/// Kept as a top-level constant so UI + tests can share the same wording.
const String kDuplicateEmailSignUpMessage = 'Email already registered.';

/// Best-effort classifier for "duplicate email" sign-up failures across
/// Supabase/Auth and Postgres error variants.
bool isDuplicateEmailSignUpError(String message) {
  final lower = message.trim().toLowerCase();
  if (lower.isEmpty) return false;

  return lower.contains('user already registered') ||
      lower.contains('user already exists') ||
      lower.contains('email already exists') ||
      lower.contains('already registered') ||
      lower.contains('email address is already registered') ||
      lower.contains('user with this email already exists') ||
      lower.contains('has already been registered') ||
      (lower.contains('already exists') && lower.contains('email')) ||
      lower.contains('duplicate key') ||
      (lower.contains('unique constraint') && lower.contains('email')) ||
      (lower.contains('duplicate') && lower.contains('email')) ||
      lower.contains('users_email_unique');
}

const String kSignUpPasswordRequirementsMessage =
    'Password must be at least $kMinPasswordLength characters and include at least one uppercase letter, one lowercase letter, one number, and one special character.';

String? validateSignUpPassword(
  String password, {
  String emptyMessage = 'Password cannot be empty',
  String? email,
  String? fullName,
}) {
  final trimmed = password.trim();
  if (trimmed.isEmpty) {
    return emptyMessage;
  }

  if (password.length < kMinPasswordLength) {
    return kSignUpPasswordRequirementsMessage;
  }

  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
  final hasDigit = RegExp(r'[0-9]').hasMatch(password);
  // Accept any non-alphanumeric (excluding whitespace) as a symbol.
  final hasSpecialCharacter = RegExp(r'[^A-Za-z0-9\s]').hasMatch(password);

  if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialCharacter) {
    return kSignUpPasswordRequirementsMessage;
  }

  // Kept for API compatibility with existing call sites/tests.
  if (email != null && fullName != null) {}
  return null;
}

/// Custom authentication exception class for user-friendly error messages
/// Note: Renamed to avoid conflict with Supabase's AuthException
class AuthServiceException implements Exception {
  final String message;
  final String? originalError;

  AuthServiceException(this.message, {this.originalError});

  @override
  String toString() => message;
}

/// Backend service for authentication and user management
/// Uses Supabase Auth for user authentication
///
/// Schema in Supabase Auth users table:
/// - uid (uuid, primary key, auto-generated)
/// - email (text, unique)
/// - display_name (text, from metadata)
/// - phone (text, nullable - not used for email provider)
/// - providers (text array - 'email' for email signup)
/// - created_at (timestamp)
/// - last_signed_in (timestamp)
class AuthService {
  final SupabaseClient _supabase;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Stream for content deep link routing (posts, stories, videos)
  /// Main.dart listens to this stream and routes to the content using GoRouter
  final _contentDeepLinkController =
      StreamController<DeepLinkRoute>.broadcast();
  Stream<DeepLinkRoute> get contentDeepLinkStream =>
      _contentDeepLinkController.stream;

  /// Set when app is opened from email confirmation link (BG_04). UI should show
  /// "Email verified successfully" and clear via [getAndClearPendingEmailVerifiedMessage].
  bool _pendingEmailVerifiedMessage = false;

  AuthService(this._supabase);

  /// Returns true once if we should show "Email verified successfully" (e.g. after opening from confirm link).
  bool getAndClearPendingEmailVerifiedMessage() {
    final v = _pendingEmailVerifiedMessage;
    _pendingEmailVerifiedMessage = false;
    return v;
  }

  // ============================================================================
  // Google Sign-In Initialization
  // ============================================================================

  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;

    if (Platform.isIOS) {
      try {
        // Prefer explicit iOS client id when available.
        await GoogleSignIn.instance.initialize(
          clientId: Env.googleIosClientId,
          serverClientId: Env.googleWebClientId,
        );
      } catch (e) {
        // Fallback to plist-based clientId in case env and shipped build drift.
        talker.warning(
          '[Google OAuth] iOS initialize with explicit clientId failed, retrying with plist clientId: $e',
        );
        await GoogleSignIn.instance.initialize(
          serverClientId: Env.googleWebClientId,
        );
      }
    } else {
      await GoogleSignIn.instance.initialize(
        // Use serverClientId only on Android where we need backend-verifiable ID tokens
        // tied to the Android/Firebase OAuth setup.
        serverClientId: Env.googleWebClientId,
      );
    }

    _googleSignInInitialized = true;
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Extract error message from various exception types
  ///
  /// Handles Supabase AuthException, PostgrestException, and generic exceptions
  String _extractErrorMessage(dynamic e) {
    // Handle Supabase AuthException directly
    if (e is AuthException) {
      return e.message;
    }

    // Handle PostgrestException
    if (e is PostgrestException) {
      return e.message;
    }

    // Try to extract message property dynamically
    try {
      final dynamic error = e;
      if (error.message != null && error.message is String) {
        return error.message as String;
      }
    } catch (_) {
      // Ignore if we can't extract message
    }

    return e.toString();
  }

  /// Start listening for deep links (both cold start and warm start)
  ///
  /// This method should be called once during app initialization in main.dart
  /// after Supabase has been initialized.
  ///
  /// Example usage in main.dart:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await Supabase.initialize(...);
  ///   SupabaseService.authService.startDeepLinkListener();
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// Handles two scenarios:
  /// 1. Cold start: App was not running when deep link was opened
  /// 2. Warm start: App was in background when deep link was opened
  ///
  /// For password reset deep links (myitihas://reset-password#access_token=...),
  /// this method:
  /// - Parses the URI fragment for Supabase tokens
  /// - Logs the captured information for debugging
  /// - Does NOT create a session or navigate (handled by GoRouter)
  Future<void> startDeepLinkListener() async {
    try {
      // Handle cold start: Check if app was launched with a deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        talker.debug('[Deep Link] Cold start with URI: $initialUri');
        _handleDeepLink(initialUri);
      }

      // Handle warm start: Listen for deep links while app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        (uri) {
          talker.debug('[Deep Link] Warm start with URI: $uri');
          _handleDeepLink(uri);
        },
        onError: (err) {
          talker.error('[Deep Link] Error: $err');
        },
      );
    } catch (e) {
      talker.error('[Deep Link] Failed to initialize deep link listener: $e');
    }
  }

  /// Handle incoming deep link URI
  ///
  /// Detects three types of deep links:
  /// 1. Auth links: password reset, OAuth callbacks (myitihas://reset-password, myitihas://login-callback)
  /// 2. Content links: HTTPS (https://myitihas.com/post/{uuid}) or custom scheme (myitihas://post/{uuid})
  /// 3. Other: ignored
  ///
  /// Auth links set internal flags/state; Content links are emitted via contentDeepLinkStream.
  /// Main.dart listens to contentDeepLinkStream and routes accordingly.
  ///
  /// DO NOT navigate here - GoRouter will handle navigation based on state.
  void _handleDeepLink(Uri uri) {
    talker.debug('[Deep Link] Received URI: $uri');
    talker.debug('[Deep Link] Scheme: ${uri.scheme}');
    talker.debug('[Deep Link] Host: ${uri.host}');
    talker.debug('[Deep Link] Path: ${uri.path}');
    talker.debug('[Deep Link] Query: ${uri.query}');
    talker.debug('[Deep Link] Fragment: ${uri.fragment}');

    // First, try to parse as auth link (custom scheme only)
    if (uri.scheme == 'myitihas') {
      switch (uri.host) {
        case 'reset-password':
          _handlePasswordResetDeepLink(uri);
          return;

        case 'login-callback':
          _handleOAuthCallbackDeepLink(uri);
          return;

        default:
          // Not an auth link, continue to check if it's a content link
          break;
      }
    }

    // Try to parse as content link (HTTPS or custom scheme)
    final contentRoute = DeepLinkService.parseDeepLink(uri);
    if (contentRoute != null) {
      talker.info('[Deep Link] Content deep link detected: $contentRoute');
      _contentDeepLinkController.add(contentRoute);
      return;
    }

    talker.debug('[Deep Link] Unknown URI type, ignoring');
  }

  /// Handle password reset deep link
  void _handlePasswordResetDeepLink(Uri uri) {
    talker.info('[Deep Link] Password reset deep link detected');

    // CRITICAL: Set recovery flag IMMEDIATELY
    // This prevents the auto-created Supabase session from being treated
    // as a normal login. GoRouter will see isRecovering=true and redirect
    // to /reset-password page, preventing access to authenticated routes.
    final refreshStream = SupabaseService.refreshStream;
    if (refreshStream != null) {
      refreshStream.setRecovering();
      talker.info(
        '[Deep Link] Recovery state activated - user will be forced to /reset-password',
      );
    } else {
      talker.warning(
        '[Deep Link] WARNING: RefreshStream not available, recovery state not set',
      );
    }
  }

  /// Handle OAuth callback deep link
  ///
  /// This is called after successful Google OAuth authentication.
  /// Supabase automatically handles the token exchange and session creation.
  /// We log the callback for debugging and let onAuthStateChange handle the rest.
  void _handleOAuthCallbackDeepLink(Uri uri) {
    talker.info('[Deep Link] OAuth callback deep link detected');

    // From email confirmation redirect (BG_04) - show success in app when we have context.
    // Some clients may drop custom query params while preserving Supabase type in query/fragment.
    final fragment = uri.fragment;
    final isEmailConfirm =
        uri.queryParameters['from_email_confirm'] == '1' ||
        uri.queryParameters['type'] == 'signup' ||
        fragment.contains('type=signup');
    if (isEmailConfirm) {
      _pendingEmailVerifiedMessage = true;
    }

    // Check for error in the callback
    if (fragment.contains('error=')) {
      talker.error('[Deep Link] OAuth callback contains error');
      // Parse error from fragment
      final params = Uri.splitQueryString(fragment);
      final error = params['error'] ?? 'unknown_error';
      final errorDescription =
          params['error_description'] ?? 'Authentication failed';
      talker.error('[Deep Link] OAuth error: $error - $errorDescription');
      // Note: Error handling is done by onAuthStateChange listener
    } else if (fragment.contains('access_token=') ||
        uri.queryParameters.containsKey('code')) {
      talker.info(
        '[Deep Link] OAuth callback contains token/code - authentication successful',
      );
      // Supabase will handle the token exchange automatically
      // onAuthStateChange will emit signedIn event
    } else {
      talker.debug('[Deep Link] OAuth callback format not recognized');
    }
  }

  /// Clean up deep link listener
  ///
  /// Should be called when the AuthService is disposed (typically never in practice
  /// since AuthService is a singleton that lives for the app lifetime)
  void dispose() {
    _linkSubscription?.cancel();
  }

  /// Update user password during password recovery flow
  ///
  /// IMPORTANT: This method is ONLY for password recovery flow, not for
  /// changing password while logged in.
  ///
  /// Password Recovery Flow:
  /// 1. User clicks reset link → Supabase PKCE creates recovery session
  /// 2. Deep link sets isRecovering=true → GoRouter redirects to /reset-password
  /// 3. User enters new password → This method is called
  /// 4. Update password → Sign out recovery session → Clear recovery state
  /// 5. GoRouter redirects to /login
  ///
  /// Why we sign out after password update:
  /// - The recovery session was created only for password reset
  /// - User should NOT remain logged in with the recovery session
  /// - User must sign in again with their new password to create a proper session
  /// - This ensures clean state and proper authentication flow
  ///
  /// Throws AuthServiceException with user-friendly error messages on failure
  Future<void> updatePassword(String newPassword) async {
    try {
      // Validate password
      if (newPassword.trim().isEmpty) {
        throw AuthServiceException('Password cannot be empty');
      }

      if (newPassword.length < kMinPasswordLength) {
        throw AuthServiceException(
          'Password must be at least $kMinPasswordLength characters long',
        );
      }

      talker.debug('[Password Update] Updating password...');

      // Update password using Supabase
      // This works because we're in a recovery session created by PKCE
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      talker.info('[Password Update] Password updated successfully');

      // CRITICAL: Sign out the recovery session
      // We MUST terminate the recovery session to prevent:
      // 1. User staying logged in with recovery session
      // 2. Recovery session persisting across app restarts
      // 3. User accessing authenticated routes without proper login
      talker.debug('[Password Update] Signing out recovery session...');
      await _supabase.auth.signOut();
      talker.debug('[Password Update] Recovery session signed out');

      // CRITICAL: Clear recovery state
      // This allows GoRouter to resume normal authentication routing
      // User will be redirected to /login page
      final refreshStream = SupabaseService.refreshStream;
      if (refreshStream != null) {
        refreshStream.clearRecovery();
        talker.info(
          '[Password Update] Recovery state cleared - routing to login',
        );
      } else {
        talker.warning(
          '[Password Update] WARNING: RefreshStream not available',
        );
      }
    } on AuthServiceException {
      // Re-throw our custom exceptions
      rethrow;
    } on AuthException catch (e) {
      talker.error('[Password Update] AuthException: ${e.message}');
      throw AuthServiceException(
        _getPasswordUpdateErrorMessage(e.message),
        originalError: e.message,
      );
    } catch (e) {
      talker.error('[Password Update] Error: $e');

      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getPasswordUpdateErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Convert password update errors to user-friendly messages
  String _getPasswordUpdateErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return 'Network error. Please check your connection and try again.';
    }

    if (lowerError.contains('invalid') ||
        lowerError.contains('expired') ||
        lowerError.contains('token')) {
      return 'Password reset link has expired. Please request a new one.';
    }

    if (lowerError.contains('weak') || lowerError.contains('password')) {
      return 'Password does not meet requirements. Please use a stronger password.';
    }

    if (lowerError.contains('same password') ||
        lowerError.contains('different from')) {
      return 'New password must be different from your previous password.';
    }

    return 'Failed to update password. Please try again.';
  }

  /// Sign up a new user using Supabase Auth
  ///
  /// Parameters:
  /// - email: User's email address
  /// - password: User's password (will be hashed by Supabase)
  /// - fullName: User's full name (stored in user_metadata as display_name)
  ///
  /// Returns AuthResponse with user session on success.
  /// Note: If email confirmation is enabled in Supabase, session will be null
  /// until the user confirms their email.
  ///
  /// Throws AuthServiceException with user-friendly error messages on failure
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Validate inputs
      if (email.trim().isEmpty) {
        throw AuthServiceException('Email cannot be empty');
      }
      if (password.trim().isEmpty) {
        throw AuthServiceException('Password cannot be empty');
      }
      if (fullName.trim().isEmpty) {
        throw AuthServiceException('Full name cannot be empty');
      }

      // Email format validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(email.trim())) {
        throw AuthServiceException('Please enter a valid email address');
      }

      // Password strength validation
      final passwordValidationMessage = validateSignUpPassword(password);
      if (passwordValidationMessage != null) {
        throw AuthServiceException(passwordValidationMessage);
      }

      final normalizedEmail = email.trim().toLowerCase();

      // Proactively block duplicate-email signups with our admin-backed checker.
      // This avoids Supabase anti-enumeration "soft success" responses being
      // interpreted as successful account creation in edge cases.
      final precheckAlreadyRegistered = await _isEmailRegisteredForSignUp(
        normalizedEmail,
      );
      if (precheckAlreadyRegistered == true) {
        throw AuthServiceException(
          _emailAlreadyExistsMessage,
          originalError: 'signup_duplicate_email_precheck',
        );
      }

      // Sign up using Supabase Auth.
      // Route email confirmation through our hosted redirect page so users never
      // land on a blank browser screen; the page opens the app and passes
      // from_email_confirm=1 to login-callback for in-app success messaging.
      AuthResponse response;
      try {
        response = await _supabase.auth.signUp(
          email: normalizedEmail,
          password: password,
          emailRedirectTo:
              '${Env.supabaseUrl}/functions/v1/auth-email-confirm-redirect',
          data: {'display_name': fullName.trim(), 'full_name': fullName.trim()},
        );
      } on AuthException catch (e) {
        final messageLower = e.message.toLowerCase();
        final codeLower = e.code?.toLowerCase() ?? '';
        final isRedirectUrlError =
            messageLower.contains('redirect') &&
                (messageLower.contains('not allowed') ||
                    messageLower.contains('invalid')) ||
            codeLower.contains('redirect');

        if (!isRedirectUrlError) {
          rethrow;
        }

        // Do not silently retry without redirect, because that can send users to
        // a generic web page and reproduce the "blank page after email confirm"
        // issue. Surface a clear action for environment setup instead.
        throw AuthServiceException(
          'Email verification is temporarily unavailable due to a sign-up link configuration issue. Please try again shortly.',
          originalError: e.message,
        );
      }

      // Supabase does not always return an explicit error for duplicate email
      // (anti-enumeration behavior can return a soft-success payload).
      // When the email already exists, response.user.identities is often null/empty.
      if (response.user != null) {
        final identities = response.user!.identities;
        if (identities == null || identities.isEmpty) {
          throw AuthServiceException(
            _emailAlreadyExistsMessage,
            originalError: 'signup_duplicate_email',
          );
        }
      }

      // Check if email confirmation is required
      // When email confirmation is enabled, session will be null until confirmed
      final requiresEmailConfirmation = response.session == null;

      if (requiresEmailConfirmation) {
        // Some Supabase responses may omit user details while still succeeding.
        // For user==null, re-check registration after sign-up to distinguish:
        // - true  -> duplicate email
        // - false -> accepted signup with delayed payload
        // - null  -> unverifiable state (fail safely instead of false success)
        if (response.user == null) {
          final postCheckAlreadyRegistered = await _isEmailRegisteredForSignUp(
            normalizedEmail,
          );
          if (postCheckAlreadyRegistered == true) {
            throw AuthServiceException(
              _emailAlreadyExistsMessage,
              originalError: 'signup_duplicate_email_postcheck',
            );
          }
          if (postCheckAlreadyRegistered == null) {
            throw AuthServiceException(
              'We couldn\'t verify account creation right now. Please try again.',
              originalError: 'signup_unverifiable_response',
            );
          }

          talker.warning(
            '[Signup] Accepted with delayed user payload for: $normalizedEmail',
          );
          return response;
        }

        talker.info(
          '[Signup] Email confirmation required for user: ${response.user!.id}',
        );
        // Do NOT insert into users/profiles here: with no session, RLS blocks
        // client inserts. User and profile will be created on first sign-in
        // after they confirm email (see ensureUserAndProfileAfterSignIn).
        return response;
      }

      // No email confirmation required: we should have a user + session.
      final createdUser = response.user ?? _supabase.auth.currentUser;
      if (createdUser == null) {
        throw AuthServiceException(
          'Account was created, but we couldn\'t finish sign-in. Please log in to continue.',
          originalError: 'signup_missing_user_after_session',
        );
      }

      // Insert users + profile now that we have a concrete auth user id.
      try {
        final userId = createdUser.id;
        final username = _generateUsername(email, fullName);

        await _supabase.from('users').insert({
          'id': userId,
          'email': normalizedEmail,
          'full_name': fullName.trim(),
          'username': username,
          'avatar_url': null,
          'bio': '',
          'is_online': true,
          'last_seen': DateTime.now().toIso8601String(),
        });

        talker.info(
          '[Signup] User added to public.users table with id: $userId',
        );

        await createProfileAfterSignup(
          userId: userId,
          username: username,
          fullName: fullName.trim(),
          avatarUrl: null,
        );
      } catch (e) {
        final errorString = _extractErrorMessage(e);
        final lower = errorString.toLowerCase();
        if (lower.contains('duplicate key') ||
            (lower.contains('unique') && lower.contains('email'))) {
          throw AuthServiceException(
            _emailAlreadyExistsMessage,
            originalError: errorString,
          );
        }
        // Surface other DB/RLS failures so user sees a clear message instead of silent partial success
        talker.error(
          '[Signup] Failed to add user to public.users table: $errorString',
        );
        throw AuthServiceException(
          _getSignUpErrorMessage(errorString),
          originalError: errorString,
        );
      }

      return response;
    } on AuthServiceException {
      // Re-throw our custom AuthServiceException as-is (already user-friendly)
      rethrow;
    } on AuthException catch (e) {
      final code = e.code;
      talker.error('[Signup] AuthException: message=${e.message}, code=$code');
      throw AuthServiceException(
        _getSignUpErrorMessage(e.message, code: code),
        originalError: e.message,
      );
    } catch (e) {
      // Handle all other errors (network, Postgrest, etc.)
      final errorString = _extractErrorMessage(e);
      print('[Signup] Unmapped error (for diagnosis): $errorString');
      final errorMessage = _getSignUpErrorMessage(errorString);
      throw AuthServiceException(errorMessage, originalError: errorString);
    }
  }

  /// Sign in with email and password
  ///
  /// Parameters:
  /// - email: User's email address
  /// - password: User's password
  ///
  /// Returns AuthResponse with user session on success
  /// Throws AuthServiceException with user-friendly error messages on failure
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Validate inputs
      if (email.trim().isEmpty) {
        throw AuthServiceException('Email cannot be empty');
      }
      if (password.trim().isEmpty) {
        throw AuthServiceException('Password cannot be empty');
      }

      // Email format validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(email.trim())) {
        throw AuthServiceException('Please enter a valid email address');
      }

      // Sign in using Supabase Auth
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      // Check if sign in was successful
      if (response.user == null) {
        throw AuthServiceException('Failed to sign in. Please try again.');
      }

      // If user signed up with email confirmation, users/profile may not exist yet; create them now
      await ensureUserAndProfileAfterSignIn();

      return response;
    } on AuthServiceException {
      // Re-throw our custom AuthServiceException as-is (already user-friendly)
      rethrow;
    } on AuthException catch (e) {
      print('[SignIn] AuthException: ${e.message}');
      throw AuthServiceException(
        _getSignInErrorMessage(e.message),
        originalError: e.message,
      );
    } catch (e) {
      // Handle all other errors
      final errorString = _extractErrorMessage(e);
      final errorMessage = _getSignInErrorMessage(errorString);
      throw AuthServiceException(errorMessage, originalError: errorString);
    }
  }

  /// Get current authenticated user
  /// Returns User if authenticated, null otherwise
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  /// Check if user is currently authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  /// Get the authentication provider for the current user
  ///
  /// Returns 'google' for Google OAuth users, 'email' for email/password users
  String getAuthProvider() {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'email';

    final provider = user.appMetadata['provider'] as String?;
    if (provider == 'google') return 'google';
    if (provider == 'apple') return 'apple';
    return 'email';
  }

  /// Re-authenticate with email/password
  ///
  /// Used before destructive operations like account deletion to verify identity.
  /// Throws AuthServiceException if credentials are invalid.
  Future<void> reauthenticateWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      print('[Reauth] AuthException: ${e.message}');
      throw AuthServiceException(
        _getSignInErrorMessage(e.message),
        originalError: e.message,
      );
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getSignInErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Re-authenticate with Google using native SDK
  ///
  /// Uses the native Google Sign-In SDK for inline re-authentication.
  /// No browser redirect needed — returns synchronously after user confirms.
  /// Used before destructive operations like account deletion to verify identity.
  Future<void> reauthenticateWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();

      // Force interactive authentication for re-auth
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw AuthServiceException('Failed to verify Google identity');
      }

      // Verify by signing in with idToken (refreshes Supabase session)
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthServiceException('Re-authentication was cancelled.');
      }
      throw AuthServiceException(
        _getOAuthErrorMessage(e.toString()),
        originalError: e.toString(),
      );
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getOAuthErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Delete the current user's account via edge function
  ///
  /// Calls the delete-user-account edge function which:
  /// 1. Verifies the JWT matches the userId
  /// 2. Cleans up storage buckets
  /// 3. Deletes the auth user (cascading through all DB tables)
  ///
  /// Throws AuthServiceException on failure
  Future<void> deleteAccount() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw AuthServiceException('No authenticated user found');
    }

    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw AuthServiceException('No active session. Please sign in again.');
    }

    try {
      talker.debug(
        '[DeleteAccount] Invoking delete-user-account edge function...',
      );

      final response = await _supabase.functions.invoke(
        'delete-user-account',
        body: {'userId': user.id},
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      if (response.status != 200) {
        final errorData = response.data;
        final rawErrorMsg = errorData is Map
            ? (errorData['error'] as String? ?? 'Unknown error')
            : 'Failed to delete account. Please try again.';
        final userMessage = _getDeleteAccountErrorMessage(rawErrorMsg);
        talker.error(
          '[DeleteAccount] Edge function error (${response.status}): $rawErrorMsg',
        );
        throw AuthServiceException(userMessage, originalError: rawErrorMsg);
      }

      talker.info('[DeleteAccount] Account deleted successfully');
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      talker.error('[DeleteAccount] Error: $errorString');
      throw AuthServiceException(
        _getDeleteAccountErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Sign out the current user
  ///
  /// Signs out of Google (if signed in via native SDK) and then Supabase.
  /// Throws AuthServiceException with context about the failure on error
  Future<void> signOut() async {
    try {
      // Sign out of Google if signed in via native SDK
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Google sign out is best-effort
      }
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      talker.error('[SignOut] AuthException: ${e.message}');
      throw AuthServiceException(
        'Failed to sign out. Please try again.',
        originalError: e.message,
      );
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      talker.error('[SignOut] Error: $errorString');
      throw AuthServiceException(
        'Failed to sign out. Please try again.',
        originalError: errorString,
      );
    }
  }

  /// Sign in with Google using native SDK
  ///
  /// Uses the native Google Sign-In SDK for inline authentication.
  /// Returns AuthResponse with user session on success.
  /// Throws AuthServiceException if sign-in fails or is cancelled.
  Future<AuthResponse> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final googleSignIn = GoogleSignIn.instance;

      // Try lightweight (silent) auth first, fall back to interactive
      GoogleSignInAccount? googleUser;
      try {
        final lightweightFuture = googleSignIn
            .attemptLightweightAuthentication();
        if (lightweightFuture != null) {
          googleUser = await lightweightFuture;
        }
      } catch (e) {
        // Silent auth failures are non-fatal. Continue to interactive chooser.
        talker.warning(
          '[Google OAuth] Lightweight auth failed, continuing with interactive sign-in: $e',
        );
      }

      googleUser ??= await googleSignIn.authenticate();

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw AuthServiceException('Failed to get Google ID token');
      }

      // Get access token via authorization (optional for signInWithIdToken)
      String? accessToken;
      try {
        final authorization = await googleUser.authorizationClient
            .authorizationForScopes(['email', 'profile']);
        accessToken = authorization?.accessToken;
        if (accessToken == null) {
          final newAuth = await googleUser.authorizationClient.authorizeScopes([
            'email',
            'profile',
          ]);
          accessToken = newAuth.accessToken;
        }
      } catch (e) {
        print('[Google OAuth] Access token retrieval failed (non-fatal): $e');
      }

      // Sign in to Supabase with the native tokens
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw AuthServiceException('Failed to sign in with Google');
      }

      // Create user in public.users if first time, or update avatar for existing users
      try {
        // Debug: Print all available metadata to find the correct avatar field
        talker.debug(
          '[Google OAuth] User Metadata: ${response.user!.userMetadata}',
        );
        talker.debug(
          '[Google OAuth] User App Metadata: ${response.user!.appMetadata}',
        );

        // Extract Google profile photo URL (can be null)
        // Try multiple possible field names where Google might store the avatar
        final googleAvatarUrl =
            response.user!.userMetadata?['avatar_url'] as String? ??
            response.user!.userMetadata?['picture'] as String? ??
            response.user!.userMetadata?['photo_url'] as String? ??
            response.user!.userMetadata?['photoURL'] as String?;

        talker.debug('[Google OAuth] Extracted Avatar URL: $googleAvatarUrl');

        final existing = await _supabase
            .from('users')
            .select('id, avatar_url')
            .eq('id', response.user!.id)
            .maybeSingle();

        if (existing == null) {
          // New user - create record
          final email = response.user!.email ?? '';
          final fullName =
              response.user!.userMetadata?['full_name'] as String? ??
              response.user!.userMetadata?['name'] as String? ??
              '';
          final username = _generateUsername(email, fullName);

          talker.debug(
            '[Google OAuth] Creating new user with avatar: $googleAvatarUrl',
          );

          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'username': username,
            'avatar_url': googleAvatarUrl,
            'bio': '',
            'is_online': true,
            'last_seen': DateTime.now().toIso8601String(),
          });

          await createProfileAfterSignup(
            userId: response.user!.id,
            username: username,
            fullName: fullName,
            avatarUrl: googleAvatarUrl,
          );
        } else {
          // Existing user - update avatar if it's missing and we have one from Google
          final currentAvatarUrl = existing['avatar_url'] as String?;
          if ((currentAvatarUrl == null || currentAvatarUrl.isEmpty) &&
              googleAvatarUrl != null &&
              googleAvatarUrl.isNotEmpty) {
            talker.debug(
              '[Google OAuth] Updating existing user avatar: $googleAvatarUrl',
            );

            // Update users table
            await _supabase
                .from('users')
                .update({
                  'avatar_url': googleAvatarUrl,
                  'is_online': true,
                  'last_seen': DateTime.now().toIso8601String(),
                })
                .eq('id', response.user!.id);

            // Update profiles table
            await _supabase
                .from('profiles')
                .update({'avatar_url': googleAvatarUrl})
                .eq('id', response.user!.id);

            talker.info('[Google OAuth] Avatar updated successfully');
          } else {
            // Just update online status
            await _supabase
                .from('users')
                .update({
                  'is_online': true,
                  'last_seen': DateTime.now().toIso8601String(),
                })
                .eq('id', response.user!.id);
          }
        }
      } catch (e) {
        talker.warning(
          '[Google OAuth] Warning: Failed to sync user record: $e',
        );
      }

      return response;
    } on GoogleSignInException catch (e) {
      talker.error('[Google OAuth] GoogleSignInException: code=${e.code}, $e');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthServiceException('Sign in was cancelled.');
      }
      throw AuthServiceException(
        _getOAuthErrorMessage(e.toString()),
        originalError: e.toString(),
      );
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      talker.error('[Google OAuth] Unexpected error: ${e.runtimeType}: $e');
      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getOAuthErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Sign in with Apple using native Sign in with Apple.
  ///
  /// This uses Apple to produce an `identityToken` and sends it to Supabase
  /// via `signInWithIdToken(provider: OAuthProvider.apple, idToken: ...)`.
  Future<AuthResponse> signInWithApple() async {
    try {
      if (!Platform.isIOS) {
        throw AuthServiceException(
          'Sign in with Apple is only supported on iOS.',
        );
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw AuthServiceException('Failed to get Apple identity token');
      }

      // Create/refresh Supabase session using the Apple identity token.
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
      );

      if (response.user == null) {
        throw AuthServiceException('Failed to sign in with Apple');
      }

      // Apple only provides full name on the first sign-in. Best-effort:
      final fullName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
          .trim()
          .replaceAll(RegExp(r'\\s+'), ' ');

      if (fullName.isNotEmpty) {
        try {
          await _supabase.auth.updateUser(
            UserAttributes(
              data: {
                'full_name': fullName,
                'display_name': fullName,
              },
            ),
          );
        } catch (e) {
          // Metadata update is non-fatal; user/profile can still be created.
          talker.warning('[Apple OAuth] Failed to update user metadata: $e');
        }
      }

      await ensureUserAndProfileAfterSignIn();
      return response;
    } on AuthServiceException {
      rethrow;
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getAppleOAuthErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Convert OAuth errors to user-friendly messages
  String _getOAuthErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('cancelled') || lowerError.contains('canceled')) {
      return 'Sign in was cancelled. Please try again.';
    }

    // Handle case where email already registered with password
    if (lowerError.contains('already') ||
        lowerError.contains('exists') ||
        lowerError.contains('registered') ||
        lowerError.contains('duplicate')) {
      return 'This email is already registered with a password. Please login with your password or use "Forgot Password" to reset it.';
    }

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return 'Network error. Please check your connection and try again.';
    }

    if (lowerError.contains('popup') || lowerError.contains('blocked')) {
      return 'Sign in popup was blocked. Please allow popups and try again.';
    }

    if (lowerError.contains('developer_error') ||
        lowerError.contains('invalid_audience') ||
        lowerError.contains('invalid client') ||
        lowerError.contains('client_id') ||
        lowerError.contains('id token')) {
      return 'Google sign in configuration mismatch. Please update app and try again.';
    }

    if (lowerError.contains('provider') || lowerError.contains('google')) {
      return 'Google sign in is not available. Please try again later.';
    }

    return 'Failed to sign in with Google. Please try again.';
  }

  /// Convert Apple OAuth errors to user-friendly messages
  String _getAppleOAuthErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('cancel') || lowerError.contains('canceled')) {
      return 'Sign in was cancelled. Please try again.';
    }

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    if (lowerError.contains('not available') ||
        lowerError.contains('disabled') ||
        lowerError.contains('configuration')) {
      return 'Sign in with Apple is not available right now. Please try again later.';
    }

    return 'Failed to sign in with Apple. Please try again.';
  }

  /// Send password reset email
  ///
  /// Sends a password reset email to the specified address
  /// User will receive an email with a link to reset their password
  ///
  /// Throws AuthServiceException with user-friendly error messages on failure
  Future<void> resetPasswordForEmail(String email) async {
    try {
      // Validate email input
      if (email.trim().isEmpty) {
        throw AuthServiceException('Please enter your email address');
      }

      // Email format validation
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(email.trim())) {
        throw AuthServiceException('Please enter a valid email address');
      }

      final normalizedEmail = email.trim().toLowerCase();

      // Check if email is registered (so we can show "No account found").
      // If we cannot reliably verify registration, we fail the flow instead of
      // incorrectly claiming that a reset email was sent.
      bool? registered;
      try {
        talker.info(
          '[Password Reset] Checking if email is registered: $normalizedEmail',
        );

        final checkResponse = await _supabase.functions.invoke(
          'forgot-password',
          body: {'email': normalizedEmail},
        );

        talker.info(
          '[Password Reset] Got response from forgot-password function',
        );
        talker.info(
          '[Password Reset] Response status: ${checkResponse.status}',
        );
        talker.info(
          '[Password Reset] Response data type: ${checkResponse.data.runtimeType}',
        );
        talker.info('[Password Reset] Response data: ${checkResponse.data}');

        if (checkResponse.status == 200 && checkResponse.data is Map) {
          final data = checkResponse.data as Map;
          talker.info(
            '[Password Reset] Response is valid Map. Keys: ${data.keys}',
          );
          talker.info(
            '[Password Reset] data["registered"] = ${data['registered']} (type: ${data['registered'].runtimeType})',
          );

          registered = data['registered'] == true;
          talker.info('[Password Reset] Parsed registered value: $registered');
        } else {
          talker.error(
            '[Password Reset] Invalid response status or data type. Status: ${checkResponse.status}, DataType: ${checkResponse.data.runtimeType}',
          );
          throw AuthServiceException(
            'We couldn\'t verify this email right now. Please try again.',
          );
        }
      } on AuthServiceException {
        talker.error(
          '[Password Reset] AuthServiceException during registration check: caught and rethrowing',
        );
        rethrow;
      } catch (e) {
        talker.error(
          '[Password Reset] Unexpected error during registration check: $e (type: ${e.runtimeType})',
        );
        throw AuthServiceException(
          'We couldn\'t verify this email right now. Please try again.',
        );
      }

      talker.info(
        '[Password Reset] About to check registered value. registered=$registered',
      );
      if (registered == false) {
        talker.info(
          '[Password Reset] Email is NOT registered. Throwing error.',
        );
        throw AuthServiceException('No account found with this email.');
      }

      talker.info(
        '[Password Reset] Registration check passed or inconclusive. Proceeding with reset email.',
      );

      // Send password reset email.
      // Use HTTPS redirect URL so the link opens our auth-reset-redirect Edge Function,
      // which returns a page that opens the app (fixes blank page on Android when
      // opening myitihas:// directly from browser).
      await _supabase.auth.resetPasswordForEmail(
        normalizedEmail,
        redirectTo: '${Env.supabaseUrl}/functions/v1/auth-reset-redirect',
      );
    } on AuthServiceException {
      rethrow;
    } on AuthException catch (e) {
      talker.error('[Password Reset] AuthException: ${e.message}');
      throw AuthServiceException(
        _getPasswordResetErrorMessage(e.message),
        originalError: e.message,
      );
    } catch (e) {
      final errorString = _extractErrorMessage(e);
      throw AuthServiceException(
        _getPasswordResetErrorMessage(errorString),
        originalError: errorString,
      );
    }
  }

  /// Convert password reset errors to user-friendly messages
  String _getPasswordResetErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return 'Network error. Please check your connection and try again.';
    }

    if (lowerError.contains('rate limit') ||
        lowerError.contains('too many requests')) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    if (lowerError.contains('not found') || lowerError.contains('no user')) {
      // Don't reveal if email exists or not for security
      return 'If an account exists with this email, you will receive a reset link.';
    }

    return 'Failed to send password reset email. Please try again.';
  }

  /// Ensures public.users and profiles rows exist for the current user.
  /// Called after sign-in so that users who signed up with email confirmation
  /// (and had no session at signup) get their users/profile created on first login.
  Future<void> ensureUserAndProfileAfterSignIn() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final existing = await _supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      if (existing != null) return; // Already have profile
    } catch (_) {
      return;
    }

    final email = user.email ?? '';
    final fullName =
        (user.userMetadata?['full_name'] ??
                user.userMetadata?['display_name'] ??
                '')
            .toString()
            .trim();
    final username = _generateUsername(
      email,
      fullName.isEmpty ? 'User' : fullName,
    );

    try {
      await _supabase.from('users').insert({
        'id': user.id,
        'email': email,
        'full_name': fullName,
        'username': username,
        'avatar_url': null,
        'bio': '',
        'is_online': true,
        'last_seen': DateTime.now().toIso8601String(),
      });
      await createProfileAfterSignup(
        userId: user.id,
        username: username,
        fullName: fullName.isEmpty ? 'User' : fullName,
        avatarUrl: null,
      );
      print('[Auth] Created users/profile for ${user.id} on first sign-in');
    } catch (e) {
      print('[Auth] ensureUserAndProfileAfterSignIn: $e');
      // Don't throw - sign-in succeeded; profile can be retried later
    }
  }

  /// Create a profile record after successful signup
  ///
  /// This method is called after Supabase auth.signUp() succeeds to create
  /// a corresponding row in the profiles table. This is done separately because:
  /// - Auth user creation and profile creation have different failure modes
  /// - Profiles table may have stricter validation or RLS policies
  /// - Allows retry logic if profile creation fails without re-creating auth user
  ///
  /// Parameters:
  /// - userId: UUID from authenticated user (auth.uid())
  /// - username: Generated or provided unique username
  /// - fullName: User's full display name
  ///
  /// Throws AuthServiceException if profile creation fails
  Future<void> createProfileAfterSignup({
    required String userId,
    required String username,
    required String fullName,
    String? avatarUrl,
  }) async {
    try {
      // Verify we have an authenticated user
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null || currentUser.id != userId) {
        throw AuthServiceException(
          'Cannot create profile: user not authenticated',
        );
      }

      talker.debug('[Profile Creation] Creating profile for user: $userId');

      // Insert into profiles table
      // RLS policy ensures auth.uid() = id, so this will only work for the authenticated user
      await _supabase.from('profiles').insert({
        'id': userId, // Must match auth.uid() for RLS
        'username': username,
        'full_name': fullName,
        'avatar_url': avatarUrl, // Set from Google profile photo if available
        'bio': null, // Nullable - can be set later
        'is_private': false, // Default value
      });

      talker.info(
        '[Profile Creation] Profile created successfully for user: $userId',
      );
    } on PostgrestException catch (e) {
      talker.error('[Profile Creation] Postgres error: ${e.message}');

      // Handle duplicate username error specifically
      if (e.code == '23505' && e.message.toLowerCase().contains('username')) {
        throw AuthServiceException('Username already taken. Please try again.');
      }

      // Handle other database errors
      throw AuthServiceException(
        'Failed to create user profile. Please contact support.',
      );
    } catch (e) {
      talker.error('[Profile Creation] Error: $e');

      // Don't rethrow AuthServiceException - already handled above
      if (e is AuthServiceException) {
        rethrow;
      }

      // Generic error
      throw AuthServiceException(
        'Failed to create user profile. Please try again.',
      );
    }
  }

  /// User-friendly message when sign-up fails because the email is already in use (BG_08).
  static const String _emailAlreadyExistsMessage =
      'Email already registered. Please log in or use a different email address.';

  /// Returns true/false when known, or null when verification is unavailable.
  Future<bool?> _isEmailRegisteredForSignUp(String normalizedEmail) async {
    try {
      final checkResponse = await _supabase.functions.invoke(
        'forgot-password',
        body: {'email': normalizedEmail},
      );

      if (checkResponse.status == 200 && checkResponse.data is Map) {
        final data = checkResponse.data as Map;
        return data['registered'] == true;
      }
    } catch (e) {
      talker.warning('[Signup] Email pre-check unavailable: ${e.toString()}');
    }
    return null;
  }

  /// Sign-up specific error mapping. Uses [code] when present (e.g. from AuthException), then message patterns.
  String _getSignUpErrorMessage(String error, {String? code}) {
    final codeLower = code?.toLowerCase();
    final lowerError = error.toLowerCase();

    // Supabase plan limits (Auth MAU quota, etc.) - 402 / exceed_mau_quota
    if (codeLower == 'exceed_mau_quota' ||
        lowerError.contains('exceed_mau_quota') ||
        lowerError.contains('mau quota') ||
        lowerError.contains('monthly active users') ||
        lowerError.contains('quota exceeded') ||
        lowerError.contains('account limit')) {
      return 'Account creation is temporarily limited. Please try again later or contact support.';
    }

    // Map known Supabase Auth API error codes first
    if (codeLower == 'signup_not_allowed') {
      return 'Account creation is not available right now. Please contact support.';
    }
    if (codeLower == 'email_not_allowed' ||
        codeLower == 'email_domain_not_allowed') {
      return 'This email address cannot be used for sign up. Please use a different email address.';
    }
    if (codeLower == 'signup_requires_valid_password') {
      return kSignUpPasswordRequirementsMessage;
    }
    if (codeLower == 'forbidden' || codeLower == 'access_denied') {
      return 'Account creation is not allowed. Please contact support.';
    }
    if (lowerError.contains('database error saving new user') ||
        lowerError.contains('unexpected_failure')) {
      return 'We couldn\'t create your account due to a temporary server issue. Please try again in a moment.';
    }
    if (lowerError.contains('redirect') &&
        (lowerError.contains('not allowed') ||
            lowerError.contains('invalid'))) {
      return 'Account creation is temporarily unavailable due to a sign-up link configuration issue. Please try again shortly.';
    }
    return _getErrorMessage(error);
  }

  /// Convert error messages to user-friendly format (signup and related flows)
  String _getErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    // Handle "email already exists" / "already registered" (BG_08: clear, specific message)
    if (lowerError.contains('user already registered') ||
        lowerError.contains('email already exists') ||
        lowerError.contains('already registered') ||
        lowerError.contains('email address is already registered') ||
        lowerError.contains('user with this email already exists') ||
        lowerError.contains('has already been registered') ||
        (lowerError.contains('already exists') &&
            lowerError.contains('email')) ||
        lowerError.contains('duplicate key') ||
        (lowerError.contains('unique constraint') &&
            lowerError.contains('email'))) {
      return _emailAlreadyExistsMessage;
    }

    if (lowerError.contains('invalid email') ||
        lowerError.contains('email format is invalid') ||
        lowerError.contains('valid email')) {
      return 'Please enter a valid email address.';
    }

    if ((lowerError.contains('password') && lowerError.contains('weak')) ||
        lowerError.contains('password is too weak') ||
        lowerError.contains('password does not meet requirements') ||
        lowerError.contains('signup requires a valid password')) {
      return kSignUpPasswordRequirementsMessage;
    }

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    if (lowerError.contains('rate limit') ||
        lowerError.contains('too many requests') ||
        lowerError.contains('429')) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    if (lowerError.contains('signup_disabled') ||
        lowerError.contains('signup is disabled') ||
        lowerError.contains('signup not allowed') ||
        lowerError.contains('signup_not_allowed')) {
      return 'Account creation is temporarily disabled. Please contact support.';
    }

    // Disposable / restricted email domain (e.g. hooks or provider config)
    if (lowerError.contains('disposable') ||
        lowerError.contains('email domain') ||
        lowerError.contains('email not allowed') ||
        lowerError.contains('domain not allowed')) {
      return 'This email address cannot be used for sign up. Please use a different email address.';
    }

    if (lowerError.contains('forbidden') || lowerError.contains('blocked')) {
      return 'Account creation is not allowed. Please contact support.';
    }

    // Server-side or configuration issues
    if (lowerError.contains('internal server error') ||
        lowerError.contains('500') ||
        lowerError.contains('server error')) {
      return 'We\'re having trouble creating your account right now. Please try again in a few minutes.';
    }

    if (lowerError.contains('unprocessable') ||
        lowerError.contains('422') ||
        lowerError.contains('bad request')) {
      return 'We couldn\'t process your sign up. Please check your details and try again.';
    }

    if (lowerError.contains('invalid credentials') ||
        lowerError.contains('authentication failed')) {
      return 'Authentication failed. Please check your credentials and try again.';
    }

    // RLS / permission errors when inserting users/profile
    if (lowerError.contains('row-level security') ||
        lowerError.contains('rls') && lowerError.contains('policy') ||
        lowerError.contains('permission denied') ||
        lowerError.contains('new row violates')) {
      return 'We couldn\'t complete your registration. Please try again or contact support.';
    }

    // Generic fallback: still user-friendly but suggest next steps
    return 'We couldn\'t create your account. Please check your information and try again, or use a different email address. If the problem continues, contact support.';
  }

  /// Generate a unique username from email or full name
  ///
  /// Uses UUID-based suffix to guarantee uniqueness
  String _generateUsername(String email, String fullName) {
    // Try to use part before @ in email
    String username = email.split('@')[0];

    // Remove special characters and make lowercase
    username = username.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_').toLowerCase();

    // Truncate if too long (leave room for suffix)
    if (username.length > 20) {
      username = username.substring(0, 20);
    }

    // Add random alphanumeric suffix to ensure uniqueness
    // Using random chars instead of timestamp for better collision resistance
    final random = Random.secure();
    final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final suffix = List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    username = '${username}_$suffix';

    return username;
  }

  /// Convert delete-account errors to user-friendly messages
  String _getDeleteAccountErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup')) {
      return 'Network error while deleting your account. Please check your internet connection and try again.';
    }

    if (lowerError.contains('invalid or expired authentication token') ||
        lowerError.contains('jwt expired') ||
        lowerError.contains('session') && lowerError.contains('expired')) {
      return 'Your session has expired. Please sign in again and then retry deleting your account.';
    }

    if (lowerError.contains('no authenticated user found') ||
        lowerError.contains('no active session')) {
      return 'You are not signed in. Please sign in again and then retry deleting your account.';
    }

    if (lowerError.contains('missing supabase_url') ||
        lowerError.contains('missing supabase_service_role_key')) {
      return 'Account deletion is temporarily unavailable due to a server configuration issue. Please try again later or contact support.';
    }

    if (lowerError.contains('you can only delete your own account') ||
        lowerError.contains('forbidden') && lowerError.contains('delete')) {
      return 'You can only delete your own account. Please sign in with the correct account and try again.';
    }

    if (lowerError.contains('failed to delete account. please try again.')) {
      // This is the generic message returned from the Edge Function on a 500.
      // Provide a slightly more actionable version for the user.
      return 'We could not delete your account right now. Please try again in a few minutes. If the problem continues, contact support.';
    }

    return 'We could not delete your account. Please try again. If this keeps happening, contact support.';
  }

  /// Convert sign-in error messages to user-friendly format
  String _getSignInErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    // Handle Supabase Auth specific errors for sign in
    if (lowerError.contains('invalid login credentials') ||
        lowerError.contains('invalid credentials') ||
        lowerError.contains('wrong password') ||
        lowerError.contains('incorrect password') ||
        lowerError.contains('email not confirmed')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }

    if (lowerError.contains('user not found') ||
        lowerError.contains('email not found')) {
      return 'No account found with this email. Please sign up first.';
    }

    if (lowerError.contains('invalid email') ||
        lowerError.contains('email format is invalid') ||
        lowerError.contains('valid email')) {
      return 'Please enter a valid email address.';
    }

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout') ||
        lowerError.contains('socketexception') ||
        lowerError.contains('failed host lookup')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    if (lowerError.contains('rate limit') ||
        lowerError.contains('too many requests') ||
        lowerError.contains('429')) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    if (lowerError.contains('email not confirmed') ||
        lowerError.contains('verify your email')) {
      return 'Please verify your email address before signing in.';
    }

    // Generic error message
    return 'Failed to sign in. Please check your credentials and try again.';
  }
}
