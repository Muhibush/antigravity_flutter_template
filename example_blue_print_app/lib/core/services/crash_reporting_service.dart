import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Abstract interface for reporting crashes and non-fatal errors.
abstract class CrashReportingService {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
  });
  Future<void> log(String message);
}

/// Implementation using Firebase Crashlytics.
class FirebaseCrashReportingService implements CrashReportingService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
  }) async {
    // Only send to Crashlytics if not in debug mode
    if (!kDebugMode) {
      await _crashlytics.recordError(exception, stack, reason: reason);
    }
  }

  @override
  Future<void> log(String message) async {
    if (!kDebugMode) {
      await _crashlytics.log(message);
    }
  }
}
