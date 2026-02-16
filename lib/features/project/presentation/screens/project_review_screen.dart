import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/chat/presentation/providers/chat_provider.dart';
import 'package:archflow/features/chat/presentation/screens/ai_chat_screen.dart';
import 'package:archflow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:archflow/features/integrations/presentation/screens/github_integration_screen.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/features/project/presentation/providers/project_provider.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectReviewScreen extends ConsumerStatefulWidget {
  const ProjectReviewScreen({super.key});

  @override
  ConsumerState<ProjectReviewScreen> createState() =>
      _ProjectReviewScreenState();
}

class _ProjectReviewScreenState extends ConsumerState<ProjectReviewScreen> {
  bool _confirmed = false;

  // ✅ IMPORTANT: Show cancel confirmation dialog
  Future<bool> _showCancelDialog(BuildContext context, bool isDark) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        title: Text(
          'Cancel Project Creation?',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel? All your progress will be lost.',
          style: GoogleFonts.lato(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Continue Editing',
              style: GoogleFonts.lato(
                color: AppColors.brandGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Cancel Project',
              style: GoogleFonts.lato(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldCancel ?? false;
  }

  Widget _pill(String text, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required List<Widget> children,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.brandGreen, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                if (onEdit != null)
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppColors.brandGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Edit',
                            style: GoogleFonts.lato(
                              color: AppColors.brandGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final onboarding = ref.read(projectOnboardingProvider);
    final notifier = ref.read(projectProvider.notifier);

    notifier.updateBasics(
      name: onboarding.projectName,
      summary: onboarding.description,
      category: onboarding.category!.displayName,
    );

    notifier.updateTargetUsers(
      primaryUserType: onboarding.primaryUserType,
      userScale: onboarding.userScale,
      userRoles: onboarding.userRoles,
    );

    notifier.updateFeatures(onboarding.features);

    notifier.updateProblem(
      problemStatement: onboarding.problemStatement,
      currentSolution: onboarding.targetAudience.isEmpty
          ? null
          : onboarding.targetAudience,
      whyInsufficient: onboarding.proposedSolution.isEmpty
          ? null
          : onboarding.proposedSolution,
    );

    notifier.updateTechnicalDetails(
      platforms: onboarding.platforms,
      supportedDevices: onboarding.supportedDevices,
      expectedTimeline: onboarding.expectedTimeline,
      budgetRange: onboarding.budgetRange,
      expectedTraffic: onboarding.expectedTraffic,
      dataSensitivity: onboarding.dataSensitivity,
      complianceNeeds: onboarding.complianceNeeds,
    );

    final success = await notifier.createProject();

    if (!context.mounted) return;

    if (success) {
      // ✅ IMPORTANT: Clear chat on success
      ref.read(chatProvider.notifier).clearChat();

      AppSnackBar.show(
        context,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.brandGreen,
        message: 'Project created successfully!',
      );

      // Reset onboarding state
      ref.read(projectOnboardingProvider.notifier).reset();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AIChatScreen()),
        (_) => false,
      );
    } else {
      final error = ref.read(projectProvider).error;
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: error ?? 'Failed to create project',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = ref.watch(projectProvider.select((s) => s.isLoading));
    final s = ref.watch(projectOnboardingProvider);

    return WillPopScope(
      onWillPop: () async {
        // ✅ IMPORTANT: Show cancel confirmation dialog when going back
        final shouldCancel = await _showCancelDialog(context, isDark);

        if (shouldCancel && mounted) {
          // Clear chat and reset state
          ref.read(chatProvider.notifier).clearChat();
          ref.read(projectOnboardingProvider.notifier).reset();

          // Navigate to dashboard
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (_) => false,
          );
        }

        return false; // Prevent default pop
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          elevation: 0,
          // ✅ IMPORTANT: Add back button with cancel dialog
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            onPressed: () async {
              // Show cancel confirmation dialog
              final shouldCancel = await _showCancelDialog(context, isDark);

              if (shouldCancel && mounted) {
                // Clear chat and reset state
                ref.read(chatProvider.notifier).clearChat();
                ref.read(projectOnboardingProvider.notifier).reset();

                // Navigate to dashboard
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (_) => false,
                );
              }
            },
          ),
          title: Text(
            'Review & Create',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                currentStep: 5,
                totalSteps: 5,
                title: 'Final Review',
              ),
              const SizedBox(height: 24),

              /// 🎯 HERO CARD - Project Overview
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.brandGreen,
                      AppColors.brandGreen.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandGreen.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.rocket_launch_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Your Project',
                          style: GoogleFonts.lato(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.projectName.isEmpty
                          ? 'Untitled Project'
                          : s.projectName,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _pill(
                          s.category?.displayName ?? 'No Category',
                          icon: Icons.category_outlined,
                        ),
                        if (s.features.isNotEmpty)
                          _pill(
                            '${s.features.length} Features',
                            icon: Icons.fact_check_outlined,
                          ),
                        if (s.platforms.isNotEmpty)
                          _pill(
                            '${s.platforms.length} Platforms',
                            icon: Icons.devices_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// 📝 PROJECT BASICS (Step 0)
              _infoCard(
                isDark: isDark,
                icon: Icons.edit_document,
                title: 'Project Basics',
                onEdit: () {
                  // ✅ IMPORTANT: Set edit mode before navigating
                  ref.read(projectOnboardingProvider.notifier).setEditMode();
                  ref.read(projectOnboardingProvider.notifier).goToStep(0);
                },
                children: [
                  _infoRow(
                    'Project Name',
                    s.projectName.isEmpty ? 'Not Set' : s.projectName,
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Category',
                    s.category?.displayName ?? 'Not Set',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Description',
                    s.description.isEmpty ? 'Not Provided' : s.description,
                    isDark: isDark,
                  ),
                ],
              ),

              /// 👥 TARGET USERS (Step 1)
              _infoCard(
                isDark: isDark,
                icon: Icons.people_outline,
                title: 'Target Users',
                onEdit: () {
                  // ✅ IMPORTANT: Set edit mode before navigating
                  ref.read(projectOnboardingProvider.notifier).setEditMode();
                  ref.read(projectOnboardingProvider.notifier).goToStep(1);
                },
                children: [
                  _infoRow(
                    'Primary User Type',
                    s.primaryUserType?.displayName ?? 'Not Set',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'User Scale',
                    s.userScale?.displayName ?? 'Not Set',
                    isDark: isDark,
                  ),
                  if (s.userRoles.isNotEmpty)
                    _infoRow(
                      'User Roles',
                      '${s.userRoles.length} roles defined',
                      isDark: isDark,
                    ),
                ],
              ),

              /// ✨ FEATURES (Step 2)
              if (s.features.isNotEmpty)
                _infoCard(
                  isDark: isDark,
                  icon: Icons.star_outline,
                  title: 'Initial Features',
                  onEdit: () {
                    // ✅ IMPORTANT: Set edit mode before navigating
                    ref.read(projectOnboardingProvider.notifier).setEditMode();
                    ref.read(projectOnboardingProvider.notifier).goToStep(2);
                  },
                  children: s.features.take(5).map((feature) {
                    return _infoRow(
                      feature.name,
                      feature.priority?.displayName ?? 'No Priority',
                      isDark: isDark,
                    );
                  }).toList(),
                ),

              /// 🎯 PROBLEM STATEMENT (Step 3)
              _infoCard(
                isDark: isDark,
                icon: Icons.lightbulb_outline,
                title: 'Problem Statement',
                onEdit: () {
                  // ✅ IMPORTANT: Set edit mode before navigating
                  ref.read(projectOnboardingProvider.notifier).setEditMode();
                  ref.read(projectOnboardingProvider.notifier).goToStep(3);
                },
                children: [
                  _infoRow(
                    'Problem',
                    s.problemStatement.isEmpty
                        ? 'Not Provided'
                        : s.problemStatement,
                    isDark: isDark,
                  ),
                  if (s.targetAudience.isNotEmpty)
                    _infoRow(
                      'Target Audience',
                      s.targetAudience,
                      isDark: isDark,
                    ),
                  if (s.proposedSolution.isNotEmpty)
                    _infoRow(
                      'Proposed Solution',
                      s.proposedSolution,
                      isDark: isDark,
                    ),
                ],
              ),

              /// 💻 PROJECT DETAILS (Step 4)
              _infoCard(
                isDark: isDark,
                icon: Icons.settings_outlined,
                title: 'Technical Details',
                onEdit: () {
                  // ✅ IMPORTANT: Set edit mode before navigating
                  ref.read(projectOnboardingProvider.notifier).setEditMode();
                  ref.read(projectOnboardingProvider.notifier).goToStep(4);
                },
                children: [
                  if (s.platforms.isNotEmpty)
                    _infoRow(
                      'Platforms',
                      s.platforms.join(', '),
                      isDark: isDark,
                    ),
                  if (s.supportedDevices.isNotEmpty)
                    _infoRow(
                      'Devices',
                      s.supportedDevices.join(', '),
                      isDark: isDark,
                    ),
                  if (s.expectedTimeline != null)
                    _infoRow('Timeline', s.expectedTimeline!, isDark: isDark),
                  if (s.budgetRange != null)
                    _infoRow('Budget', s.budgetRange!, isDark: isDark),
                  if (s.expectedTraffic != null)
                    _infoRow(
                      'Expected Traffic',
                      s.expectedTraffic!,
                      isDark: isDark,
                    ),
                  if (s.dataSensitivity.isNotEmpty)
                    _infoRow(
                      'Data Sensitivity',
                      s.dataSensitivity.join(', '),
                      isDark: isDark,
                    ),
                  if (s.complianceNeeds.isNotEmpty)
                    _infoRow(
                      'Compliance',
                      s.complianceNeeds.join(', '),
                      isDark: isDark,
                    ),
                ],
              ),

              const SizedBox(height: 24),

              /// ✅ CONFIRMATION
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.brandGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.brandGreen.withOpacity(0.3),
                  ),
                ),
                child: CheckboxListTile(
                  value: _confirmed,
                  onChanged: (v) => setState(() => _confirmed = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'I confirm that all the information provided is accurate',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  activeColor: AppColors.brandGreen,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 24),

              /// 🚀 CREATE PROJECT BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _confirmed && !isLoading
                      ? () => _submit(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    elevation: _confirmed && !isLoading ? 4 : 0,
                    shadowColor: AppColors.brandGreen.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.rocket_launch, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              'Create Project',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
