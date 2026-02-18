import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillEntry {
  SkillCategory? skill;
  ProficiencyLevel? level;
  bool levelError;
  bool duplicateError; // ✅ NEW: Track duplicate error

  SkillEntry({
    this.skill,
    this.level,
    this.levelError = false,
    this.duplicateError = false, // ✅ NEW
  });
}

class SkillsProficiencyScreen extends ConsumerStatefulWidget {
  const SkillsProficiencyScreen({super.key});

  @override
  ConsumerState<SkillsProficiencyScreen> createState() =>
      _SkillsProficiencyScreenState();
}

class _SkillsProficiencyScreenState
    extends ConsumerState<SkillsProficiencyScreen> {
  final List<SkillEntry> _skills = [SkillEntry()];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    if (_skills.length == 1 &&
        _skills.first.skill == null &&
        _skills.first.level == null &&
        onboarding.skills.isNotEmpty) {
      _skills
        ..clear()
        ..addAll(onboarding.skills);
    }
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

  bool _isValidSkill(SkillEntry s) => s.skill != null && s.level != null;

  bool get _hasPartialSkill => _skills.any(
    (s) =>
        (s.skill != null && s.level == null) ||
        (s.skill == null && s.level != null),
  );

  bool get _canProceed => _skills.any(_isValidSkill) && !_hasPartialSkill;

  // ✅ NEW: Get list of already selected skills
  Set<SkillCategory> get _selectedSkills {
    return _skills.where((s) => s.skill != null).map((s) => s.skill!).toSet();
  }

  // ✅ NEW: Get available skills for a specific entry
  List<SkillCategory> _getAvailableSkills(SkillEntry currentEntry) {
    final selectedSkills = _selectedSkills;

    return SkillCategory.values.where((skill) {
      // Include the skill if it's the current entry's skill OR not selected yet
      return skill == currentEntry.skill || !selectedSkills.contains(skill);
    }).toList();
  }

  // ✅ NEW: Check for duplicates
  bool _hasDuplicates() {
    final skillsWithValues = _skills
        .where((s) => s.skill != null)
        .map((s) => s.skill!)
        .toList();

    return skillsWithValues.length != skillsWithValues.toSet().length;
  }

  void _addSkill() {
    // ✅ NEW: Check if all skills are already selected
    if (_selectedSkills.length >= SkillCategory.values.length) {
      AppSnackBar.show(
        context,
        icon: Icons.info_outline,
        iconColor: AppColors.brandGreen,
        message: 'All available skills have been added',
      );
      return;
    }

    setState(() => _skills.add(SkillEntry()));
  }

  Widget _deleteBackground({required Alignment alignment}) {
    final bool isLeft = alignment == Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(bottom: 16), // ✅ Match child's margin
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16), // ✅ Match child's radius
      ),
      alignment: alignment,
      padding: EdgeInsets.only(left: isLeft ? 24 : 0, right: isLeft ? 0 : 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            'Delete',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    // Remove empty entries
    _skills.removeWhere((s) => s.skill == null && s.level == null);

    // ✅ NEW: Check for duplicates
    if (_hasDuplicates()) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please remove duplicate skills before proceeding',
      );
      return;
    }

    // Check for partial skills
    final partialSkill = _skills.firstWhere(
      (s) => s.skill != null && s.level == null,
      orElse: () => SkillEntry(),
    );

    if (partialSkill.skill != null && partialSkill.level == null) {
      setState(() => partialSkill.levelError = true);

      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message:
            'Please select proficiency level for ${partialSkill.skill!.displayName}', // ✅ Use displayName
      );
      return;
    }

    final validSkills = _skills.where(_isValidSkill).toList();

    if (validSkills.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please add at least one complete skill',
      );
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setSkills(validSkills);
    final isEditing = ref.read(onboardingProvider).isEditingFromReview;

    if (isEditing) {
      // Return to Final Review
      notifier.clearEditMode();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    } else {
      // Normal flow
      notifier.nextStep(); // Or Navigator.push for screen 7
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackPressed();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackPressed,
          ),
          title: Text(
            'Skills & Proficiency',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepHeader(
                currentStep: 2,
                title: 'Technical skills and Proficiency levels?',
              ),
              const SizedBox(height: 24),

              ..._skills.asMap().entries.map((entry) {
                final index = entry.key;
                final skill = entry.value;
                final availableSkills = _getAvailableSkills(skill);

                return Dismissible(
                  key: ValueKey(skill),
                  direction: _skills.length > 1
                      ? DismissDirection.horizontal
                      : DismissDirection.none,
                  background: _deleteBackground(
                    alignment: Alignment.centerLeft,
                  ),
                  secondaryBackground: _deleteBackground(
                    alignment: Alignment.centerRight,
                  ),
                  onDismissed: (direction) {
                    setState(() => _skills.removeAt(index));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Skill removed',
                          style: GoogleFonts.lato(),
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Column(
                      children: [
                        if (availableSkills.isEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.error.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'All skills selected. Remove this entry.',
                                    style: GoogleFonts.lato(
                                      fontSize: 13,
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        AppDropdown<SkillCategory>(
                          label: 'Skill Category',
                          icon: Icons.code,
                          value: skill.skill,
                          hasError: availableSkills.isEmpty,
                          entries: availableSkills
                              .map(
                                (s) => DropdownMenuEntry(
                                  value: s,
                                  label: s.displayName,
                                ),
                              )
                              .toList(),
                          onSelected: (v) {
                            setState(() {
                              skill.skill = v;
                              skill.duplicateError = false;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        AppDropdown<ProficiencyLevel>(
                          label: 'Level',
                          icon: Icons.trending_up,
                          value: skill.level,
                          hasError: skill.levelError,
                          entries: ProficiencyLevel.values
                              .map(
                                (level) => DropdownMenuEntry(
                                  value: level,
                                  label: level.displayName,
                                ),
                              )
                              .toList(),
                          onSelected: (v) {
                            setState(() {
                              skill.level = v;
                              skill.levelError = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _addSkill,
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Add Skill',
                    style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.brandGreen,
                    side: const BorderSide(color: AppColors.brandGreen),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canProceed ? _submit : null,
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
      ),
    );
  }
}
