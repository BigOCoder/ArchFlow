// lib/features/integrations/data/models/integration_status.dart

enum IntegrationProvider {
  github,
  linear,
  jira,
}

class IntegrationStatus {
  final IntegrationProvider provider;
  final bool isConnected;
  final DateTime? connectedAt;
  final String? username;

  const IntegrationStatus({
    required this.provider,
    required this.isConnected,
    this.connectedAt,
    this.username,
  });

  IntegrationStatus copyWith({
    IntegrationProvider? provider,
    bool? isConnected,
    DateTime? connectedAt,
    String? username,
  }) {
    return IntegrationStatus(
      provider: provider ?? this.provider,
      isConnected: isConnected ?? this.isConnected,
      connectedAt: connectedAt ?? this.connectedAt,
      username: username ?? this.username,
    );
  }
}
