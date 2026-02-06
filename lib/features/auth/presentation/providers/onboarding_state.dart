import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/profile/presentation/screens/skills_proficiency_screen2.dart';

class OnboardingState {
  final int step;
  final int? returnStep; // ✅ existing field
  final bool isEditingFromReview; // ✅ ADD THIS NEW FIELD

  // Education fields
  final EducationLevel? educationLevel;
  final CsBackground? csBackground;
  final List<String> coreSubjects;

  // Skills fields
  final List<SkillEntry> skills;

  // Primary Goal fields
  final PrimaryGoal? primaryGoal;
  final Timeline? timeline;

  // Tech Stack fields
  final List<String> techStack;

  // Architecture fields
  final ArchitectureLevel? architectureLevel;
  final List<String> familiarConcepts;

  // Database fields
  final DatabaseType? databaseType;
  final ComfortLevel? databaseComfortLevel;
  final List<String> databasesUsed;

  // Coding Comfort fields
  final CodingFrequency? codingFrequency;
  final DebuggingConfidence? debuggingConfidence;
  final List<String> problemSolvingAreas;

  const OnboardingState({
    this.step = 0,
    this.returnStep,
    this.isEditingFromReview = false, // ✅ ADD THIS
    this.educationLevel,
    this.csBackground,
    this.coreSubjects = const [],
    this.skills = const [],
    this.primaryGoal,
    this.timeline,
    this.techStack = const [],
    this.architectureLevel,
    this.familiarConcepts = const [],
    this.databaseType,
    this.databaseComfortLevel,
    this.databasesUsed = const [],
    this.codingFrequency,
    this.debuggingConfidence,
    this.problemSolvingAreas = const [],
  });

  OnboardingState copyWith({
    int? step,
    int? returnStep,
    bool? isEditingFromReview, // ✅ ADD THIS
    EducationLevel? educationLevel,
    CsBackground? csBackground,
    List<String>? coreSubjects,
    List<SkillEntry>? skills,
    PrimaryGoal? primaryGoal,
    Timeline? timeline,
    List<String>? techStack,
    ArchitectureLevel? architectureLevel,
    List<String>? familiarConcepts,
    DatabaseType? databaseType,
    ComfortLevel? databaseComfortLevel,
    List<String>? databasesUsed,
    CodingFrequency? codingFrequency,
    DebuggingConfidence? debuggingConfidence,
    List<String>? problemSolvingAreas,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      returnStep: returnStep ?? this.returnStep,
      isEditingFromReview: isEditingFromReview ?? this.isEditingFromReview, // ✅ ADD THIS
      educationLevel: educationLevel ?? this.educationLevel,
      csBackground: csBackground ?? this.csBackground,
      coreSubjects: coreSubjects ?? this.coreSubjects,
      skills: skills ?? this.skills,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      timeline: timeline ?? this.timeline,
      techStack: techStack ?? this.techStack,
      architectureLevel: architectureLevel ?? this.architectureLevel,
      familiarConcepts: familiarConcepts ?? this.familiarConcepts,
      databaseType: databaseType ?? this.databaseType,
      databaseComfortLevel: databaseComfortLevel ?? this.databaseComfortLevel,
      databasesUsed: databasesUsed ?? this.databasesUsed,
      codingFrequency: codingFrequency ?? this.codingFrequency,
      debuggingConfidence: debuggingConfidence ?? this.debuggingConfidence,
      problemSolvingAreas: problemSolvingAreas ?? this.problemSolvingAreas,
    );
  }
}
