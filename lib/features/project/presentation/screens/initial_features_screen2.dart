// lib/screens/project/initial_features_screen.dart
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_state.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialFeaturesScreen extends ConsumerStatefulWidget {
  const InitialFeaturesScreen({super.key});

  @override
  ConsumerState<InitialFeaturesScreen> createState() =>
      _InitialFeaturesScreenState();
}

class _InitialFeaturesScreenState extends ConsumerState<InitialFeaturesScreen> {
  final List<FeatureEntry> _features = [];

  final _featureNameController = TextEditingController();
  final _featureDescController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final project = ref.read(projectOnboardingProvider);

    if (_features.isEmpty && project.features.isNotEmpty) {
      _features.addAll(project.features);
    }
  }

  @override
  void dispose() {
    _featureNameController.dispose();
    _featureDescController.dispose();
    super.dispose();
  }

  void _addFeature() {
    final featureName = _featureNameController.text.trim();
    final featureDesc = _featureDescController.text.trim();

    if (featureName.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please enter a feature name',
      );
      return;
    }

    if (_features.any(
      (f) => f.name.toLowerCase() == featureName.toLowerCase(),
    )) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Feature "$featureName" already exists',
      );
      return;
    }

    setState(() {
      _features.add(FeatureEntry(name: featureName, description: featureDesc));
      _featureNameController.clear();
      _featureDescController.clear();
    });

    AppSnackBar.show(
      context,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.brandGreen,
      message: 'Feature "$featureName" added',
    );
  }

  void _removeFeature(int index) {
    final featureName = _features[index].name;
    setState(() {
      _features.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feature "$featureName" removed',
          style: GoogleFonts.lato(),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
      ),
    );
  }

  Widget _deleteBackground({required Alignment alignment}) {
    final bool isLeft = alignment == Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: EdgeInsets.only(left: isLeft ? 24 : 0, right: isLeft ? 0 : 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline, color: Colors.white, size: 28),
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

  void _handleNext() {
    ref.read(projectOnboardingProvider.notifier).updateFeatures(_features);
    final isEditing = ref.read(projectOnboardingProvider).isEditMode;

    if (isEditing) {
      ref.read(projectOnboardingProvider.notifier).clearEditMode();
      ref.read(projectOnboardingProvider.notifier).goToStep(6);
    } else {
      ref.read(projectOnboardingProvider.notifier).nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        ref.read(projectOnboardingProvider.notifier).previousStep();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                ref.read(projectOnboardingProvider.notifier).previousStep();
              },
            ),
          ),
          // ✅ REPLACE FROM HERE
          body: SafeArea(
            child: Column(
              children: [
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StepHeader(
                          currentStep: 3,
                          totalSteps: 6,
                          title: 'Initial Feature Ideas',
                        ),

                        const SizedBox(height: 32),

                        Text(
                          'List the features you\'re planning to build.',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Info Card
                        Container(
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
                                  'This section is optional. You can skip or add feature ideas for your project.',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Display Added Features
                        if (_features.isNotEmpty) ...[
                          ..._features.asMap().entries.map((entry) {
                            final index = entry.key;
                            final feature = entry.value;

                            return Dismissible(
                              key: ValueKey(feature.name + index.toString()),
                              direction: DismissDirection.horizontal,
                              background: _deleteBackground(
                                alignment: Alignment.centerLeft,
                              ),
                              secondaryBackground: _deleteBackground(
                                alignment: Alignment.centerRight,
                              ),
                              onDismissed: (_) => _removeFeature(index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
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
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: AppColors.brandGreen
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.lightbulb_outline,
                                            color: AppColors.brandGreen,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feature.name,
                                                style: GoogleFonts.lato(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? AppColors
                                                            .darkTextPrimary
                                                      : AppColors
                                                            .lightTextPrimary,
                                                ),
                                              ),
                                              if (feature
                                                  .description
                                                  .isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  feature.description,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: isDark
                                                        ? AppColors
                                                              .darkTextSecondary
                                                        : AppColors
                                                              .lightTextSecondary,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.drag_handle,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                          size: 20,
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Priority Dropdown
                                    AppDropdown<FeaturePriority>(
                                      label: 'Priority',
                                      icon: Icons.trending_up,
                                      value: feature.priority,
                                      hasError: feature.priorityError,
                                      entries: FeaturePriority.values
                                          .map(
                                            (priority) => DropdownMenuEntry(
                                              value: priority,
                                              label: priority.displayName,
                                            ),
                                          )
                                          .toList(),
                                      onSelected: (value) {
                                        setState(() {
                                          feature.priority = value;
                                          feature.priorityError = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 24),
                        ],

                        // Feature Name Input
                        TextField(
                          controller: _featureNameController,
                          style: GoogleFonts.lato(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          decoration: appInputDecoration(
                            context: context,
                            label: '',
                            hint:
                                'Feature name (e.g., User Authentication, Payment Processing)',
                            isMultiline: true,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Feature Description Input
                        TextField(
                          controller: _featureDescController,
                          maxLines: 3,
                          style: GoogleFonts.lato(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          decoration: appInputDecoration(
                            context: context,
                            label: '',
                            hint: 'Feature description (optional)',
                            isMultiline: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Add Feature Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _addFeature,
                            icon: const Icon(Icons.add),
                            label: Text(
                              'Add Feature',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.brandGreen,
                              side: const BorderSide(
                                color: AppColors.brandGreen,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ✅ FIXED BOTTOM BUTTON
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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
                ),
              ],
            ),
          ),
          // ✅ REPLACE UNTIL HERE
        ),
      ),
    );
  }
}
