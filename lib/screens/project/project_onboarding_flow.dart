// lib/screens/project/project_onboarding_flow.dart
import 'package:archflow/provider/projectProvider/project_onboarding_notifier.dart';
import 'package:archflow/screens/project/project_details_screen5.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archflow/screens/project/project_basics_screen1.dart';
import 'package:archflow/screens/project/target_users_screen2.dart';
import 'package:archflow/screens/project/initial_features_screen3.dart';
import 'package:archflow/screens/project/problem_statement_screen4.dart';
import 'package:archflow/screens/project/project_review_screen6.dart';

class ProjectOnboardingFlow extends ConsumerWidget {
  const ProjectOnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(projectOnboardingProvider.select((s) => s.step));

    return Scaffold(
      body: IndexedStack(
        index: step,
        children: const [
          ProjectBasicsScreen(), // Step 0
          TargetUsersScreen(), // Step 1
          InitialFeaturesScreen(), // Step 2
          ProblemStatementScreen(), // Step 3
          ProjectDetailsScreen(), // Step 4
          ProjectReviewScreen(), // Step 5
        ],
      ),
    );
  }
}
