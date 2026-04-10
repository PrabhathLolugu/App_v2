import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myitihas/services/supabase_service.dart';
import 'package:myitihas/core/logging/talker_setup.dart';

/// ChangeNotifier that bridges Supabase auth state changes to GoRouter refresh
///
/// This class listens to Supabase authentication state changes and notifies
/// GoRouter to rebuild its redirect logic whenever auth state changes.
/// Used as the refreshListenable in GoRouter configuration.
///
/// IMPORTANT: Password Recovery Flow
/// ================================
/// When a user clicks a password reset link, Supabase PKCE automatically creates
/// and persists a session. This is problematic because:
/// 1. The user gets "logged in" before resetting their password
/// 2. They can access authenticated routes without completing password reset
/// 3. The session persists across hot restarts
///
/// Solution: Use `isRecovering` flag to override normal authentication routing.
/// - When password recovery deep link is detected, `isRecovering` is set to true
/// - GoRouter treats recovery state as HIGHER PRIORITY than authenticated state
/// - Recovery state forces navigation to /reset-password regardless of session
/// - After successful password update, sign out the recovery session and clear flag
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  /// Flag indicating if user is in password recovery flow
  ///
  /// When true, this OVERRIDES normal authentication state.
  /// Even though Supabase creates a session (due to PKCE), we treat
  /// the user as NOT authenticated until they complete password reset.
  ///
  /// This prevents accessing normal authenticated routes during recovery.
  bool _isRecovering = false;

  bool get isRecovering => _isRecovering;

  GoRouterRefreshStream() {
    _subscription = SupabaseService.onAuthStateChange.listen((data) {
      // Handle password recovery event from Supabase
      // This is the authoritative signal for password recovery flow,
      // in addition to deep link detection as a fallback
      if (data.event == AuthChangeEvent.passwordRecovery) {
        talker.info(
          '[GoRouterRefreshStream] Password recovery event detected from Supabase',
        );
        setRecovering();
      }

      // Log other auth events for debugging
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          talker.info('[GoRouterRefreshStream] User signed in');
          break;
        case AuthChangeEvent.signedOut:
          talker.info('[GoRouterRefreshStream] User signed out');
          // Clear recovery state on sign out to prevent stale state
          if (_isRecovering) {
            _isRecovering = false;
          }
          break;
        case AuthChangeEvent.tokenRefreshed:
          talker.debug('[GoRouterRefreshStream] Token refreshed');
          break;
        case AuthChangeEvent.userUpdated:
          talker.info('[GoRouterRefreshStream] User updated');
          break;
        case AuthChangeEvent.mfaChallengeVerified:
          talker.info('[GoRouterRefreshStream] MFA challenge verified');
          break;
        default:
          break;
      }

      // Notify GoRouter to recompute redirect logic
      notifyListeners();
    });
  }

  /// Mark that user is in password recovery flow
  ///
  /// Called when password reset deep link is detected (myitihas://reset-password).
  /// This sets recovery flag to true, which forces GoRouter to redirect to
  /// /reset-password page regardless of authentication state.
  void setRecovering() {
    talker.info('[Recovery] Password recovery mode activated');
    _isRecovering = true;
    notifyListeners();
  }

  /// Clear password recovery state
  ///
  /// Called after successful password update. This allows normal
  /// authentication routing to resume.
  ///
  /// IMPORTANT: Always call supabase.auth.signOut() BEFORE this method
  /// to ensure the recovery session is terminated.
  void clearRecovery() {
    talker.info('[Recovery] Password recovery mode cleared');
    _isRecovering = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
