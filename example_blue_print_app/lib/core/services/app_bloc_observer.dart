import 'dart:async';
import 'dart:developer';

import 'package:example_blue_print_app/core/services/analytics_service.dart';
import 'package:example_blue_print_app/core/services/crash_reporting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global observer that logs every BLoC event, transition, and error.
///
/// In debug mode, prints to the console.
/// In release mode, automatically reports errors to Crashlytics
/// and logs events to Analytics.
class AppBlocObserver extends BlocObserver {
  AppBlocObserver({
    required this.analyticsService,
    required this.crashReportingService,
  });

  final AnalyticsService analyticsService;
  final CrashReportingService crashReportingService;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    // Automatically track all events for analytics
    if (event != null) {
      unawaited(
        analyticsService.logEvent(
          event.runtimeType.toString(),
          parameters: {'bloc': bloc.runtimeType.toString()},
        ),
      );
    }

    if (kDebugMode) {
      log(
        '⚡ ${bloc.runtimeType} | $event',
        name: 'BlocObserver',
      );
    }
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      log(
        '🔄 ${bloc.runtimeType} | '
        '${transition.currentState.runtimeType} → '
        '${transition.nextState.runtimeType}',
        name: 'BlocObserver',
      );
    }
  }

  @override
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    super.onError(bloc, error, stackTrace);

    // Automatically report all unhandled BLoC errors to Crashlytics
    unawaited(
      crashReportingService.recordError(
        error,
        stackTrace,
        reason: 'Unhandled exception in ${bloc.runtimeType}',
      ),
    );

    if (kDebugMode) {
      log(
        '❌ ${bloc.runtimeType} | $error',
        name: 'BlocObserver',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
