// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration manager for ArchFlow
/// Provides centralized access to environment variables
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  /// Initialize environment configuration
  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }

  // ==========================================================================
  // API Configuration
  // ==========================================================================

  /// Base URL for the ArchFlow backend API
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  /// API version
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  /// Full API URL with version
  static String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  /// API timeout in milliseconds
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // ==========================================================================
  // Authentication
  // ==========================================================================

  /// JWT token refresh threshold (in seconds)
  static int get tokenRefreshThreshold =>
      int.tryParse(dotenv.env['TOKEN_REFRESH_THRESHOLD'] ?? '300') ?? 300;

  // ==========================================================================
  // External Services
  // ==========================================================================

  /// GitHub OAuth Client ID
  static String get githubClientId =>
      dotenv.env['GITHUB_CLIENT_ID'] ?? '';

  /// GitHub OAuth Client Secret
  static String get githubClientSecret =>
      dotenv.env['GITHUB_CLIENT_SECRET'] ?? '';

  /// GitHub OAuth Redirect URI
  static String get githubRedirectUri =>
      dotenv.env['GITHUB_REDIRECT_URI'] ?? 'archflow://auth/github/callback';

  /// AI Service URL
  static String get aiServiceUrl =>
      dotenv.env['AI_SERVICE_URL'] ?? 'https://ai.archflow.com';

  /// AI API Key
  static String get aiApiKey => dotenv.env['AI_API_KEY'] ?? '';

  // ==========================================================================
  // Feature Flags
  // ==========================================================================

  /// Check if AI requirements feature is enabled
  static bool get isAiRequirementsEnabled =>
      _parseBool(dotenv.env['FEATURE_AI_REQUIREMENTS'] ?? 'true');

  /// Check if architecture generation feature is enabled
  static bool get isArchitectureGenEnabled =>
      _parseBool(dotenv.env['FEATURE_ARCHITECTURE_GEN'] ?? 'true');

  /// Check if GitHub integration feature is enabled
  static bool get isGithubIntegrationEnabled =>
      _parseBool(dotenv.env['FEATURE_GITHUB_INTEGRATION'] ?? 'false');

  /// Check if learning mode is enabled
  static bool get isLearningModeEnabled =>
      _parseBool(dotenv.env['FEATURE_LEARNING_MODE'] ?? 'true');

  // ==========================================================================
  // Debug & Logging
  // ==========================================================================

  /// Check if debug mode is enabled
  static bool get isDebugMode =>
      _parseBool(dotenv.env['DEBUG_MODE'] ?? 'false');

  /// Get log level
  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'INFO';

  /// Check if network logging is enabled
  static bool get isNetworkLogsEnabled =>
      _parseBool(dotenv.env['ENABLE_NETWORK_LOGS'] ?? 'false');

  // ==========================================================================
  // App Configuration
  // ==========================================================================

  /// Get app environment (development, staging, production)
  static String get appEnvironment =>
      dotenv.env['APP_ENVIRONMENT'] ?? 'development';

  /// Check if running in production
  static bool get isProduction => appEnvironment == 'production';

  /// Check if running in development
  static bool get isDevelopment => appEnvironment == 'development';

  /// Check if running in staging
  static bool get isStaging => appEnvironment == 'staging';

  /// App name
  static String get appName => dotenv.env['APP_NAME'] ?? 'ArchFlow';

  /// Support email
  static String get supportEmail =>
      dotenv.env['SUPPORT_EMAIL'] ?? 'support@archflow.com';

  // ==========================================================================
  // Helper Methods
  // ==========================================================================

  /// Parse boolean from string
  static bool _parseBool(String value) {
    return value.toLowerCase() == 'true' || value == '1';
  }

  /// Print current configuration (for debugging)
  static void printConfig() {
    if (!isDebugMode) return;

    print('=' * 60);
    print('ArchFlow Environment Configuration');
    print('=' * 60);
    print('Environment: $appEnvironment');
    print('API Base URL: $apiBaseUrl');
    print('API Version: $apiVersion');
    print('Full API URL: $fullApiUrl');
    print('Debug Mode: $isDebugMode');
    print('Log Level: $logLevel');
    print('Network Logs: $isNetworkLogsEnabled');
    print('-' * 60);
    print('Feature Flags:');
    print('  - AI Requirements: $isAiRequirementsEnabled');
    print('  - Architecture Gen: $isArchitectureGenEnabled');
    print('  - GitHub Integration: $isGithubIntegrationEnabled');
    print('  - Learning Mode: $isLearningModeEnabled');
    print('=' * 60);
  }
}

/// Extension for String repeat
extension StringRepeat on String {
  String repeat(int count) => List.filled(count, this).join();
}
