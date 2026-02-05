import 'package:archflow/provider/authProvider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:archflow/screens/profile/education_background_screen1.dart';
import 'package:archflow/screens/profile/skills_proficiency_screen2.dart';
import 'package:archflow/screens/profile/primary_goal_screen3.dart';
import 'package:archflow/screens/profile/tech_stack_knowledge_screen4.dart';
import 'package:archflow/screens/profile/architecture_exposure_screen5.dart';
import 'package:archflow/screens/profile/database_knowledge_screen6.dart';
import 'package:archflow/screens/profile/coding_comfort_screen7.dart';
import 'package:archflow/screens/profile/final_review_screen8.dart';
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
          FinalReviewScreen(),
        ],
      ),
    );
  }
}
