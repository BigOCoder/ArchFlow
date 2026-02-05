// lib/provider/project_onboarding_notifier.dart
import 'package:archflow/provider/projectProvider/project_onboarding_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archflow/data/models/app_enums.dart';

class ProjectOnboardingNotifier extends Notifier<ProjectOnboardingState> {
  @override
  ProjectOnboardingState build() {
    return const ProjectOnboardingState();
  }

  void nextStep() {
    if (state.isEditMode) {
      state = state.copyWith(step: 5, isEditMode: false);
    } else {
      // Normal flow - just increment
      state = state.copyWith(step: state.step + 1);
    }
  }

  void previousStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(
      step: step,
      isEditMode: true, // Enable edit mode
    );
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
