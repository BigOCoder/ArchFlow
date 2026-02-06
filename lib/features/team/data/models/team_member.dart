// lib/features/team/data/models/team_member.dart

enum TeamRole {
  lead,
  developer,
  designer,
  productManager,
}

extension TeamRoleExtension on TeamRole {
  String get displayName {
    switch (this) {
      case TeamRole.lead:
        return 'Lead';
      case TeamRole.developer:
        return 'Developer';
      case TeamRole.designer:
        return 'Designer';
      case TeamRole.productManager:
        return 'PM';
    }
  }
}

class TeamMember {
  final String id;
  final String name;
  final String username;
  final TeamRole role;
  final String avatarEmoji;
  final DateTime joinedAt;

  TeamMember({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.avatarEmoji,
    required this.joinedAt,
  });
}
