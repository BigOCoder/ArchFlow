import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/dashboard/presentation/screens/dashboard_screen.dart';
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
  // Platform Selection
  final Set<String> _selectedPlatforms = {};
  final Set<String> _selectedDevices = {};

  // Timeline & Budget
  ProjectTimeline? _selectedTimeline;
  BudgetRange? _selectedBudget;

  // Scale & Data
  ExpectedTraffic? _selectedTraffic;
  final Set<String> _selectedDataSensitivity = {};
  final Set<String> _selectedCompliance = {};

  // Available options
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

    // Load saved data if available
    if (_selectedPlatforms.isEmpty && project.platforms.isNotEmpty) {
      _selectedPlatforms.addAll(project.platforms);
      _selectedDevices.addAll(project.supportedDevices);
      _selectedDataSensitivity.addAll(project.dataSensitivity);
      _selectedCompliance.addAll(project.complianceNeeds);
    }
  }

  void _handleNext() {
    // Validate at least one platform is selected
    if (_selectedPlatforms.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one platform',
      );
      return;
    }

    // Validate at least one device is selected
    if (_selectedDevices.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one supported device',
      );
      return;
    }

    // Validate timeline is selected
    if (_selectedTimeline == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select expected timeline',
      );
      return;
    }

    // Validate budget range is selected
    if (_selectedBudget == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select budget range',
      );
      return;
    }

    // Validate expected traffic is selected
    if (_selectedTraffic == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select expected traffic',
      );
      return;
    }

    // Validate at least one data sensitivity option is selected
    if (_selectedDataSensitivity.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select at least one data sensitivity option',
      );
      return;
    }

    // Compliance is OPTIONAL - no validation needed

    // Save to provider
    ref
        .read(projectOnboardingProvider.notifier)
        .updateProjectDetails(
          platforms: _selectedPlatforms.toList(),
          supportedDevices: _selectedDevices.toList(),
          expectedTimeline: _selectedTimeline?.displayName,
          budgetRange: _selectedBudget?.displayName,
          expectedTraffic: _selectedTraffic?.displayName,
          dataSensitivity: _selectedDataSensitivity.toList(),
          complianceNeeds: _selectedCompliance.toList(),
        );

    ref.read(projectOnboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Reset and go to dashboard
        ref.read(projectOnboardingProvider.notifier).reset();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (_) => false,
          );
        }

        return false; // Prevent default pop behavior
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
                // Reset and go to dashboard
                ref.read(projectOnboardingProvider.notifier).reset();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (_) => false,
                );
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
                  totalSteps: 6,
                  title: 'Project Details',
                ),
                const SizedBox(height: 24),

                Center(
                  child: Text(
                    'Provide technical and planning details for your project.',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                // SECTION 1: Platform Selection

                // Optional Section Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Platform Selection',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                Center(
                  child: Text(
                    'Choose the platforms for your application',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Platforms Checkboxes
                Text(
                  'Platforms',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),

                const SizedBox(height: 8),
                ...platforms.map((platform) {
                  return CheckboxListTile(
                    value: _selectedPlatforms.contains(platform),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedPlatforms.add(platform);
                        } else {
                          _selectedPlatforms.remove(platform);
                        }
                      });
                    },
                    title: Text(
                      platform,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    activeColor: AppColors.brandGreen,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),

                const SizedBox(height: 16),

                // Supported Devices
                Text(
                  'Supported Devices',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...devices.map((device) {
                  return CheckboxListTile(
                    value: _selectedDevices.contains(device),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedDevices.add(device);
                        } else {
                          _selectedDevices.remove(device);
                        }
                      });
                    },
                    title: Text(
                      device,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    activeColor: AppColors.brandGreen,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),

                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                // SECTION 2: Timeline & Budget
                const SizedBox(height: 32),

                // Optional Section Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Timeline & Budget',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                Center(
                  child: Text(
                    'Define your project timeframe and budget',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Expected Timeline
                AppDropdown<ProjectTimeline>(
                  label: 'Expected Timeline',
                  icon: Icons.schedule,
                  value: _selectedTimeline,
                  hasError: false,
                  entries: ProjectTimeline.values
                      .map(
                        (timeline) => DropdownMenuEntry(
                          value: timeline,
                          label: timeline.displayName,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedTimeline = value);
                  },
                ),

                const SizedBox(height: 16),

                // Budget Range
                AppDropdown<BudgetRange>(
                  label: 'Budget Range',
                  icon: Icons.attach_money,
                  value: _selectedBudget,
                  hasError: false,
                  entries: BudgetRange.values
                      .map(
                        (budget) => DropdownMenuEntry(
                          value: budget,
                          label: budget.displayName,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedBudget = value);
                  },
                ),

                const SizedBox(height: 32),

                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                // SECTION 3: Scale & Data Sensitivity
                const SizedBox(height: 32),

                // Optional Section Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Scale & Data Sensitivity',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                Center(
                  child: Text(
                    'Specify performance and security requirements',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Expected Traffic
                AppDropdown<ExpectedTraffic>(
                  label: 'Expected Traffic',
                  icon: Icons.trending_up,
                  value: _selectedTraffic,
                  hasError: false,
                  entries: ExpectedTraffic.values
                      .map(
                        (traffic) => DropdownMenuEntry(
                          value: traffic,
                          label: traffic.displayName,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    setState(() => _selectedTraffic = value);
                  },
                ),

                const SizedBox(height: 32),

                // Data Sensitivity
                Text(
                  'Data Sensitivity',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...dataSensitivityOptions.map((option) {
                  return CheckboxListTile(
                    value: _selectedDataSensitivity.contains(option),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedDataSensitivity.add(option);
                        } else {
                          _selectedDataSensitivity.remove(option);
                        }
                      });
                    },
                    title: Text(
                      option,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    activeColor: AppColors.brandGreen,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),

                const SizedBox(height: 16),

                // Compliance Needs
                Text(
                  'Compliance Needs (Optional)',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...complianceOptions.map((option) {
                  return CheckboxListTile(
                    value: _selectedCompliance.contains(option),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedCompliance.add(option);
                        } else {
                          _selectedCompliance.remove(option);
                        }
                      });
                    },
                    title: Text(
                      option,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    activeColor: AppColors.brandGreen,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),

                const SizedBox(height: 48),

                // Next Button
                SizedBox(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
