// lib/screens/project/architecture_selection_screen.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/team/presentation/screens/team_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArchitectureSelectionScreen extends StatelessWidget {
  const ArchitectureSelectionScreen({super.key});

  // Under Development Page
  void _navigateToUnderDevelopment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UnderDevelopmentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Choose What to Design',
          style: GoogleFonts.lato(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.brandGreen.withOpacity(0.1),
                    AppColors.brandGreen.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.brandGreen.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.architecture_outlined,
                      color: AppColors.brandGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Architecture Tools',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap any card to learn more',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid of cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95, // ✅ Fixed ratio to prevent overflow
              children: [
                _ArchitectureCard(
                  icon: Icons.storage_outlined,
                  title: 'Backend\nArchitecture',
                  description:
                      'Generate a complete backend system architecture including API design, database schema, and microservices structure.',
                  gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
                  onTap: () => _navigateToUnderDevelopment(context),
                ),
                _ArchitectureCard(
                  icon: Icons.web_outlined,
                  title: 'Frontend\nArchitecture',
                  description:
                      'Create a comprehensive frontend architecture with component hierarchy, state management patterns, and UI/UX guidelines.',
                  gradientColors: const [Color(0xFFF093FB), Color(0xFFF5576C)],
                  onTap: () => _navigateToUnderDevelopment(context),
                ),
                _ArchitectureCard(
                  icon: Icons.data_object_outlined,
                  title: 'Database\nDesign',
                  description:
                      'Design optimized database schemas with entity relationships, indexes, and query optimization strategies.',
                  gradientColors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  onTap: () => _navigateToUnderDevelopment(context),
                ),
                _ArchitectureCard(
                  icon: Icons.api_outlined,
                  title: 'API\nDesign',
                  description:
                      'Generate RESTful or GraphQL API specifications with endpoints, request/response structures, and documentation.',
                  gradientColors: const [Color(0xFF43E97B), Color(0xFF38F9D7)],
                  onTap: () => _navigateToUnderDevelopment(context),
                ),
                _ArchitectureCard(
                  icon: Icons.download_outlined,
                  title: 'Export\nRequirements',
                  description:
                      'Export all collected requirements, user stories, and technical specifications in various formats.',
                  gradientColors: const [Color(0xFFFA709A), Color(0xFFFEE140)],
                  onTap: () => _navigateToUnderDevelopment(context),
                ),
                _ArchitectureCard(
                  icon: Icons.groups_outlined,
                  title: 'Team\nManagement',
                  description:
                      'Organize your development team by assigning roles, responsibilities, and tasks.',
                  gradientColors: const [Color(0xFF30CFD0), Color(0xFF330867)],
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => TeamManagementScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // ✅ Extra padding at bottom
          ],
        ),
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ArchitectureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.onTap,
  });

  // ✅ Info icon opens minimal dialog
  void _showInfoDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title.replaceAll('\n', ' '),
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description only - no subtitle
              Text(
                description,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Single close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gradientColors.first,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, // ✅ Card tap goes directly to Under Development
        borderRadius: BorderRadius.circular(20),
        splashColor: gradientColors.first.withOpacity(0.1),
        highlightColor: gradientColors.first.withOpacity(0.05),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
                isDark
                    ? AppColors.darkSurface.withOpacity(0.95)
                    : AppColors.lightSurface.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: gradientColors.first.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18), // ✅ Reduced padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with gradient
                Container(
                  padding: const EdgeInsets.all(14), // ✅ Reduced padding
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28, // ✅ Reduced icon size
                  ),
                ),
                const SizedBox(height: 12), // ✅ Reduced spacing
                // Title
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 15, // ✅ Reduced font size
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Info icon - opens dialog
                GestureDetector(
                  onTap: () {
                    _showInfoDialog(context); // ✅ Only info icon opens dialog
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: gradientColors.first.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      size: 18,
                      color: gradientColors.first,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ Under Development Page
class UnderDevelopmentPage extends StatelessWidget {
  const UnderDevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.brandGreen.withOpacity(0.2),
                      AppColors.brandGreen.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_outlined,
                  size: 80,
                  color: AppColors.brandGreen,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Under Development',
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'This feature is coming soon!\nStay tuned for updates.',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Go Back',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
