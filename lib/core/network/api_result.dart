import 'api_exception.dart';

/// Type-safe wrapper for API responses
class ApiResult<T> {
  final T? data;
  final ApiException? error;
  final bool isSuccess;

  ApiResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  /// Create success result
  factory ApiResult.success(T data) {
    return ApiResult._(data: data, isSuccess: true);
  }

  /// Create failure result
  factory ApiResult.failure(ApiException error) {
    return ApiResult._(error: error, isSuccess: false);
  }

  /// Check if failed
  bool get isFailure => !isSuccess;

  /// Pattern matching
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException error) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    } else {
      return failure(error!);
    }
  }

  /// Execute only on success
  void onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) callback(data as T);
  }

  /// Execute only on failure
  void onFailure(void Function(ApiException error) callback) {
    if (isFailure && error != null) callback(error!);
  }
}
