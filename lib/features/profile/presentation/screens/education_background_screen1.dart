import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationBackgroundScreen extends ConsumerStatefulWidget {
  const EducationBackgroundScreen({super.key});

  @override
  ConsumerState<EducationBackgroundScreen> createState() =>
      _EducationBackgroundScreenState();
}

class _EducationBackgroundScreenState
    extends ConsumerState<EducationBackgroundScreen> {
  EducationLevel? _educationLevel;
  CsBackground? _csBackground;
  bool _coreSubjectsRestored = false;

  bool get _hasSelectedCoreSubject => _coreSubjects.values.any((v) => v);

  final Map<String, bool> _coreSubjects = {
    'Data Structures': false,
    'OOP': false,
    'DBMS': false,
    'Operating Systems': false,
    'Computer Networks': false,
  };

  // ✅ ADD THIS NEW MAP HERE:
  final Map<String, String> _coreSubjectsMap = {
    'Data Structures': 'DATA_STRUCTURES',
    'OOP': 'OOP',
    'DBMS': 'DBMS',
    'Operating Systems': 'OPERATING_SYSTEM',
    'Computer Networks': 'COMPUTER_NETWORKS',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _educationLevel ??= onboarding.educationLevel;
    _csBackground ??= onboarding.csBackground;

    if (!_coreSubjectsRestored && onboarding.coreSubjects.isNotEmpty) {
      for (final subject in onboarding.coreSubjects) {
        // Convert backend value to display name (DATA_STRUCTURES -> Data Structures)
        final displayName = _coreSubjectsMap.entries
            .firstWhere(
              (e) => e.value == subject,
              orElse: () => MapEntry(subject, subject),
            )
            .key;

        if (_coreSubjects.containsKey(displayName)) {
          _coreSubjects[displayName] = true;
        }
      }
      _coreSubjectsRestored = true;
    }
  }

  void _submit() {
    if (_educationLevel == null || _csBackground == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please answer all required questions',
      );
      return;
    }

    if (!_hasSelectedCoreSubject) {
      AppSnackBar.show(
        context,
        icon: Icons.menu_book_outlined,
        iconColor: AppColors.error,
        message: 'Please select at least one core subject',
      );
      return;
    }

    final selectedSubjects = _coreSubjects.entries
        .where((e) => e.value)
        .map((e) => _coreSubjectsMap[e.key]!) 
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);

    notifier.setEducationLevel(_educationLevel!);
    notifier.setCsBackground(_csBackground!);
    notifier.setCoreSubjects(selectedSubjects);

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

  Widget _sectionCard({
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false, // ✅ Prevents system back
      onPopInvoked: (didPop) {
        // Do nothing - user cannot go back from screen 1
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false, // ✅ No back arrow
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'Education & Learning Background',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepHeader(
                currentStep: 1,
                title: 'Education & Learning Background',
              ),
              const SizedBox(height: 24),

              Text(
                'Help us understand your academic background.',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              /// 🎓 Education Level
              _sectionCard(
                isDark: isDark,
                title: 'Highest education level',
                child: Column(
                  children: EducationLevel.values.map((level) {
                    return RadioListTile<EducationLevel>(
                      value: level,
                      groupValue: _educationLevel,
                      onChanged: (v) => setState(() => _educationLevel = v),
                      title: Text(
                        level.displayName, // ✅ Beautiful display
                        style: GoogleFonts.lato(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      activeColor: AppColors.brandGreen,
                    );
                  }).toList(),
                ),
              ),

              /// 💻 CS Background
              _sectionCard(
                isDark: isDark,
                title: 'CS background',
                child: Column(
                  children: CsBackground.values.map((bg) {
                    return RadioListTile<CsBackground>(
                      value: bg,
                      groupValue: _csBackground,
                      onChanged: (v) => setState(() => _csBackground = v),
                      title: Text(
                        bg.displayName, // ✅ Beautiful display
                        style: GoogleFonts.lato(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      activeColor: AppColors.brandGreen,
                    );
                  }).toList(),
                ),
              ),

              /// 📚 Core Subjects
              _sectionCard(
                isDark: isDark,
                title: 'Core subjects knowledge',
                child: Column(
                  children: _coreSubjects.keys.map((key) {
                    return CheckboxListTile(
                      value: _coreSubjects[key],
                      onChanged: (v) =>
                          setState(() => _coreSubjects[key] = v ?? false),
                      title: Text(key, style: GoogleFonts.lato()),
                      activeColor: AppColors.brandGreen,
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Save',
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
