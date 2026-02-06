// lib/features/team/presentation/widgets/team_member_card.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/team/data/models/team_member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback? onRemove;

  const TeamMemberCard({
    super.key,
    required this.member,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getRoleColor(member.role).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getRoleColor(member.role).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.avatarEmoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              if (member.role == TeamRole.lead)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSurface
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 14,
                      color: AppColors.brandGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      member.username,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: AppColors.brandGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getRoleColor(member.role).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getRoleColor(member.role).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              member.role.displayName.toUpperCase(),
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: _getRoleColor(member.role),
              ),
            ),
          ),

          // Remove Button
          if (member.role != TeamRole.lead && onRemove != null) ...[
            const SizedBox(width: 12),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline,
                color: isDark
                    ? AppColors.darkTextSecondary.withOpacity(0.5)
                    : AppColors.lightTextSecondary.withOpacity(0.5),
              ),
              tooltip: 'REMOVE MEMBER',
              style: IconButton.styleFrom(
                backgroundColor: (isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground)
                    .withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getRoleColor(TeamRole role) {
    switch (role) {
      case TeamRole.lead:
        return AppColors.brandGreen;
      case TeamRole.developer:
        return const Color(0xFF3B82F6);
      case TeamRole.designer:
        return const Color(0xFFF59E0B);
      case TeamRole.productManager:
        return const Color(0xFF8B5CF6);
    }
  }
}
