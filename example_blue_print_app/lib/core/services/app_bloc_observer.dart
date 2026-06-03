import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global observer that logs every BLoC event, transition, and error.
///
/// Only logs in debug mode (`kDebugMode`) to avoid leaking state
/// information in production builds.
///
/// Register once in `main()`:
/// ```dart
/// Bloc.observer = AppBlocObserver();
/// ```
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
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
