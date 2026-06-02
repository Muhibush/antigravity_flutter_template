import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Represents a failure in the application.
///
/// Used as the Left side of an `Either<Failure, T>` return type
/// from repositories. This prevents raw exceptions from leaking
/// into the BLoC layer.
class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  /// Factory to create a [Failure] from a [DioException].
  factory Failure.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure(
          message: 'Connection timed out. Please try again.',
        );
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        return Failure(
          message: _mapStatusCode(statusCode),
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const Failure(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return const Failure(
          message:
              'No internet connection. Please check your network.',
        );
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return const Failure(
          message: 'Something went wrong. Please try again.',
        );
    }
  }

  /// A user-friendly error message.
  final String message;

  /// The HTTP status code, if applicable.
  final int? statusCode;

  static String _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Forbidden. You do not have access.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return 'An error occurred (code: $statusCode).';
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}
