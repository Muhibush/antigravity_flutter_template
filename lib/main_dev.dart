import 'package:antigravity_app/app.dart';
import 'package:antigravity_app/core/services/analytics_service.dart';
import 'package:antigravity_app/core/services/app_bloc_observer.dart';
import 'package:antigravity_app/core/services/crash_reporting_service.dart';
import 'package:antigravity_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

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

  // TODO(developer): Uncomment once you run `flutterfire configure`
  // to generate firebase_options.dart.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Register the global BLoC observer for debug logging and analytics.
  Bloc.observer = AppBlocObserver(
    analyticsService: FirebaseAnalyticsService(),
    crashReportingService: FirebaseCrashReportingService(),
  );

  runApp(const App());
}
