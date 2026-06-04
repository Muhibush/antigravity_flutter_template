import 'package:example_blue_print_app/app.dart';
import 'package:example_blue_print_app/core/services/analytics_service.dart';
import 'package:example_blue_print_app/core/services/app_bloc_observer.dart';
import 'package:example_blue_print_app/core/services/crash_reporting_service.dart';
import 'package:example_blue_print_app/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

/// Entry point for the **staging** flavor.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  F.appFlavor = Flavor.staging;

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
