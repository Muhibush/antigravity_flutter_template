import 'package:antigravity_app/core/env/env.dart';
import 'package:antigravity_app/core/network/api_interceptor.dart';
import 'package:antigravity_app/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

/// Centralized API provider that configures Dio with interceptors.
///
/// Uses the environment-specific base URL and sets up:
/// - Bearer token injection and automatic 401 refresh via [AuthInterceptor].
/// - Request/Response logging via [ApiInterceptor].
/// - Automatic retry for failed requests via [RetryInterceptor].
class ApiProvider {
  ApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(dio: _dio),
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
