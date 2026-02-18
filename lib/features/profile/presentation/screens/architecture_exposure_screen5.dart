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
  final Map<String, String> _conceptsMap = {
    'MVC': 'MVC',
    'Repository pattern': 'REPOSITORY_PATTERN',
    'DTOs': 'DTOS',
    'SOLID principles': 'SOLID_PRINCIPLES',
    'Design patterns': 'DESIGN_PATTERNS',
  };

  bool _conceptsRestored = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _architectureLevel ??= onboarding.architectureLevel;

    if (!_conceptsRestored && onboarding.familiarConcepts.isNotEmpty) {
      for (final c in onboarding.familiarConcepts) {
        final displayName = _conceptsMap.entries
            .firstWhere((e) => e.value == c, orElse: () => MapEntry(c, c))
            .key;

        if (_familiarConcepts.containsKey(displayName)) {
          _familiarConcepts[displayName] = true;
        }
      }
      _conceptsRestored = true;
    }
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

  bool get _canProceed => _architectureLevel != null;

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
        .map((e) => _conceptsMap[e.key]!)
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);

    notifier.setArchitectureLevel(_architectureLevel!);
    notifier.setFamiliarConcepts(selectedConcepts);

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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
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
            'Architecture Exposure',
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
                currentStep: 5,
                title: 'Software architecture experience?',
              ),

              const SizedBox(height: 24),

              _card(
                title: 'Architecture Experience Level',
                child: Column(
                  children: ArchitectureLevel.values.map((level) {
                    return RadioListTile<ArchitectureLevel>(
                      value: level,
                      groupValue: _architectureLevel,
                      onChanged: (v) {
                        setState(() {
                          _architectureLevel = v;
                          if (v == ArchitectureLevel.none) {
                            _familiarConcepts.updateAll((_, _) => false);
                          }
                        });
                      },
                      title: Text(
                        level.displayName,
                        style: GoogleFonts.lato(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      activeColor: AppColors.brandGreen,
                    );
                  }).toList(),
                ),
              ),

              if (_architectureLevel != null &&
                  _architectureLevel != ArchitectureLevel.none)
                _card(
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
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        activeColor: AppColors.brandGreen,
                      );
                    }).toList(),
                  ),
                ),

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
                          color: Theme.of(context).colorScheme.onBackground,
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
