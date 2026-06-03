import 'package:example_blue_print_app/app.dart';
import 'package:example_blue_print_app/core/services/app_bloc_observer.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point for the **dev** flavor.
///
/// Each flavor has its own `main_<flavor>.dart` that:
/// 1. Sets the flavor.
/// 2. Locks portrait orientation (blueprint rule).
/// 3. Registers the global [AppBlocObserver].
/// 4. Runs the shared [App] widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode to prevent UI shattering on tilt.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  F.appFlavor = Flavor.dev;

  // Register the global BLoC observer for debug logging.
  Bloc.observer = AppBlocObserver();

  runApp(const App());
}
