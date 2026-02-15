// lib/data/repositories/project_repository.dart
import 'package:archflow/core/network/api_client.dart';
import 'package:archflow/features/project/data/dtos/project_dto.dart';
import 'package:archflow/features/project/data/models/project_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepository(this._apiClient);

  Future<ProjectModel> createProject(ProjectCreateDto projectDto) async {
    final response = await _apiClient.dio.post(
      '/projects',
      data: projectDto.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProjectModel.fromJson(response.data);
    }
    throw Exception('Failed to create project');
  }

  Future<List<ProjectModel>> getProjects() async {
    final response = await _apiClient.dio.get('/projects');

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ProjectModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch projects');
  }
}

// ✅ FIX: Use Provider instead of creating new instance
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final apiClient = ref.read(apiClientProvider); // ✅ Get from provider
  return ProjectRepository(apiClient);
});
