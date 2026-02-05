// lib/projectProvider/project_onboarding_state.dart

import 'package:archflow/data/models/app_enums.dart';

class FeatureEntry {
  String name;
  String description;
  FeaturePriority? priority;
  bool priorityError;

  FeatureEntry({
    this.name = '',
    this.description = '',
    this.priority,
    this.priorityError = false,
  });
} // ✅ ADD THIS

class UserRoleEntry {
  String name;
  String description;

  UserRoleEntry({this.name = '', this.description = ''});
} // ✅ ADD THIS

class ProjectOnboardingState {
  final int step;
  final bool isLoading;
  final String? error;
  final bool isEditMode;

  final String projectName;
  final ProjectCategory? category;
  final String description;

  final UserType? primaryUserType;
  final UserScale? userScale;
  final List<UserRoleEntry> userRoles;

  final List<FeatureEntry> features;

  final String problemStatement;
  final String targetAudience;
  final String proposedSolution;

  final List<String> platforms;
  final List<String> supportedDevices;

  final String? expectedTimeline;
  final String? budgetRange;

  final String? expectedTraffic;
  final List<String> dataSensitivity;
  final List<String> complianceNeeds;

  const ProjectOnboardingState({
    this.step = 0,
    this.isLoading = false,
    this.error,
    this.isEditMode = false,
    this.projectName = '',
    this.category,
    this.description = '',
    this.primaryUserType,
    this.userScale,
    this.userRoles = const [],
    this.features = const [],
    this.problemStatement = '',
    this.targetAudience = '',
    this.proposedSolution = '',
    this.platforms = const [],
    this.supportedDevices = const [],
    this.expectedTimeline,
    this.budgetRange,
    this.expectedTraffic,
    this.dataSensitivity = const [],
    this.complianceNeeds = const [],
  });

  ProjectOnboardingState copyWith({
    int? step,
    bool? isLoading,
    Object? error = _undefined,
    String? projectName,
    Object? category = _undefined,
    bool? isEditMode,
    String? description,
    Object? primaryUserType = _undefined,
    Object? userScale = _undefined,
    List<UserRoleEntry>? userRoles,
    List<FeatureEntry>? features,
    String? problemStatement,
    String? targetAudience,
    String? proposedSolution,
    List<String>? platforms,
    List<String>? supportedDevices,
    String? expectedTimeline,
    String? budgetRange,
    String? expectedTraffic,
    List<String>? dataSensitivity,
    List<String>? complianceNeeds,
  }) {
    return ProjectOnboardingState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      isEditMode: isEditMode ?? this.isEditMode,
      projectName: projectName ?? this.projectName,
      category: category == _undefined
          ? this.category
          : category as ProjectCategory?,
      description: description ?? this.description,
      primaryUserType: primaryUserType == _undefined
          ? this.primaryUserType
          : primaryUserType as UserType?,
      userScale: userScale == _undefined
          ? this.userScale
          : userScale as UserScale?,
      userRoles: userRoles ?? this.userRoles,
      features: features ?? this.features,
      problemStatement: problemStatement ?? this.problemStatement,
      targetAudience: targetAudience ?? this.targetAudience,
      proposedSolution: proposedSolution ?? this.proposedSolution,
      platforms: platforms ?? this.platforms,
      supportedDevices: supportedDevices ?? this.supportedDevices,
      expectedTimeline: expectedTimeline ?? this.expectedTimeline,
      budgetRange: budgetRange ?? this.budgetRange,
      expectedTraffic: expectedTraffic ?? this.expectedTraffic,
      dataSensitivity: dataSensitivity ?? this.dataSensitivity,
      complianceNeeds: complianceNeeds ?? this.complianceNeeds,
    );
  }
}

const _undefined = Object();
