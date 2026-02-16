// lib/screens/project/problem_statement_screen.dart
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/features/project/presentation/screens/project_review_screen.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProblemStatementScreen extends ConsumerStatefulWidget {
  const ProblemStatementScreen({super.key});

  @override
  ConsumerState<ProblemStatementScreen> createState() =>
      _ProblemStatementScreenState();
}

class _ProblemStatementScreenState
    extends ConsumerState<ProblemStatementScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mainProblem = '';
  String _currentSolution = '';
  String _whyInsufficient = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final project = ref.read(projectOnboardingProvider);
    if (_mainProblem.isEmpty && project.problemStatement.isNotEmpty) {
      _mainProblem = project.problemStatement;
      _currentSolution = project.targetAudience;
      _whyInsufficient = project.proposedSolution;
    }
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please describe the main problem',
      );
      return;
    }

    ref
        .read(projectOnboardingProvider.notifier)
        .updateProblemStatement(
          problemStatement: _mainProblem,
          targetAudience: _currentSolution.isEmpty ? '' : _currentSolution,
          proposedSolution: _whyInsufficient.isEmpty ? '' : _whyInsufficient,
        );

    final isEditing = ref.read(projectOnboardingProvider).isEditMode;

    if (isEditing) {
      ref.read(projectOnboardingProvider.notifier).clearEditMode();
      ref.read(projectOnboardingProvider.notifier).goToStep(5);
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepHeader(
                    currentStep: 4,
                    totalSteps: 5,
                    title: 'Problem Statement',
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Describe the real-world problem your project aims to solve.',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    initialValue: _mainProblem,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'Main Problem Statement',
                      hint: 'What problem does your project solve?',
                      isMultiline: true,
                    ),
                    style: GoogleFonts.lato(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 5,
                    onChanged: (v) => _mainProblem = v,
                    validator: (v) => v == null || v.trim().length < 30
                        ? 'Please describe the problem (min 30 characters)'
                        : null,
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    initialValue: _currentSolution,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'Current Solution (Optional)',
                      hint: 'How is this problem currently being solved?',
                      isMultiline: true,
                    ),
                    style: GoogleFonts.lato(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 4,
                    onChanged: (v) => _currentSolution = v,
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    initialValue: _whyInsufficient,
                    decoration: appInputDecoration(
                      context: context,
                      label:
                          'Why Existing Solutions Are Insufficient (Optional)',
                      hint: 'What gaps exist in current solutions?',
                      isMultiline: true,
                    ),
                    style: GoogleFonts.lato(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    maxLines: 4,
                    onChanged: (v) => _whyInsufficient = v,
                  ),

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
      ),
    );
  }
}
