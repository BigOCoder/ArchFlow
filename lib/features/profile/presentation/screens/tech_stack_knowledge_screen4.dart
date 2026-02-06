import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen8.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TechStackKnowledgeScreen extends ConsumerStatefulWidget {
  const TechStackKnowledgeScreen({super.key});

  @override
  ConsumerState<TechStackKnowledgeScreen> createState() =>
      _TechStackKnowledgeScreenState();
}

class _TechStackKnowledgeScreenState
    extends ConsumerState<TechStackKnowledgeScreen> {
  String? _frontend;
  String? _backend;
  String? _apiKnowledge;

  /// ---------------- STATE RESTORE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);
    final techStack = onboarding.techStack;

    // Restore saved values if they exist
    if (techStack.isNotEmpty && _frontend == null) {
      _frontend = techStack.length > 0 ? techStack[0] : null;
      _backend = techStack.length > 1 ? techStack[1] : null;
      _apiKnowledge = techStack.length > 2 ? techStack[2] : null;
    }
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

  bool get _canProceed =>
      _frontend != null && _backend != null && _apiKnowledge != null;

  void _submit() {
    if (!_canProceed) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please select all tech stack options',
      );
      return;
    }

    // Save tech stack as a list
    final techStack = [_frontend!, _backend!, _apiKnowledge!];
    
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setTechStack(techStack);

    // ✅ NEW: Check if we're editing from Final Review
    final isEditing = ref.read(onboardingProvider).isEditingFromReview;

    if (isEditing) {
      // Return to Final Review
      notifier.clearEditMode();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    } else {
      // Normal flow: go to next step
      notifier.nextStep();
    }
  }

  Widget _section({
    required bool isDark,
    required IconData icon,
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: AppDropdown<String>(
        label: title,
        icon: icon,
        value: value,
        hasError: false,
        entries: items
            .map((e) => DropdownMenuEntry<String>(value: e, label: e))
            .toList(),
        onSelected: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        _handleBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackPressed,
          ),
          title: Text(
            'Tech Stack Knowledge',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                currentStep: 4,
                title: 'Experience with various technologies?',
              ),

              const SizedBox(height: 24),

              /// 🌐 FRONTEND
              _section(
                isDark: isDark,
                icon: Icons.desktop_windows,
                title: 'Frontend Technology',
                value: _frontend,
                items: const [
                  'Flutter',
                  'React',
                  'Angular',
                  'Vue',
                  'HTML / CSS / JS',
                  'Other',
                ],
                onChanged: (v) => setState(() => _frontend = v),
              ),

              /// 🧩 BACKEND
              _section(
                isDark: isDark,
                icon: Icons.storage,
                title: 'Backend Technology',
                value: _backend,
                items: const [
                  'Node.js',
                  'Django',
                  'Spring Boot',
                  'Firebase',
                  'C#',
                  'Other',
                ],
                onChanged: (v) => setState(() => _backend = v),
              ),

              /// 🔌 API KNOWLEDGE
              _section(
                isDark: isDark,
                icon: Icons.api,
                title: 'API Knowledge',
                value: _apiKnowledge,
                items: const ['Beginner', 'Intermediate', 'Advanced'],
                onChanged: (v) => setState(() => _apiKnowledge = v),
              ),

              const SizedBox(height: 32),

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
      ),
    );
  }
}
