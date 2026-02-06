// lib/features/integrations/presentation/screens/github_integration_screen.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:archflow/features/integrations/presentation/widgets/integration_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GitHubIntegrationScreen extends StatelessWidget {
  const GitHubIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.terminal,
                      color: AppColors.brandGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Service Integrations',
                      style: GoogleFonts.lato(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Connect your development workflow to enable real-time project synchronization.',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  height: 1.5,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // Integration Cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      IntegrationCard(
                        icon: Icons.code,
                        iconBackgroundColor: isDark
                            ? const Color(0xFF1F2328)
                            : const Color(0xFFF6F8FA),
                        title: 'Authorize GitHub Access',
                        description:
                            'Connect your account to sync your public repositories and enable automated project tracking.',
                        buttonText: 'Connect with GitHub',
                        buttonIcon: Icons.link,
                        onConnect: () => _handleGitHubConnect(context),
                        onSkip: () => _handleSkip(context),
                      ),

                      const SizedBox(height: 16),

                      // Future integration placeholders (locked)
                      IntegrationCard(
                        icon: Icons.dashboard,
                        iconBackgroundColor: isDark
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFFF3F4F6),
                        title: 'Linear Integration',
                        description:
                            'Sync tasks and issues with Linear project management.',
                        buttonText: 'Coming Soon',
                        buttonIcon: Icons.lock_outline,
                        isLocked: true,
                        onConnect: null,
                        onSkip: null,
                      ),

                      const SizedBox(height: 16),

                      IntegrationCard(
                        icon: Icons.storage,
                        iconBackgroundColor: isDark
                            ? const Color(0xFF1C1E26)
                            : const Color(0xFFF9FAFB),
                        title: 'Jira Integration',
                        description:
                            'Connect with Jira for enterprise project tracking.',
                        buttonText: 'Coming Soon',
                        buttonIcon: Icons.lock_outline,
                        isLocked: true,
                        onConnect: null,
                        onSkip: null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Privacy Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface.withOpacity(0.5)
                      : AppColors.lightSurface.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By connecting, you agree to our ',
                            ),
                            TextSpan(
                              text: 'data sync terms',
                              style: TextStyle(
                                color: AppColors.brandGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGitHubConnect(BuildContext context) {
    // TODO: Implement GitHub OAuth flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening GitHub authorization...',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: AppColors.brandGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to next screen after connection
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const DashboardScreen()),
    // );
  }

  void _handleSkip(BuildContext context) {
    // Navigate to dashboard without connecting
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You can connect GitHub later from settings',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: const Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to next screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
}
