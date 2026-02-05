import 'package:archflow/data/models/app_enums.dart';
import 'package:archflow/provider/authProvider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:archflow/themeData/app_color.dart';
import 'package:archflow/utils/app_snackbar.dart';
import 'package:archflow/widget/common/step_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryGoalScreen extends ConsumerStatefulWidget {
  const PrimaryGoalScreen({super.key});

  @override
  ConsumerState<PrimaryGoalScreen> createState() => _PrimaryGoalScreenState();
}

class _PrimaryGoalScreenState extends ConsumerState<PrimaryGoalScreen> {
  PrimaryGoal? _goal;
  Timeline? _timeline;

  /// ---------------- STATE RESTORE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);
    _goal ??= onboarding.primaryGoal;
    _timeline ??= onboarding.timeline;
  }

  /// ---------------- SUBMIT ----------------
  void _submit() {
    if (_goal == null || _timeline == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select goal and timeline',
      );
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setPrimaryGoal(_goal!);
    notifier.setTimeline(_timeline!);
    notifier.nextStep();
  }

  /// ---------------- UI HELPERS ----------------
  Widget _card({
    required bool isDark,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _radioTile<T>({
    required bool isDark,
    required T value,
    required T? groupValue,
    required String label,
    required void Function(T?) onChanged,
  }) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.brandGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        label,
        style: GoogleFonts.lato(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }


  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            ref.read(onboardingProvider.notifier).previousStep();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(currentStep: 3, title: 'Primary Goal'),

            const SizedBox(height: 24),

            Text(
              'Primary Goal',
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What is your main objective and timeline?',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            /// 🎯 GOAL
            _card(
              isDark: isDark,
              title: 'Primary Goal',
              child: Column(
                children: PrimaryGoal.values.map((goal) {
                  return _radioTile(
                    isDark: isDark,
                    value: goal,
                    groupValue: _goal,
                    label: goal.displayName, // ✅ Beautiful display
                    onChanged: (v) => setState(() => _goal = v),
                  );
                }).toList(),
              ),
            ),

            /// ⏱️ TIMELINE
            _card(
              isDark: isDark,
              title: 'Timeline',
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3.5,
                children: Timeline.values.map((t) {
                  final isSelected = _timeline == t;
                  return InkWell(
                    onTap: () => setState(() => _timeline = t),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.brandGreen
                              : (isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider),
                          width: isSelected
                              ? 2
                              : 1, // ✅ Thicker border when selected
                        ),
                        color: isSelected
                            ? AppColors.brandGreen.withOpacity(
                                0.1,
                              ) // ✅ Subtle background
                            : Colors.transparent,
                      ),
                      child: Text(
                        t.displayName, // ✅ Beautiful display
                        style: GoogleFonts.lato(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.brandGreen
                              : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_goal != null && _timeline != null)
                    ? _submit
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
