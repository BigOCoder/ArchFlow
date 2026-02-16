import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/auth/presentation/providers/auth_provider.dart';
import 'package:archflow/features/dashboard/presentation/screens/home.dart';
import 'package:archflow/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(
            isDark,
            userName: user?.name ?? 'Guest User',
            userEmail: user?.email ?? 'guest@archflow.com',
            userImageUrl: user?.profileImage,
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  isSelected: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.folder_outlined,
                  title: 'My Projects',
                  trailing: _buildBadge('12', isDark),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.group_outlined,
                  title: 'Team Management',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.architecture_outlined,
                  title: 'Architecture Library',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 32, indent: 20, endIndent: 20),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.integration_instructions_outlined,
                  title: 'Integrations',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: _buildBadge('3', isDark, color: AppColors.error),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 32, indent: 20, endIndent: 20),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpDialog(context, isDark);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context, isDark);
                  },
                ),
              ],
            ),
          ),

          // Logout Section
          _buildLogoutSection(context, ref, isDark),
        ],
      ),
    );
  }

  // ================== HEADER ==================

  Widget _buildDrawerHeader(
    bool isDark, {
    required String userName,
    required String userEmail,
    String? userImageUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 24, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandGreen, AppColors.brandGreen.withOpacity(0.8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              userImageUrl != null && userImageUrl.isNotEmpty
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userImageUrl),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        _getInitials(userName),
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.brandGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'View Profile',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== DRAWER ITEMS ==================

  Widget _buildDrawerItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
    bool isSelected = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.brandGreen.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppColors.brandGreen
              : (iconColor ??
                    (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary)),
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.brandGreen
                : (textColor ??
                      (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary)),
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildBadge(String count, bool isDark, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? AppColors.brandGreen).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.brandGreen,
        ),
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      child: _buildDrawerItem(
        context: context,
        isDark: isDark,
        icon: Icons.logout_outlined,
        title: 'Logout',
        iconColor: AppColors.error,
        textColor: AppColors.error,
        onTap: () {
          Navigator.pop(context);
          _showLogoutDialog(context, ref, isDark);
        },
      ),
    );
  }

  // ================== HELPER METHODS ==================

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';

    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();

    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  // ================== LOGOUT DIALOG ==================

  void _showLogoutDialog(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Logout',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to logout from ArchFlow?',
          style: GoogleFonts.lato(
            fontSize: 15,
            height: 1.4,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.lato(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog immediately
              Navigator.pop(dialogContext);

              // Perform logout
              try {
                await ref.read(authProvider.notifier).logout();
              } catch (e) {
                debugPrint('Logout error: $e');
              }

              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  // ================== HELP DIALOG ==================

  void _showHelpDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.help_outline,
                color: AppColors.brandGreen,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Help & Support',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _helpItem(
              isDark: isDark,
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@archflow.com',
            ),
            const SizedBox(height: 12),
            _helpItem(
              isDark: isDark,
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Available 24/7',
            ),
            const SizedBox(height: 12),
            _helpItem(
              isDark: isDark,
              icon: Icons.book_outlined,
              title: 'Documentation',
              subtitle: 'docs.archflow.com',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: GoogleFonts.lato(
                color: AppColors.brandGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpItem({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================== ABOUT DIALOG ==================

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.brandGreen,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'About ArchFlow',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.architecture,
                  size: 40,
                  color: AppColors.brandGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'ArchFlow',
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Transform your software development workflow with AI-powered architecture design and intelligent project management.',
              style: GoogleFonts.lato(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '© 2026 ArchFlow. All rights reserved.',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: GoogleFonts.lato(
                color: AppColors.brandGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
