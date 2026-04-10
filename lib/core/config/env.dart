import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration using Envied for secure secret management.
///
/// All sensitive values are obfuscated to prevent easy extraction from
/// compiled binaries.
///
/// Usage:
/// ```dart
/// Env.supabaseUrl  // Access Supabase URL
/// Env.supabaseAnonKey  // Access Supabase Anon Key
/// ```
@Envied(path: 'lib/core/config/.env', obfuscate: true)
abstract class Env {
  /// Supabase project URL
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _Env.supabaseUrl;

  /// Supabase anonymous key for client-side access
  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  /// Google OAuth Web Client ID (used as serverClientId for token verification)
  @EnviedField(varName: 'GOOGLE_WEB_CLIENT_ID')
  static final String googleWebClientId = _Env.googleWebClientId;

  /// Google OAuth iOS Client ID (used as clientId for native iOS sign-in)
  @EnviedField(varName: 'GOOGLE_IOS_CLIENT_ID')
  static final String googleIosClientId = _Env.googleIosClientId;
}
