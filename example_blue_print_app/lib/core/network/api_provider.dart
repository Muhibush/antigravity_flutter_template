import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:example_blue_print_app/core/network/api_interceptor.dart';
import 'package:example_blue_print_app/flavors.dart';

/// Centralized API provider that configures Dio with interceptors.
///
/// Uses the flavor-specific base URL and sets up:
/// - Request/Response logging via [ApiInterceptor].
/// - Automatic retry for failed requests via [RetryInterceptor].
class ApiProvider {
  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: F.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      ApiInterceptor(),
      RetryInterceptor(
        dio: _dio,
      ),
    ]);
  }

  late final Dio _dio;

  /// Exposes the configured [Dio] instance.
  Dio get dio => _dio;
}
