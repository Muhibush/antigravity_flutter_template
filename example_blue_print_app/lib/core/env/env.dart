/// Centralized Environment Variables wrapper.
///
/// Reads environment variables passed at compile-time using
/// `--dart-define-from-file=env_dev.json`.
/// This is much more secure than `flutter_dotenv` because the keys
/// are compiled into the binary, not shipped as plain text assets.
abstract class Env {
  /// The base URL for the API.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://fakestoreapi.com',
  );

  /// An example API Key or Secret Token.
  static const String apiKey = String.fromEnvironment('API_KEY');
}
