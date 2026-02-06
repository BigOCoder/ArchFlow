
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
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

    debugPrint('Frontend: $_frontend');
    debugPrint('Backend: $_backend');
    debugPrint('API Knowledge: $_apiKnowledge');

    ref.read(onboardingProvider.notifier).nextStep();
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
      child: AppDropdown<String>(
        label: title,
        icon: icon,
        value: value,
        hasError: false,
        entries: items
            .map(
              (e) => DropdownMenuEntry<String>(
                value: e,
                label: e,
              ),
            )
            .toList(),
        onSelected: onChanged,
      ),
    );
  }

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
              currentStep: 4,
              title: 'Tech Stack Knowledge',
            ),

            const SizedBox(height: 24),

            Text(
              'Tell us about your experience with various technologies.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 32),

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
              items: const [
                'Beginner',
                'Intermediate',
                'Advanced',
              ],
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
    );
  }
}
