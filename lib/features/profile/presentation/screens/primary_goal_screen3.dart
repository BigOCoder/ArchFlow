import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);
    _goal ??= onboarding.primaryGoal;
    _timeline ??= onboarding.timeline;
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

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
    final isEditing = ref.read(onboardingProvider).isEditingFromReview;

    if (isEditing) {
      notifier.clearEditMode();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    } else {
      notifier.nextStep();
    }
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ Fixed - uses theme
          color: Theme.of(context).dividerColor,
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
              // ✅ Fixed - uses theme
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _radioTile<T>({
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
          // ✅ Fixed - uses theme
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackPressed();
        return false;
      },
      child: Scaffold(
        // ✅ Removed backgroundColor - uses theme
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // ✅ Removed color - uses theme iconTheme
            onPressed: _handleBackPressed,
          ),
          title: Text(
            'Primary Goal',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              // ✅ Fixed - uses theme
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                currentStep: 3,
                title: 'Objective and Timeline?',
              ),

              const SizedBox(height: 24),

              /// 🎯 GOAL
              _card(
                title: 'Primary Goal',
                child: Column(
                  children: PrimaryGoal.values.map((goal) {
                    return _radioTile(
                      value: goal,
                      groupValue: _goal,
                      label: goal.displayName,
                      onChanged: (v) => setState(() => _goal = v),
                    );
                  }).toList(),
                ),
              ),

              /// ⏱️ TIMELINE
              _card(
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
                                // ✅ Fixed - uses theme
                                : Theme.of(context).dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                          color: isSelected
                              ? AppColors.brandGreen.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Text(
                          t.displayName,
                          style: GoogleFonts.lato(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.brandGreen
                                // ✅ Fixed - uses theme
                                : Theme.of(context).textTheme.bodyMedium?.color,
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
                  // ✅ Removed style - uses theme
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
      ),
    );
  }
}
