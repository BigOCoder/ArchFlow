import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen.dart';
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

  final Map<String, String> _frontendMap = {
    'Flutter': 'FLUTTER',
    'React': 'REACT',
    'Angular': 'ANGULAR',
    'Vue': 'VUE',
    'HTML / CSS / JS': 'HTML_CSS_JS',
    'Other': 'OTHER',
  };

  final Map<String, String> _backendMap = {
    'Node.js': 'NODE_JS',
    'Django': 'DJANGO',
    'Spring Boot': 'SPRING_BOOT',
    'Firebase': 'FIREBASE',
    'C#': 'CSHARP',
    'Other': 'OTHER',
  };

  final Map<String, String> _apiKnowledgeMap = {
    'Beginner': 'BEGINNER',
    'Intermediate': 'INTERMEDIATE',
    'Advanced': 'ADVANCED',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);
    final techStack = onboarding.techStack;

    if (techStack.isNotEmpty && _frontend == null) {
      _frontend = _frontendMap.entries
          .firstWhere(
            (e) => e.value == techStack[0],
            orElse: () => MapEntry(techStack[0], techStack[0]),
          )
          .key;

      if (techStack.length > 1) {
        _backend = _backendMap.entries
            .firstWhere(
              (e) => e.value == techStack[1],
              orElse: () => MapEntry(techStack[1], techStack[1]),
            )
            .key;
      }

      if (techStack.length > 2) {
        _apiKnowledge = _apiKnowledgeMap.entries
            .firstWhere(
              (e) => e.value == techStack[2],
              orElse: () => MapEntry(techStack[2], techStack[2]),
            )
            .key;
      }
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

    final techStack = [
      _frontendMap[_frontend!]!,
      _backendMap[_backend!]!,
      _apiKnowledgeMap[_apiKnowledge!]!,
    ];

    final notifier = ref.read(onboardingProvider.notifier);
    notifier.setTechStack(techStack);

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

  Widget _section({
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
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ Fixed - uses theme
          color: Theme.of(context).dividerColor,
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
    // ✅ Fixed - build was broken (missing WillPopScope return + isDark)
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
            'Tech Stack Knowledge',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              // ✅ Fixed - uses theme
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
                currentStep: 4,
                title: 'Experience with various technologies?',
              ),

              const SizedBox(height: 24),

              /// 🖥️ FRONTEND
              _section(
                icon: Icons.desktop_windows,
                title: 'Frontend Technology',
                value: _frontend,
                items: _frontendMap.keys.toList(),
                onChanged: (v) => setState(() => _frontend = v),
              ),

              /// 🧩 BACKEND
              _section(
                icon: Icons.storage,
                title: 'Backend Technology',
                value: _backend,
                items: _backendMap.keys.toList(),
                onChanged: (v) => setState(() => _backend = v),
              ),

              /// 🔌 API KNOWLEDGE
              _section(
                icon: Icons.api,
                title: 'API Knowledge',
                value: _apiKnowledge,
                items: _apiKnowledgeMap.keys.toList(),
                onChanged: (v) => setState(() => _apiKnowledge = v),
              ),

              const SizedBox(height: 32),

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
