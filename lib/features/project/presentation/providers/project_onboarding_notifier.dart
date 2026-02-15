// lib/features/project/presentation/providers/project_onboarding_notifier.dart
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectOnboardingNotifier extends Notifier<ProjectOnboardingState> {
  @override
  ProjectOnboardingState build() {
    return const ProjectOnboardingState();
  }

  void nextStep() {
    if (state.isEditMode) {
      // Exit edit mode and go to review screen (step 6)
      state = state.copyWith(step: 6, isEditMode: false);
    } else {
      // Normal flow - increment but don't exceed step 6
      if (state.step < 6) {
        state = state.copyWith(step: state.step + 1);
      }
    }
  }

  void previousStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  // ✅ FIXED: Add editMode parameter
  void goToStep(int step, {bool editMode = false}) {
    if (step >= 0 && step <= 6) {
      state = state.copyWith(
        step: step,
        isEditMode: editMode, // ✅ Use parameter instead of hardcoding
      );
    }
  }

  // ✅ NEW: Add clearEditMode method
  void clearEditMode() {
    state = state.copyWith(isEditMode: false);
  }

  /// Update Project Basics
  void updateProjectBasics({
    required String projectName,
    required ProjectCategory category,
    required String description,
  }) {
    state = state.copyWith(
      projectName: projectName,
      category: category,
      description: description,
    );
  }

  /// Update Target Users
  void updateTargetUsers({
    required UserType primaryUserType,
    required UserScale userScale,
    required List<UserRoleEntry> userRoles,
  }) {
    state = state.copyWith(
      primaryUserType: primaryUserType,
      userScale: userScale,
      userRoles: userRoles,
    );
  }

  /// Update Initial Features
  void updateFeatures(List<FeatureEntry> features) {
    state = state.copyWith(features: features);
  }

  /// Update Problem Statement
  void updateProblemStatement({
    required String problemStatement,
    required String targetAudience,
    required String proposedSolution,
  }) {
    state = state.copyWith(
      problemStatement: problemStatement,
      targetAudience: targetAudience,
      proposedSolution: proposedSolution,
    );
  }

  void updateProjectDetails({
    required List<String> platforms,
    required List<String> supportedDevices,
    String? expectedTimeline,
    String? budgetRange,
    String? expectedTraffic,
    required List<String> dataSensitivity,
    required List<String> complianceNeeds,
  }) {
    state = state.copyWith(
      platforms: platforms,
      supportedDevices: supportedDevices,
      expectedTimeline: expectedTimeline,
      budgetRange: budgetRange,
      expectedTraffic: expectedTraffic,
      dataSensitivity: dataSensitivity,
      complianceNeeds: complianceNeeds,
    );
  }

  void reset() {
    state = const ProjectOnboardingState();
  }
}

// Provider
final projectOnboardingProvider =
    NotifierProvider<ProjectOnboardingNotifier, ProjectOnboardingState>(
  ProjectOnboardingNotifier.new,
);
