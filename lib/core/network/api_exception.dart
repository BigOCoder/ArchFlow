/// Base class for all API exceptions
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

/// No internet connection
class NoInternetException extends ApiException {
  NoInternetException()
      : super(
          message: 'No internet connection. Please check your network settings.',
          statusCode: 0,
        );
}

/// Request timeout
class RequestTimeoutException extends ApiException {
  RequestTimeoutException()
      : super(
          message: 'Request timeout. Please try again.',
          statusCode: 408,
        );
}

/// 400 Bad Request
class BadRequestException extends ApiException {
  BadRequestException({String? message, super.data})
      : super(
          message: message ?? 'Invalid request. Please check your input.',
          statusCode: 400,
        );
}

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Session expired. Please login again.',
          statusCode: 401,
        );
}

/// 403 Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'Access denied. You don\'t have permission.',
          statusCode: 403,
        );
}

/// 404 Not Found
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Resource not found.',
          statusCode: 404,
        );
}

/// 409 Conflict
class ConflictException extends ApiException {
  ConflictException({String? message, super.data})
      : super(
          message: message ?? 'Conflict occurred. Resource already exists.',
          statusCode: 409,
        );
}

/// 422 Validation Error
class ValidationException extends ApiException {
  ValidationException({String? message, super.data})
      : super(
          message: message ?? 'Validation failed. Please check your input.',
          statusCode: 422,
        );
}

/// 500 Internal Server Error
class InternalServerException extends ApiException {
  InternalServerException({String? message})
      : super(
          message: message ?? 'Server error. Please try again later.',
          statusCode: 500,
        );
}

/// 503 Service Unavailable
class ServiceUnavailableException extends ApiException {
  ServiceUnavailableException({String? message})
      : super(
          message: message ?? 'Service temporarily unavailable. Please try again later.',
          statusCode: 503,
        );
}

/// Response parsing error
class ParseException extends ApiException {
  ParseException({String? message})
      : super(
          message: message ?? 'Failed to parse response data.',
          statusCode: null,
        );
}

/// Unknown error
class UnknownException extends ApiException {
  UnknownException({String? message})
      : super(
          message: message ?? 'An unexpected error occurred. Please try again.',
          statusCode: null,
        );
}
