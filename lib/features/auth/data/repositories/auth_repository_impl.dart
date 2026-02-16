// lib/data/repositories/auth_repository.dart
import 'package:archflow/features/auth/data/models/auth_response.dart';
import 'package:archflow/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archflow/core/network/api_client.dart';


const bool useMockTest = true; // Set to false when backend is ready

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required bool agreedToTerms,
    String role = 'STUDENT',
  }) async {
    // ✅ MOCK MODE
    if (useMockTest) {
      if (kDebugMode) {
        print('🟡 MOCK MODE: Register (Backend OFF)');
        print('   Name: $name');
        print('   Email: $email');
        print('   Role: $role');
      }

      await Future.delayed(const Duration(seconds: 1)); // Simulate network

      // Create fake response
      return AuthResponse(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: UserModel(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
        ),
      );
    }

    // ✅ REAL API CALL
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'tandc': agreedToTerms,
          'role': role.toUpperCase(),
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _apiClient.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // ✅ MOCK MODE
    if (useMockTest) {
      if (kDebugMode) {
        print('🟡 MOCK MODE: Login (Backend OFF)');
        print('   Email: $email');
      }

      await Future.delayed(const Duration(seconds: 1)); // Simulate network

      // Create fake response
      return AuthResponse(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: UserModel(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
          name: 'Test User',
          email: email,
        ),
      );
    }

    // ✅ REAL API CALL
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _apiClient.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> refreshToken() async {
    // ✅ MOCK MODE
    if (useMockTest) {
      if (kDebugMode) print('🟡 MOCK MODE: Refresh Token (Backend OFF)');

      await Future.delayed(const Duration(milliseconds: 500));

      return AuthResponse(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: UserModel(
          id: 'mock_123',
          name: 'Test User',
          email: 'test@example.com',
        ),
      );
    }

    // ✅ REAL API CALL
    try {
      final refreshToken = await _apiClient.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _apiClient.dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _apiClient.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    // ✅ MOCK MODE
    if (useMockTest) {
      if (kDebugMode) print('🟡 MOCK MODE: Logout (Backend OFF)');
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }

    // ✅ REAL API CALL
    try {
      final refreshToken = await _apiClient.getRefreshToken();
      if (refreshToken != null) {
        await _apiClient.dio.post(
          '/auth/logout',
          data: {'refreshToken': refreshToken},
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      await _apiClient.clearTokens();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    // ✅ MOCK MODE
    if (useMockTest) {
      if (kDebugMode) print('🟡 MOCK MODE: Get Current User (Backend OFF)');

      // Return null to simulate no logged-in user
      return null;
    }

    // ✅ REAL API CALL
    try {
      final token = await _apiClient.getAccessToken();
      if (token == null) return null;

      final response = await _apiClient.dio.get('/auth/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  String _handleError(DioException error) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      if (data is String) {
        return data;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Invalid credentials';
        if (statusCode == 400) return 'Invalid request';
        if (statusCode == 404) return 'Service not found';
        if (statusCode == 500) return 'Server error. Please try again later.';
        return 'Server error ($statusCode)';

      case DioExceptionType.cancel:
        return 'Request cancelled';

      default:
        return 'Network error. Please try again.';
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});
