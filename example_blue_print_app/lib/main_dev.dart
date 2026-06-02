import 'package:example_blue_print_app/app.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry point for the **dev** flavor.
///
/// Each flavor has its own `main_<flavor>.dart` that:
/// 1. Sets the flavor.
/// 2. Locks portrait orientation (blueprint rule).
/// 3. Runs the shared [App] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode to prevent UI shattering on tilt.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  F.appFlavor = Flavor.dev;

  runApp(const App());
}
