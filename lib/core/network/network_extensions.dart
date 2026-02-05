import 'package:dio/dio.dart';
import 'api_error_handler.dart';
import 'api_result.dart';

/// Extension methods for ApiClient to handle errors
extension ApiClientExtensions on Dio {
  /// Safe GET request
  Future<ApiResult<T>> safeGet<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) parser,
  }) async {
    try {
      final response = await get(path, queryParameters: queryParameters);
      return ApiResult.success(parser(response.data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handleError(error));
    }
  }

  /// Safe POST request
  Future<ApiResult<T>> safePost<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) parser,
  }) async {
    try {
      final response = await post(path, data: data);
      return ApiResult.success(parser(response.data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handleError(error));
    }
  }

  /// Safe PUT request
  Future<ApiResult<T>> safePut<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) parser,
  }) async {
    try {
      final response = await put(path, data: data);
      return ApiResult.success(parser(response.data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handleError(error));
    }
  }

  /// Safe DELETE request
  Future<ApiResult<T>> safeDelete<T>(
    String path, {
    dynamic data,
    required T Function(dynamic) parser,
  }) async {
    try {
      final response = await delete(path, data: data);
      return ApiResult.success(parser(response.data));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handleError(error));
    }
  }
}
