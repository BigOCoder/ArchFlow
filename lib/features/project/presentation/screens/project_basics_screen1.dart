// lib/screens/project/project_basics_screen.dart
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/shared/widgets/app_color.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectBasicsScreen extends ConsumerStatefulWidget {
  const ProjectBasicsScreen({super.key});

  @override
  ConsumerState<ProjectBasicsScreen> createState() =>
      _ProjectBasicsScreenState();
}

class _ProjectBasicsScreenState extends ConsumerState<ProjectBasicsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _projectName = '';
  String _projectSummary = '';
  ProjectCategory? _projectCategory;

  List<ProjectCategory> get availableCategories => ProjectCategory.values;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load saved data if available
    final project = ref.read(projectOnboardingProvider);
    if (_projectName.isEmpty && project.projectName.isNotEmpty) {
      _projectName = project.projectName;
      _projectSummary = project.description;
      _projectCategory = project.category;
    }
  }

  void _next() {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please fill all required fields',
      );
      return;
    }

    if (_projectCategory == null) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select a project category',
      );
      return;
    }

    ref
        .read(projectOnboardingProvider.notifier)
        .updateProjectBasics(
          projectName: _projectName,
          category: _projectCategory!,
          description: _projectSummary,
        );

    ref.read(projectOnboardingProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Go back to previous step or exit if it's the first step
        if (ref.read(projectOnboardingProvider).step >= 0) {
          ref.read(projectOnboardingProvider.notifier).previousStep();
          return false; // Prevent default pop
        }
        return true; // Allow exit if on first step
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepHeader(
                    currentStep: 1,
                    totalSteps: 5,
                    title: 'Project Basics',
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Start with the essentials for your project.',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Project Name
                  TextFormField(
                    initialValue: _projectName,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'Project Name',
                      hint: 'e.g., Social Media App, E-commerce Platform',
                      icon: Icons.business_center,
                    ),
                    style: GoogleFonts.lato(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    onChanged: (v) => _projectName = v,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Project name is required'
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // Project Category
                  AppDropdown<ProjectCategory>(
                    label: 'Project Category',
                    icon: Icons.category,
                    value: _projectCategory,
                    hasError: false,
                    entries: availableCategories
                        .map(
                          (category) => DropdownMenuEntry(
                            value: category,
                            label: category.displayName,
                          ),
                        )
                        .toList(),
                    onSelected: (v) {
                      setState(() {
                        _projectCategory = v;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // ✅ UPDATED: Short Project Summary (using appInputDecoration)
                  TextFormField(
                    initialValue: _projectSummary,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'Short Project Summary',
                      hint: 'Brief overview of your project (2-3 lines)',
                      isMultiline: true,
                    ),
                    style: GoogleFonts.lato(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 4,
                    onChanged: (v) => _projectSummary = v,
                    validator: (v) => v == null || v.trim().length < 20
                        ? 'Please provide a brief summary (min 20 characters)'
                        : null,
                  ),

                  const SizedBox(height: 48),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _next,
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
      ),
    );
  }
}
