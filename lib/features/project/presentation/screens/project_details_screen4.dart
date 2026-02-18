import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetailsScreen extends ConsumerStatefulWidget {
  const ProjectDetailsScreen({super.key});

  @override
  ConsumerState<ProjectDetailsScreen> createState() =>
      _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends ConsumerState<ProjectDetailsScreen> {
  final Set<String> _selectedPlatforms = {};
  final Set<String> _selectedDevices = {};

  ExpectedTimeline? _selectedTimeline;
  BudgetRange? _selectedBudget;

  ExpectedTraffic? _selectedTraffic;
  final Set<String> _selectedDataSensitivity = {};
  final Set<String> _selectedCompliance = {};

  final List<String> platforms = [
    'Web application',
    'Mobile application',
    'Backend / API only',
    'Desktop application',
  ];

  final List<String> devices = ['Desktop', 'Tablet', 'Mobile'];

  final List<String> dataSensitivityOptions = [
    'Personal user data',
    'Financial data',
    'Health data',
    'No sensitive data',
  ];

  final List<String> complianceOptions = ['GDPR', 'HIPAA', 'PCI-DSS', 'None'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final project = ref.read(projectOnboardingProvider);

    if (_selectedPlatforms.isEmpty && project.platforms.isNotEmpty) {
      _selectedPlatforms.addAll(project.platforms);
      _selectedDevices.addAll(project.supportedDevices);
      _selectedDataSensitivity.addAll(project.dataSensitivity);
      _selectedCompliance.addAll(project.complianceNeeds);
    }
  }

  void _handleNext() {
    if (_selectedPlatforms.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one platform',
      );
      return;
    }

    if (_selectedDevices.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one supported device',
      );
      return;
    }

    if (_selectedTimeline == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select expected timeline',
      );
      return;
    }

    if (_selectedBudget == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select budget range',
      );
      return;
    }

    if (_selectedTraffic == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select expected traffic',
      );
      return;
    }

    if (_selectedDataSensitivity.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one data sensitivity option',
      );
      return;
    }

    ref.read(projectOnboardingProvider.notifier).updateProjectDetails(
          platforms: _selectedPlatforms.toList(),
          supportedDevices: _selectedDevices.toList(),
          expectedTimeline: _selectedTimeline?.displayName,
          budgetRange: _selectedBudget?.displayName,
          expectedTraffic: _selectedTraffic?.displayName,
          dataSensitivity: _selectedDataSensitivity.toList(),
          complianceNeeds: _selectedCompliance.toList(),
        );

    final isEditing = ref.read(projectOnboardingProvider).isEditMode;

    if (isEditing) {
      ref.read(projectOnboardingProvider.notifier).clearEditMode();
      ref.read(projectOnboardingProvider.notifier).goToStep(5);
    } else {
      ref.read(projectOnboardingProvider.notifier).nextStep();
    }
  }

  // ✅ Extracted reusable section divider
  Widget _sectionDivider(String label) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            // ✅ Fixed - uses theme
            color: Theme.of(context).dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              // ✅ Fixed - uses theme
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            // ✅ Fixed - uses theme
            color: Theme.of(context).dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // ✅ Extracted reusable checkbox list
  Widget _checkboxGroup(List<String> options, Set<String> selected) {
    return Column(
      children: options.map((option) {
        return CheckboxListTile(
          value: selected.contains(option),
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                selected.add(option);
              } else {
                selected.remove(option);
              }
            });
          },
          title: Text(
            option,
            style: GoogleFonts.lato(
              fontSize: 14,
              // ✅ Fixed - uses theme
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          activeColor: AppColors.brandGreen,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }

  // ✅ Extracted reusable section label
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  // ✅ Extracted reusable section subtitle
  Widget _sectionSubtitle(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 12,
          // ✅ Fixed - uses theme
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(projectOnboardingProvider.notifier).previousStep();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          // ✅ Removed backgroundColor - uses theme
          appBar: AppBar(
            // ✅ Removed backgroundColor & elevation - uses theme
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              // ✅ Removed color - uses theme iconTheme
              onPressed: () {
                ref.read(projectOnboardingProvider.notifier).previousStep();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(
                  currentStep: 5,
                  totalSteps: 5,
                  title: 'Project Details',
                ),
                const SizedBox(height: 24),

                // ✅ Uses extracted _sectionSubtitle
                _sectionSubtitle(
                  'Provide technical and planning details for your project.',
                ),
                const SizedBox(height: 32),

                // ━━━ SECTION 1: Platform Selection ━━━
                _sectionDivider('Platform Selection'),
                const SizedBox(height: 8),
                _sectionSubtitle('Choose the platforms for your application'),
                const SizedBox(height: 32),

                _sectionLabel('Platforms'),
                const SizedBox(height: 8),
                // ✅ Uses extracted _checkboxGroup
                _checkboxGroup(platforms, _selectedPlatforms),

                const SizedBox(height: 16),

                _sectionLabel('Supported Devices'),
                const SizedBox(height: 8),
                _checkboxGroup(devices, _selectedDevices),

                // ━━━ SECTION 2: Timeline & Budget ━━━
                const SizedBox(height: 32),
                _sectionDivider('Timeline & Budget'),
                const SizedBox(height: 8),
                _sectionSubtitle('Define your project timeframe and budget'),
                const SizedBox(height: 32),

                AppDropdown<ExpectedTimeline>(
                  label: 'Expected Timeline',
                  icon: Icons.schedule,
                  value: _selectedTimeline,
                  hasError: false,
                  entries: ExpectedTimeline.values
                      .map((timeline) => DropdownMenuEntry(
                            value: timeline,
                            label: timeline.displayName,
                          ))
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedTimeline = value);
                  },
                ),

                const SizedBox(height: 16),

                AppDropdown<BudgetRange>(
                  label: 'Budget Range',
                  icon: Icons.attach_money,
                  value: _selectedBudget,
                  hasError: false,
                  entries: BudgetRange.values
                      .map((budget) => DropdownMenuEntry(
                            value: budget,
                            label: budget.displayName,
                          ))
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedBudget = value);
                  },
                ),

                // ━━━ SECTION 3: Scale & Data Sensitivity ━━━
                const SizedBox(height: 32),
                _sectionDivider('Scale & Data Sensitivity'),
                const SizedBox(height: 8),
                _sectionSubtitle(
                    'Specify performance and security requirements'),
                const SizedBox(height: 32),

                AppDropdown<ExpectedTraffic>(
                  label: 'Expected Traffic',
                  icon: Icons.trending_up,
                  value: _selectedTraffic,
                  hasError: false,
                  entries: ExpectedTraffic.values
                      .map((traffic) => DropdownMenuEntry(
                            value: traffic,
                            label: traffic.displayName,
                          ))
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedTraffic = value);
                  },
                ),

                const SizedBox(height: 32),

                _sectionLabel('Data Sensitivity'),
                const SizedBox(height: 8),
                _checkboxGroup(dataSensitivityOptions, _selectedDataSensitivity),

                const SizedBox(height: 16),

                _sectionLabel('Compliance Needs (Optional)'),
                const SizedBox(height: 8),
                _checkboxGroup(complianceOptions, _selectedCompliance),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleNext,
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
      ),
    );
  }
}
