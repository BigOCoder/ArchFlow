
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/architecture_exposure_screen5.dart';
import 'package:archflow/features/profile/presentation/screens/coding_comfort_screen7.dart';
import 'package:archflow/features/profile/presentation/screens/database_knowledge_screen6.dart';
import 'package:archflow/features/profile/presentation/screens/education_background_screen1.dart';
import 'package:archflow/features/profile/presentation/screens/primary_goal_screen3.dart';
import 'package:archflow/features/profile/presentation/screens/skills_proficiency_screen2.dart';
import 'package:archflow/features/profile/presentation/screens/tech_stack_knowledge_screen4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(onboardingProvider.select((s) => s.step));

    return Scaffold(
      body: IndexedStack(
        index: step,
        children: const [
          EducationBackgroundScreen(),
          SkillsProficiencyScreen(),
          PrimaryGoalScreen(),
          TechStackKnowledgeScreen(),
          ArchitectureExposureScreen(),
          DatabaseKnowledgeScreen(),
          CodingComfortScreen(),
        ],
      ),
    );
  }
}
