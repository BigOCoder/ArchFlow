
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:archflow/shared/widgets/app_color.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

class FinalReviewScreen extends ConsumerStatefulWidget {
  const FinalReviewScreen({super.key});

  @override
  ConsumerState<FinalReviewScreen> createState() => _FinalReviewScreenState();
}

class _FinalReviewScreenState extends ConsumerState<FinalReviewScreen> {
  bool _confirmed = false;

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

  void _finish() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final s = ref.watch(onboardingProvider);

    // Calculate difficulty based on skills
    final difficulty = s.skills.length >= 4
        ? 'Advanced Path'
        : 'Intermediate Path';

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Review & Confirm',
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
              const StepHeader(currentStep: 8, title: 'Final Review'),

              const SizedBox(height: 24),

              /// 🎯 HERO CARD - Your Goal
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
                            Icons.flag_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Your Learning Goal',
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
                      s.primaryGoal?.displayName ?? 'Not Set',
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
                          s.timeline?.displayName ?? '—',
                          icon: Icons.access_time,
                        ),
                        _pill(difficulty, icon: Icons.trending_up),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// 🧬 SKILL DNA
              if (s.skills.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.code, color: AppColors.brandGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Your Skills',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: s.skills.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final skill = s.skills[i];
                      final progress = skill.level == ProficiencyLevel.beginner
                          ? 0.33
                          : skill.level == ProficiencyLevel.intermediate
                          ? 0.66
                          : 1.0;

                      return Container(
                        width: 180,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
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
                            Text(
                              skill.skill?.displayName ?? '—',
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const Spacer(),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                color: AppColors.brandGreen,
                                backgroundColor: isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              skill.level?.displayName ?? '—',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandGreen,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              /// 📚 DETAILS CARDS
              /// 🎓 Education Background (Step 1)
              _infoCard(
                isDark: isDark,
                icon: Icons.school_outlined,
                title: 'Education Background',
                onEdit: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .goToStep(0, returnStep: 7); // ✅ Fixed
                },
                children: [
                  _infoRow(
                    'Education Level',
                    s.educationLevel?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Background',
                    s.csBackground?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  if (s.coreSubjects.isNotEmpty)
                    _infoRow(
                      'Core Subjects',
                      s.coreSubjects.join(', '),
                      isDark: isDark,
                    ),
                ],
              ),

              /// 💻 Skills & Proficiency (Step 2) - ADDED
              if (s.skills.isNotEmpty)
                _infoCard(
                  isDark: isDark,
                  icon: Icons.code_outlined,
                  title: 'Skills & Proficiency',
                  onEdit: () {
                    ref
                        .read(onboardingProvider.notifier)
                        .goToStep(1, returnStep: 7); // ✅ Added
                  },
                  children: s.skills.map((skill) {
                    return _infoRow(
                      skill.skill?.displayName ?? '—',
                      skill.level?.displayName ?? '—',
                      isDark: isDark,
                    );
                  }).toList(),
                ),

              /// 🎯 Primary Goal & Timeline (Step 3) - ADDED
              _infoCard(
                isDark: isDark,
                icon: Icons.flag_outlined,
                title: 'Primary Goal & Timeline',
                onEdit: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .goToStep(2, returnStep: 7); // ✅ Added
                },
                children: [
                  _infoRow(
                    'Primary Goal',
                    s.primaryGoal?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Timeline',
                    s.timeline?.displayName ?? '—',
                    isDark: isDark,
                  ),
                ],
              ),

              /// 🏗 Architecture Knowledge (Step 5)
              _infoCard(
                isDark: isDark,
                icon: Icons.architecture_outlined,
                title: 'Architecture Knowledge',
                onEdit: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .goToStep(4, returnStep: 7); // ✅ Fixed
                },
                children: [
                  _infoRow(
                    'Experience Level',
                    s.architectureLevel?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  if (s.familiarConcepts.isNotEmpty)
                    _infoRow(
                      'Known Concepts',
                      s.familiarConcepts.join(', '),
                      isDark: isDark,
                    ),
                ],
              ),

              /// 🗄 Database Experience (Step 6)
              _infoCard(
                isDark: isDark,
                icon: Icons.storage_outlined,
                title: 'Database Experience',
                onEdit: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .goToStep(5, returnStep: 7); // ✅ Fixed
                },
                children: [
                  _infoRow(
                    'Database Type',
                    s.databaseType?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Comfort Level',
                    s.databaseComfortLevel?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  if (s.databasesUsed.isNotEmpty)
                    _infoRow(
                      'Databases Used',
                      s.databasesUsed.join(', '),
                      isDark: isDark,
                    ),
                ],
              ),

              /// 🐞 Coding Practice (Step 7)
              _infoCard(
                isDark: isDark,
                icon: Icons.bug_report_outlined,
                title: 'Coding Practice',
                onEdit: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .goToStep(6, returnStep: 7); // ✅ Fixed
                },
                children: [
                  _infoRow(
                    'Coding Frequency',
                    s.codingFrequency?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  _infoRow(
                    'Debugging Confidence',
                    s.debuggingConfidence?.displayName ?? '—',
                    isDark: isDark,
                  ),
                  if (s.problemSolvingAreas.isNotEmpty)
                    _infoRow(
                      'Focus Areas',
                      s.problemSolvingAreas.join(', '),
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

              /// 🚀 START BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _confirmed ? _finish : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    elevation: _confirmed ? 4 : 0,
                    shadowColor: AppColors.brandGreen.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.rocket_launch, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Start My Learning Journey',
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
