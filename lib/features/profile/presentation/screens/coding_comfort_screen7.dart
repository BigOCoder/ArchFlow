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

class CodingComfortScreen extends ConsumerStatefulWidget {
  const CodingComfortScreen({super.key});

  @override
  ConsumerState<CodingComfortScreen> createState() =>
      _CodingComfortScreenState();
}

class _CodingComfortScreenState extends ConsumerState<CodingComfortScreen> {
  CodingFrequency? _frequency;
  DebuggingConfidence? _debugging;

  final Map<String, bool> _problemAreas = {
    'Loops & conditions': false,
    'Functions': false,
    'OOP': false,
    'DSA basics': false,
    'Advanced DSA': false,
  };

  final Map<String, String> _problemAreasMap = {
    'Loops & conditions': 'LOOPS_AND_CONDITIONS',
    'Functions': 'FUNCTIONS',
    'OOP': 'OOP',
    'DSA basics': 'DSA_BASICS',
    'Advanced DSA': 'ADVANCED_DSA',
  };

  bool _areasRestored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _frequency ??= onboarding.codingFrequency;
    _debugging ??= onboarding.debuggingConfidence;

    if (!_areasRestored && onboarding.problemSolvingAreas.isNotEmpty) {
      for (final area in onboarding.problemSolvingAreas) {
        final displayName = _problemAreasMap.entries
            .firstWhere(
              (e) => e.value == area,
              orElse: () => MapEntry(area, area),
            )
            .key;

        if (_problemAreas.containsKey(displayName)) {
          _problemAreas[displayName] = true;
        }
      }
      _areasRestored = true;
    }
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

  bool get _canProceed =>
      _frequency != null &&
      _debugging != null &&
      _problemAreas.values.any((v) => v);

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
        .map((e) => _problemAreasMap[e.key]!)
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setCodingFrequency(_frequency!);
    notifier.setDebuggingConfidence(_debugging!);
    notifier.setProblemSolvingAreas(selectedAreas);

    final isEditing = ref.read(onboardingProvider).isEditingFromReview;

    if (isEditing) {
      notifier.clearEditMode();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    }
  }

  // ✅ Reusable card with theme colors
  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: child,
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
            'Coding Comfort Level',
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
              const StepHeader(
                currentStep: 7,
                title: 'Coding experience and confidence?',
              ),

              const SizedBox(height: 24),

              /// ⏱ CODING FREQUENCY
              _sectionCard(
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
              _sectionCard(
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
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Problem-solving Areas',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
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
                            color: Theme.of(context).colorScheme.onSurface,
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
