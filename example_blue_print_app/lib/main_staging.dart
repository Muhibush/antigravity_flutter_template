import 'package:example_blue_print_app/app.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry point for the **staging** flavor.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  F.appFlavor = Flavor.staging;

  runApp(const App());
}
