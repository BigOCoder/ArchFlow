// ignore_for_file: avoid_print

import 'package:archflow/core/config/env_config.dart';

/// API endpoints and constants for ArchFlow backend
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // ==========================================================================
  // Base URLs
  // ==========================================================================

  /// Base API URL from environment
  static String get baseUrl => EnvConfig.fullApiUrl;

  // ==========================================================================
  // Authentication Endpoints
  // ==========================================================================

  /// Login endpoint
  static const String login = '/auth/login';

  /// Register endpoint
  static const String register = '/auth/register';

  /// Refresh token endpoint
  static const String refreshToken = '/auth/refresh';

  /// Logout endpoint
  static const String logout = '/auth/logout';

  /// Verify token endpoint
  static const String verifyToken = '/auth/verify';

  /// Get full login URL
  static String get loginUrl => '$baseUrl$login';

  /// Get full register URL
  static String get registerUrl => '$baseUrl$register';

  /// Get full refresh token URL
  static String get refreshTokenUrl => '$baseUrl$refreshToken';

  // ==========================================================================
  // User Endpoints
  // ==========================================================================

  /// Get current user profile
  static const String userProfile = '/user/profile';

  /// Update user profile
  static const String updateProfile = '/user/profile';

  /// Get user preferences
  static const String userPreferences = '/user/preferences';

  /// Update user preferences
  static const String updatePreferences = '/user/preferences';

  /// Get user's skill profile
  static const String skillProfile = '/user/skills';

  /// Get full user profile URL
  static String get userProfileUrl => '$baseUrl$userProfile';

  // ==========================================================================
  // Project Endpoints
  // ==========================================================================

  /// Get all projects
  static const String projects = '/projects';

  /// Create new project
  static const String createProject = '/projects';

  /// Get project by ID
  static String projectById(String id) => '/projects/$id';

  /// Update project
  static String updateProject(String id) => '/projects/$id';

  /// Delete project
  static String deleteProject(String id) => '/projects/$id';

  /// Get project requirements
  static String projectRequirements(String id) => '/projects/$id/requirements';

  /// Get project architecture
  static String projectArchitecture(String id) => '/projects/$id/architecture';

  /// Get project tasks
  static String projectTasks(String id) => '/projects/$id/tasks';

  /// Get full projects URL
  static String get projectsUrl => '$baseUrl$projects';

  // ==========================================================================
  // AI Service Endpoints
  // ==========================================================================

  /// AI chat/conversation endpoint
  static const String aiChat = '/ai/chat';

  /// Generate requirements from conversation
  static const String generateRequirements = '/ai/requirements/generate';

  /// Generate architecture
  static const String generateArchitecture = '/ai/architecture/generate';

  /// Generate database schema
  static const String generateSchema = '/ai/database/generate';

  /// Generate task breakdown
  static const String generateTasks = '/ai/tasks/generate';

  /// AI code review
  static const String codeReview = '/ai/code/review';

  /// Get full AI chat URL
  static String get aiChatUrl => '$baseUrl$aiChat';

  // ==========================================================================
  // Requirements Endpoints
  // ==========================================================================

  /// Get all requirements for a project
  static String requirements(String projectId) =>
      '/projects/$projectId/requirements';

  /// Create new requirement
  static String createRequirement(String projectId) =>
      '/projects/$projectId/requirements';

  /// Get requirement by ID
  static String requirementById(String projectId, String reqId) =>
      '/projects/$projectId/requirements/$reqId';

  /// Update requirement
  static String updateRequirement(String projectId, String reqId) =>
      '/projects/$projectId/requirements/$reqId';

  /// Delete requirement
  static String deleteRequirement(String projectId, String reqId) =>
      '/projects/$projectId/requirements/$reqId';

  // ==========================================================================
  // Architecture Endpoints
  // ==========================================================================

  /// Get architecture for a project
  static String architecture(String projectId) =>
      '/projects/$projectId/architecture';

  /// Update architecture
  static String updateArchitecture(String projectId) =>
      '/projects/$projectId/architecture';

  // ==========================================================================
  // Task Management Endpoints
  // ==========================================================================

  /// Get all tasks for a project
  static String tasks(String projectId) => '/projects/$projectId/tasks';

  /// Create new task
  static String createTask(String projectId) => '/projects/$projectId/tasks';

  /// Get task by ID
  static String taskById(String projectId, String taskId) =>
      '/projects/$projectId/tasks/$taskId';

  /// Update task
  static String updateTask(String projectId, String taskId) =>
      '/projects/$projectId/tasks/$taskId';

  /// Delete task
  static String deleteTask(String projectId, String taskId) =>
      '/projects/$projectId/tasks/$taskId';

  /// Update task status
  static String updateTaskStatus(String projectId, String taskId) =>
      '/projects/$projectId/tasks/$taskId/status';

  // ==========================================================================
  // Traceability Endpoints
  // ==========================================================================

  /// Get traceability map for a project
  static String traceability(String projectId) =>
      '/projects/$projectId/traceability';

  /// Get trace for specific entity
  static String traceEntity(String projectId, String entityType, String entityId) =>
      '/projects/$projectId/traceability/$entityType/$entityId';

  // ==========================================================================
  // GitHub Integration Endpoints
  // ==========================================================================

  /// Connect GitHub repository
  static String connectGithub(String projectId) =>
      '/projects/$projectId/github/connect';

  /// Get GitHub repository info
  static String githubRepo(String projectId) =>
      '/projects/$projectId/github/repo';

  /// Sync with GitHub
  static String syncGithub(String projectId) =>
      '/projects/$projectId/github/sync';

  // ==========================================================================
  // Dashboard & Analytics Endpoints
  // ==========================================================================

  /// Get project dashboard data
  static String dashboard(String projectId) =>
      '/projects/$projectId/dashboard';

  /// Get project analytics
  static String analytics(String projectId) =>
      '/projects/$projectId/analytics';

  /// Get project maturity score
  static String maturityScore(String projectId) =>
      '/projects/$projectId/maturity';

  // ==========================================================================
  // Learning & Recommendations
  // ==========================================================================

  /// Get learning recommendations
  static const String learningRecommendations = '/learning/recommendations';

  /// Get skill gap analysis
  static const String skillGapAnalysis = '/learning/skill-gaps';

  /// Get learning resources
  static const String learningResources = '/learning/resources';

  // ==========================================================================
  // Helper Methods
  // ==========================================================================

  /// Build full URL from relative path
  static String buildUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  /// Print all endpoints (for debugging)
  static void printEndpoints() {
    if (!EnvConfig.isDebugMode) return;

    print('=' * 60);
    print('ArchFlow API Endpoints');
    print('=' * 60);
    print('Base URL: $baseUrl');
    print('\nAuthentication:');
    print('  - Login: $loginUrl');
    print('  - Register: $registerUrl');
    print('  - Refresh: $refreshTokenUrl');
    print('\nUser:');
    print('  - Profile: $userProfileUrl');
    print('\nProjects:');
    print('  - All Projects: $projectsUrl');
    print('\nAI:');
    print('  - Chat: $aiChatUrl');
    print('=' * 60);
  }
}

/// Extension for String repeat
extension StringRepeat on String {
  String repeat(int count) => List.filled(count, this).join();
}
