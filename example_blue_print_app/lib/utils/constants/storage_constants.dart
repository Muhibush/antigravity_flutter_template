/// Centralized keys for secure storage and shared preferences.
///
/// Prevents typos from hardcoded string literals across the codebase.
abstract class StorageConstants {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}
