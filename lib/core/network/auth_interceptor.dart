import 'dart:async';

import 'package:antigravity_app/utils/constants/storage_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Advanced Interceptor to handle Bearer tokens, automatic token refresh,
/// and multiple simultaneous 401 requests (Race Condition prevention).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.dio});

  final Dio dio;

  final _secureStorage = const FlutterSecureStorage();

  bool _isRefreshing = false;
  final _requestsQueue = <Completer<bool>>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(key: StorageConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If it's NOT a 401, just pass the error down immediately
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // IF WE ARE ALREADY REFRESHING:
    // This happens if 5 APIs fail at the exact same time.
    // The first one triggers the refresh. The other 4 land here.
    // We put them in a queue to WAIT.
    if (_isRefreshing) {
      final completer = Completer<bool>();
      _requestsQueue.add(completer);

      // Wait for the primary request to finish refreshing the token
      final isTokenRefreshed = await completer.future;

      if (isTokenRefreshed) {
        // Retry the request with the newly saved token
        try {
          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      } else {
        // The token refresh failed (e.g. refresh token expired)
        // so fail this request too.
        return handler.next(err);
      }
    }

    // IF WE ARE THE FIRST 401 TO HIT THIS:
    _isRefreshing = true;

    // 1. Attempt to refresh the token
    final isRefreshed = await _refreshTokenCall();

    if (isRefreshed) {
      // 2. Notify all queued requests that the token is successfully refreshed!
      for (final completer in _requestsQueue) {
        completer.complete(true);
      }
      _requestsQueue.clear();
      _isRefreshing = false;

      // 3. Retry the original request that started it all
      try {
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryErr) {
        return handler.next(retryErr);
      }
    } else {
      // Token refresh completely failed.
      // Notify the queue to fail, clear the queue, and trigger logout.
      for (final completer in _requestsQueue) {
        completer.complete(false);
      }
      _requestsQueue.clear();
      _isRefreshing = false;

      await _secureStorage.deleteAll();
      // GlobalAuthEventBus.logout(); // Trigger your app's global logout here!

      return handler.next(err);
    }
  }

  /// Replays a request exactly as it was, but it will pass through
  /// `onRequest` again and pick up the brand new Bearer token.
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  /// The actual API call to your refresh endpoint
  Future<bool> _refreshTokenCall() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: StorageConstants.refreshToken,
      );
      if (refreshToken == null) return false;

      // Example endpoint. Replace with your actual Env.apiUrl
      // final response = await _refreshDio.post(
      //   '/auth/refresh',
      //   data: {'refresh_token': refreshToken},
      // );

      // Simulate network delay for example purposes
      await Future<void>.delayed(const Duration(seconds: 1));

      // Save new tokens to SecureStorage
      await _secureStorage.write(
        key: StorageConstants.accessToken,
        value: 'new_token_123',
      );
      await _secureStorage.write(
        key: StorageConstants.refreshToken,
        value: 'new_refresh_123',
      );

      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
