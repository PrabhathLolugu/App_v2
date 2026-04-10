import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import '../config/go_router_refresh.dart';

/// Service to initialize and manage Supabase client
/// This is the main entry point for backend services
class SupabaseService {
  static SupabaseClient? _client;
  static AuthService? _authService;
  static GoRouterRefreshStream? _refreshStream;

  /// Initialize Supabase with your project URL and anon key
  /// Call this in main() before runApp()
  ///
  /// Note: Supabase automatically handles session persistence.
  /// User sessions are stored securely and automatically restored on app restart,
  /// so users will remain logged in even after killing and reopening the app.
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      // Session persistence is handled automatically by Supabase Flutter
      // Sessions are stored securely using:
      // - Hive on mobile (Android/iOS)
      // - localStorage on web
    );
    _client = Supabase.instance.client;
    _authService = AuthService(_client!);

    // Session is automatically restored - currentUser will be available if session exists
    // You can check authentication state using: SupabaseService.authService.isAuthenticated()
  }

  /// Get the Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Get the AuthService instance
  static AuthService get authService {
    if (_authService == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _authService!;
  }

  /// Get a stream of auth state changes
  ///
  /// Emits AuthState events whenever:
  /// - User signs in (SIGNED_IN)
  /// - User signs out (SIGNED_OUT)
  /// - Session is restored (INITIAL_SESSION)
  ///
  /// Used for GoRouter refresh integration to update UI on auth changes
  static Stream<AuthState> get onAuthStateChange {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!.auth.onAuthStateChange;
  }

  /// Get the current user session
  ///
  /// Returns null if user is not authenticated
  /// Safe to call - handles initialization checks
  static Session? getCurrentSession() {
    if (_client == null) {
      return null;
    }
    return _client!.auth.currentSession;
  }

  /// Set the GoRouter refresh stream
  ///
  /// This must be called from MyItihasRouter constructor to allow
  /// AuthService to access and update recovery state.
  static void setRefreshStream(GoRouterRefreshStream stream) {
    _refreshStream = stream;
  }

  /// Get the GoRouter refresh stream
  ///
  /// Used by AuthService to set/clear recovery state.
  /// Returns null if not initialized.
  static GoRouterRefreshStream? get refreshStream => _refreshStream;
}
