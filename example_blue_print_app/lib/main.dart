import 'package:example_blue_print_app/app.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Default entry point — runs as the dev flavor.
///
/// For production builds, use:
/// - `flutter run -t lib/main_dev.dart`
/// - `flutter run -t lib/main_staging.dart`
/// - `flutter run -t lib/main_prod.dart`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode to prevent UI shattering on tilt.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  F.appFlavor = Flavor.dev;

  runApp(const App());
}
