/// Application flavor/environment configuration.
///
/// Managed via native Android ProductFlavors & iOS Schemes.
/// Use `flutter_flavorizr` to generate the native configuration.
enum Flavor {
  dev,
  staging,
  prod,
}

/// Global flavor accessor.
///
/// Set once in `main_<flavor>.dart` before `runApp()`.
class F {
  static late Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'BlueprintApp Dev';
      case Flavor.staging:
        return 'BlueprintApp Staging';
      case Flavor.prod:
        return 'BlueprintApp';
    }
  }

  /// Base URL for the API, varies by flavor.
  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://fakestoreapi.com';
      case Flavor.staging:
        return 'https://fakestoreapi.com';
      case Flavor.prod:
        return 'https://fakestoreapi.com';
    }
  }
}
