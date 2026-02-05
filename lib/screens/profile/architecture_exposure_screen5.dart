import 'package:archflow/data/models/app_enums.dart';
import 'package:archflow/provider/authProvider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:archflow/themeData/app_color.dart';
import 'package:archflow/utils/app_snackbar.dart';
import 'package:archflow/widget/common/step_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ArchitectureExposureScreen extends ConsumerStatefulWidget {
  const ArchitectureExposureScreen({super.key});

  @override
  ConsumerState<ArchitectureExposureScreen> createState() =>
      _ArchitectureExposureScreenState();
}

class _ArchitectureExposureScreenState
    extends ConsumerState<ArchitectureExposureScreen> {
  ArchitectureLevel? _architectureLevel;

  final Map<String, bool> _familiarConcepts = {
    'MVC': false,
    'Repository pattern': false,
    'DTOs': false,
    'SOLID principles': false,
    'Design patterns': false,
  };

  bool _conceptsRestored = false;

  /// ---------------- STATE RESTORE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _architectureLevel ??= onboarding.architectureLevel;

    if (!_conceptsRestored && onboarding.familiarConcepts.isNotEmpty) {
      for (final c in onboarding.familiarConcepts) {
        if (_familiarConcepts.containsKey(c)) {
          _familiarConcepts[c] = true;
        }
      }
      _conceptsRestored = true;
    }
  }

  bool get _canProceed => _architectureLevel != null;

  /// ---------------- SUBMIT ----------------
  void _submit() {
    if (!_canProceed) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select your architecture experience level',
      );
      return;
    }

    final selectedConcepts = _familiarConcepts.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);

    notifier.setArchitectureLevel(_architectureLevel!);
    notifier.setFamiliarConcepts(selectedConcepts);
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
            const StepHeader(currentStep: 5, title: 'Architecture Exposure'),

            const SizedBox(height: 24),

            Text(
              'Tell us about your software architecture experience.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 24),

            /// 🏗 ARCHITECTURE LEVEL
            _card(
              isDark: isDark,
              title: 'Architecture Experience Level',
              child: Column(
                children: ArchitectureLevel.values.map((level) {
                  return RadioListTile<ArchitectureLevel>(
                    value: level,
                    groupValue: _architectureLevel,
                    onChanged: (v) {
                      setState(() {
                        _architectureLevel = v;
                        // Clear all concepts if user selects "No Experience Yet"
                        if (v == ArchitectureLevel.none) {
                          _familiarConcepts.updateAll((_, _) => false);
                        }
                      });
                    },
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

            /// 🧠 FAMILIAR CONCEPTS
            if (_architectureLevel != null &&
                _architectureLevel != ArchitectureLevel.none)
              _card(
                isDark: isDark,
                title: 'Familiar Concepts (Optional)',
                child: Column(
                  children: _familiarConcepts.keys.map((key) {
                    return CheckboxListTile(
                      value: _familiarConcepts[key],
                      onChanged: (v) =>
                          setState(() => _familiarConcepts[key] = v ?? false),
                      title: Text(
                        key,
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

            /// Show helper text when no experience
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brandGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.brandGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.brandGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No worries! We\'ll guide you through architecture concepts.',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

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
    );
  }
}
