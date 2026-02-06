import 'package:archflow/features/chat/presentation/screens/ai_chat_screen.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/features/project/presentation/screens/initial_features_screen3.dart';
import 'package:archflow/features/project/presentation/screens/problem_statement_screen4.dart';
import 'package:archflow/features/project/presentation/screens/project_basics_screen1.dart';
import 'package:archflow/features/project/presentation/screens/project_details_screen5.dart';
import 'package:archflow/features/project/presentation/screens/project_review_screen6.dart';
import 'package:archflow/features/project/presentation/screens/target_users_screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectOnboardingFlow extends ConsumerWidget {
  const ProjectOnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(projectOnboardingProvider.select((s) => s.step));

    return Scaffold(
      body: IndexedStack(
        index: step,
        children: const [
          ProjectBasicsScreen(),       // Step 0
          TargetUsersScreen(),          // Step 1
          InitialFeaturesScreen(),      // Step 2
          ProblemStatementScreen(),     // Step 3
          ProjectDetailsScreen(),       // Step 4
          AIChatScreen(),               // Step 5
          ProjectReviewScreen(),        // Step 6
        ],
      ),
    );
  }
}
