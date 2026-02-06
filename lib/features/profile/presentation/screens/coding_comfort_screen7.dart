import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


class CodingComfortScreen extends ConsumerStatefulWidget {
  const CodingComfortScreen({super.key});


  @override
  ConsumerState<CodingComfortScreen> createState() =>
      _CodingComfortScreenState();
}


class _CodingComfortScreenState
    extends ConsumerState<CodingComfortScreen> {
  CodingFrequency? _frequency;
  DebuggingConfidence? _debugging;


  final Map<String, bool> _problemAreas = {
    'Loops & conditions': false,
    'Functions': false,
    'OOP': false,
    'DSA basics': false,
    'Advanced DSA': false,
  };


  bool _areasRestored = false;


  /// ---------------- STATE RESTORE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    final onboarding = ref.read(onboardingProvider);


    _frequency ??= onboarding.codingFrequency;
    _debugging ??= onboarding.debuggingConfidence;


    if (!_areasRestored &&
        onboarding.problemSolvingAreas.isNotEmpty) {
      for (final area in onboarding.problemSolvingAreas) {
        if (_problemAreas.containsKey(area)) {
          _problemAreas[area] = true;
        }
      }
      _areasRestored = true;
    }
  }


  bool get _canProceed =>
      _frequency != null &&
      _debugging != null &&
      _problemAreas.values.any((v) => v);


  /// ---------------- SUBMIT ----------------
  void _submit() {
    if (!_canProceed) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please complete all sections',
      );
      return;
    }


    final selectedAreas = _problemAreas.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();


    final notifier = ref.read(onboardingProvider.notifier);


    notifier.setCodingFrequency(_frequency!);
    notifier.setDebuggingConfidence(_debugging!);
    notifier.setProblemSolvingAreas(selectedAreas);
    notifier.nextStep();
  }


  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;


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
            ref
                .read(onboardingProvider.notifier)
                .previousStep();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(
              currentStep: 7,
              title: 'Coding Comfort Level',
            ),


            const SizedBox(height: 24),


            Text(
              'Help us understand your coding experience and confidence.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),


            const SizedBox(height: 32),


            /// ⏱ CODING FREQUENCY
            Container(
              margin: const EdgeInsets.only(bottom: 20),
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
              ),
              child: AppDropdown<CodingFrequency>(
                label: 'Coding Frequency',
                icon: Icons.schedule,
                value: _frequency,
                hasError: false,
                entries: CodingFrequency.values
                    .map(
                      (freq) => DropdownMenuEntry(
                        value: freq,
                        label: freq.displayName,
                      ),
                    )
                    .toList(),
                onSelected: (v) {
                  setState(() {
                    _frequency = v;
                  });
                },
              ),
            ),


            /// 🐞 DEBUGGING CONFIDENCE
            Container(
              margin: const EdgeInsets.only(bottom: 20),
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
              ),
              child: AppDropdown<DebuggingConfidence>(
                label: 'Debugging Confidence',
                icon: Icons.bug_report,
                value: _debugging,
                hasError: false,
                entries: DebuggingConfidence.values
                    .map(
                      (level) => DropdownMenuEntry(
                        value: level,
                        label: level.displayName,
                      ),
                    )
                    .toList(),
                onSelected: (v) {
                  setState(() {
                    _debugging = v;
                  });
                },
              ),
            ),


            /// 🧠 PROBLEM AREAS
            Container(
              margin: const EdgeInsets.only(bottom: 24),
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Problem-solving Areas',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._problemAreas.keys.map((area) {
                    return CheckboxListTile(
                      value: _problemAreas[area],
                      onChanged: (v) =>
                          setState(() => _problemAreas[area] = v ?? false),
                      title: Text(
                        area,
                        style: GoogleFonts.lato(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      activeColor: AppColors.brandGreen,
                    );
                  }),
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
