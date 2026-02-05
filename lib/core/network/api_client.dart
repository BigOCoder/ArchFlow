// lib/core/network/api_client.dart
import 'package:archflow/core/config/env_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {

  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl, 
        connectTimeout: Duration(
          milliseconds: EnvConfig.apiTimeout,
        ), 
        receiveTimeout: Duration(milliseconds: EnvConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            print('🔵 REQUEST[${options.method}] => ${options.path}');
            print('📤 Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('🟢 RESPONSE[${response.statusCode}] => ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            print(
              '🔴 ERROR[${error.response?.statusCode}] => ${error.message}',
            );
          }

          // ✅ Handle 401 - Try to refresh token
          if (error.response?.statusCode == 401) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              // Retry the original request
              final opts = error.requestOptions;
              final token = await _storage.read(key: 'access_token');
              opts.headers['Authorization'] = 'Bearer $token';

              try {
                final response = await _dio.fetch(opts);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await saveTokens(newAccessToken, newRefreshToken);
        return true;
      }
      return false;
    } catch (e) {
      await clearTokens();
      return false;
    }
  }

  Dio get dio => _dio;

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
