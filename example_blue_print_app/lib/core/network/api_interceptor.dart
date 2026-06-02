import 'dart:developer';

import 'package:dio/dio.dart';

/// Custom interceptor for logging HTTP requests, responses, and errors.
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '[REQUEST] ${options.method} ${options.uri}',
      name: 'ApiInterceptor',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log(
      '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
      name: 'ApiInterceptor',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '[ERROR] ${err.type} ${err.message}',
      name: 'ApiInterceptor',
    );
    super.onError(err, handler);
  }
}
