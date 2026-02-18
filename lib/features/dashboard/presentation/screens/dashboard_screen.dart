// lib/screens/dashboard/dashboard_screen.dart
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/project/presentation/screens/project_onboarding_flow_screen.dart';
import 'package:archflow/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed - build was broken (missing return Scaffold)
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            // ✅ Fixed - uses theme
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                backgroundColor: AppColors.brandGreen.withOpacity(0.15),
                child: const Icon(Icons.person, color: AppColors.brandGreen),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 👋 WELCOME
            Text(
              'Welcome back, Sir! 👋',
              style: GoogleFonts.lato(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                // ✅ Fixed - uses theme
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Here's what's happening with your projects.",
              style: GoogleFonts.lato(
                fontSize: 14,
                // ✅ Fixed - uses theme
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),

            const SizedBox(height: 28),

            /// ⚡ QUICK ACTIONS
            Text(
              'Quick Actions',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                // ✅ Fixed - uses theme
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 14),

            /// 🌟 PRIMARY CARD
            // ✅ Removed isDark param
            _primaryCard(
              context,
              title: 'New Project',
              subtitle: 'Start a fresh workspace',
              icon: Icons.add,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProjectOnboardingFlow(),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _miniCard(
                    context,
                    // ✅ Removed isDark param
                    icon: Icons.folder_open,
                    title: 'Existing Projects',
                    subtitle: '12 Active',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _miniCard(
                    context,
                    // ✅ Removed isDark param
                    icon: Icons.group,
                    title: 'Team Management',
                    subtitle: '8 Members',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🕒 RECENT ACTIVITY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View all',
                    style: GoogleFonts.lato(color: AppColors.brandGreen),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _activityTile(
              context,
              // ✅ Removed isDark param
              title: 'Sarah updated API Documentation',
              time: '2 minutes ago',
              icon: Icons.description_outlined,
            ),
            _activityTile(
              context,
              title: 'Michael commented on Design System',
              time: '15 minutes ago',
              icon: Icons.comment_outlined,
            ),
            _activityTile(
              context,
              title: 'Marketing Q3 marked as completed',
              time: '1 hour ago',
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ================== COMPONENTS ==================

  // ✅ Removed isDark param
  Widget _primaryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.brandGreen,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandGreen.withOpacity(0.14),
                blurRadius: 22,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.brandGreen.withOpacity(0.06),
                blurRadius: 40,
                spreadRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Removed isDark param - takes context instead
  Widget _miniCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.brandGreen.withOpacity(0.15),
            child: Icon(icon, color: AppColors.brandGreen),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              // ✅ Fixed - uses theme
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.lato(
              fontSize: 13,
              // ✅ Fixed - uses theme
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Removed isDark param - takes context instead
  Widget _activityTile(
    BuildContext context, {
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.brandGreen.withOpacity(0.15),
            child: Icon(icon, color: AppColors.brandGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Removed isDark param - takes context instead
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.brandGreen,
      unselectedItemColor: Theme.of(context).textTheme.bodyMedium?.color,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
