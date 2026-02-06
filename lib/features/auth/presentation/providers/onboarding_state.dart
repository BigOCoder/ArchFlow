import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/auth/data/models/onboarding_data_model.dart';
import 'package:archflow/features/profile/presentation/screens/skills_proficiency_screen2.dart';

class OnboardingState {
  final int step;
  final int? returnStep;
  final bool isLoading;
  final String? error;

  final EducationLevel? educationLevel;
  final CsBackground? csBackground;
  final List<String> coreSubjects;
  final List<SkillEntry> skills;
  final PrimaryGoal? primaryGoal;
  final Timeline? timeline;
  final ArchitectureLevel? architectureLevel;
  final List<String> familiarConcepts;
  final DatabaseType? databaseType;
  final ComfortLevel? databaseComfortLevel;
  final List<String> databasesUsed;
  final CodingFrequency? codingFrequency;
  final DebuggingConfidence? debuggingConfidence;
  final List<String> problemSolvingAreas;

  const OnboardingState({
    this.step = 0,
    this.returnStep,
    this.isLoading = false,
    this.error,
    this.educationLevel,
    this.csBackground,
    this.coreSubjects = const [],
    this.skills = const [],
    this.primaryGoal,
    this.timeline,
    this.architectureLevel,
    this.familiarConcepts = const [],
    this.databaseType,
    this.databaseComfortLevel,
    this.databasesUsed = const [],
    this.codingFrequency,
    this.debuggingConfidence,
    this.problemSolvingAreas = const [],
  });

  // ✅ FIXED: Proper nullable handling
  OnboardingState copyWith({
    int? step,
    Object? returnStep = _undefined,
    bool? isLoading,
    Object? error = _undefined,
    Object? educationLevel = _undefined,
    Object? csBackground = _undefined,
    List<String>? coreSubjects,
    List<SkillEntry>? skills,
    Object? primaryGoal = _undefined,
    Object? timeline = _undefined,
    Object? architectureLevel = _undefined,
    List<String>? familiarConcepts,
    Object? databaseType = _undefined,
    Object? databaseComfortLevel = _undefined,
    List<String>? databasesUsed,
    Object? codingFrequency = _undefined,
    Object? debuggingConfidence = _undefined,
    List<String>? problemSolvingAreas,

  }) {
    return OnboardingState(
      step: step ?? this.step,
      returnStep: returnStep == _undefined
          ? this.returnStep
          : returnStep as int?,
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      educationLevel: educationLevel == _undefined
          ? this.educationLevel
          : educationLevel as EducationLevel?,
      csBackground: csBackground == _undefined
          ? this.csBackground
          : csBackground as CsBackground?,
      coreSubjects: coreSubjects ?? this.coreSubjects,
      skills: skills ?? this.skills,
      primaryGoal: primaryGoal == _undefined
          ? this.primaryGoal
          : primaryGoal as PrimaryGoal?,
      timeline: timeline == _undefined ? this.timeline : timeline as Timeline?,
      architectureLevel: architectureLevel == _undefined
          ? this.architectureLevel
          : architectureLevel as ArchitectureLevel?,
      familiarConcepts: familiarConcepts ?? this.familiarConcepts,
      databaseType: databaseType == _undefined
          ? this.databaseType
          : databaseType as DatabaseType?,
      databaseComfortLevel: databaseComfortLevel == _undefined
          ? this.databaseComfortLevel
          : databaseComfortLevel as ComfortLevel?,
      databasesUsed: databasesUsed ?? this.databasesUsed,
      codingFrequency: codingFrequency == _undefined
          ? this.codingFrequency
          : codingFrequency as CodingFrequency?,
      debuggingConfidence: debuggingConfidence == _undefined
          ? this.debuggingConfidence
          : debuggingConfidence as DebuggingConfidence?,
      problemSolvingAreas: problemSolvingAreas ?? this.problemSolvingAreas,
    );
  }

  OnboardingDataModel toOnboardingDataModel() {
    return OnboardingDataModel(
      educationLevel: educationLevel,
      csBackground: csBackground,
      coreSubjects: coreSubjects,
      skills: skills
          .where((s) => s.skill != null && s.level != null)
          .map((s) => SkillEntryModel(skill: s.skill!, level: s.level!))
          .toList(),
      primaryGoal: primaryGoal,
      timeline: timeline,
      architectureLevel: architectureLevel,
      familiarConcepts: familiarConcepts,
      databaseType: databaseType,
      databaseComfortLevel: databaseComfortLevel,
      databasesUsed: databasesUsed,
      codingFrequency: codingFrequency,
      debuggingConfidence: debuggingConfidence,
      problemSolvingAreas: problemSolvingAreas,
    );
  }
}

// ✅ Sentinel value
const _undefined = Object();
