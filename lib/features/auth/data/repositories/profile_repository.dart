// lib/features/auth/data/repositories/profile_repository.dart

import 'package:archflow/features/auth/data/models/profile_request_model.dart';
import 'package:archflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archflow/core/network/api_client.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  /// Submit user profile to backend
  Future<Map<String, dynamic>> submitProfile(ProfileRequestModel profile) async {
    try {
      if (kDebugMode) {
        print('🔵 Submitting Profile...');
        print('📤 Data: ${profile.toJson()}');
      }

      final response = await _apiClient.dio.post(
        '/profile',
        data: profile.toJson(),
      );

      if (kDebugMode) {
        print('🟢 Profile Submitted Successfully');
        print('📥 Response: ${response.data}');
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('🔴 Profile Submission Error: ${e.message}');
        print('🔴 Response: ${e.response?.data}');
      }
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      
      // Handle backend error messages
      if (data is Map && data['message'] != null) {
        return data['message'];
      }
      
      // Handle validation errors
      if (data is Map && data['errors'] != null) {
        final errors = data['errors'] as List;
        return errors.map((e) => e['message']).join(', ');
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
        if (statusCode == 400) return 'Invalid profile data. Please check all fields.';
        if (statusCode == 401) return 'Unauthorized. Please login again.';
        if (statusCode == 422) return 'Validation error. Please check your inputs.';
        if (statusCode == 500) return 'Server error. Please try again later.';
        return 'Server error ($statusCode)';

      case DioExceptionType.cancel:
        return 'Request cancelled';

      default:
        return 'Network error. Please try again.';
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRepository(apiClient);
});
