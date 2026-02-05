import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Converts errors to structured exceptions
class ApiErrorHandler {
  /// Convert any error to ApiException
  static ApiException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return NoInternetException();
    } else if (error is ApiException) {
      return error;
    } else {
      return UnknownException(message: error.toString());
    }
  }

  /// Handle DioException
  static ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutException();

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NoInternetException();
        }
        return UnknownException(message: 'Connection error occurred');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return UnknownException(message: 'Request cancelled');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetException();
        }
        return UnknownException(message: error.message ?? 'Unknown error occurred');

      default:
        return UnknownException(message: 'Unexpected error occurred');
    }
  }

  /// Handle response errors by status code
  static ApiException _handleResponseError(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Extract error message from response
    String? errorMessage;
    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ?? 
                     data['error'] ?? 
                     data['msg'] ?? 
                     data['detail'];
    } else if (data is String) {
      errorMessage = data;
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: errorMessage, data: data);
      case 401:
        return UnauthorizedException(message: errorMessage);
      case 403:
        return ForbiddenException(message: errorMessage);
      case 404:
        return NotFoundException(message: errorMessage);
      case 409:
        return ConflictException(message: errorMessage, data: data);
      case 422:
        return ValidationException(message: errorMessage, data: data);
      case 500:
        return InternalServerException(message: errorMessage);
      case 503:
        return ServiceUnavailableException(message: errorMessage);
      default:
        return UnknownException(message: errorMessage ?? 'Unknown error occurred');
    }
  }

  /// Extract validation errors (for 422 responses)
  static Map<String, List<String>>? extractValidationErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final errors = <String, List<String>>{};
    
    if (data.containsKey('errors')) {
      final errorsData = data['errors'];
      if (errorsData is Map<String, dynamic>) {
        errorsData.forEach((key, value) {
          if (value is List) {
            errors[key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            errors[key] = [value];
          }
        });
      }
    }

    return errors.isEmpty ? null : errors;
  }
}
