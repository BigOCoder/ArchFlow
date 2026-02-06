
import 'package:archflow/core/constants/app_enums.dart';

class OnboardingDataModel {
  final EducationLevel? educationLevel;
  final CsBackground? csBackground;
  final List<String> coreSubjects;
  final List<SkillEntryModel> skills;
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

  OnboardingDataModel({
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

  Map<String, dynamic> toJson() {
    return {
      if (educationLevel != null) 'educationLevel': educationLevel!.name,
      if (csBackground != null) 'csBackground': csBackground!.name,
      'coreSubjects': coreSubjects,
      'skills': skills.map((s) => s.toJson()).toList(),
      if (primaryGoal != null) 'primaryGoal': primaryGoal!.name,
      if (timeline != null) 'timeline': timeline!.name,
      if (architectureLevel != null) 'architectureLevel': architectureLevel!.name,
      'familiarConcepts': familiarConcepts,
      if (databaseType != null) 'databaseType': databaseType!.name,
      if (databaseComfortLevel != null) 'databaseComfortLevel': databaseComfortLevel!.name,
      'databasesUsed': databasesUsed,
      if (codingFrequency != null) 'codingFrequency': codingFrequency!.name,
      if (debuggingConfidence != null) 'debuggingConfidence': debuggingConfidence!.name,
      'problemSolvingAreas': problemSolvingAreas,
    };
  }

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return OnboardingDataModel(
      educationLevel: json['educationLevel'] != null
          ? _parseEnum(EducationLevel.values, json['educationLevel']) // ✅ FIXED: Safe parsing
          : null,
      csBackground: json['csBackground'] != null
          ? _parseEnum(CsBackground.values, json['csBackground'])
          : null,
      coreSubjects: List<String>.from(json['coreSubjects'] ?? []),
      skills: (json['skills'] as List?)
              ?.map((s) => SkillEntryModel.fromJson(s))
              .toList() ??
          [],
      primaryGoal: json['primaryGoal'] != null
          ? _parseEnum(PrimaryGoal.values, json['primaryGoal'])
          : null,
      timeline: json['timeline'] != null
          ? _parseEnum(Timeline.values, json['timeline'])
          : null,
      architectureLevel: json['architectureLevel'] != null
          ? _parseEnum(ArchitectureLevel.values, json['architectureLevel'])
          : null,
      familiarConcepts: List<String>.from(json['familiarConcepts'] ?? []),
      databaseType: json['databaseType'] != null
          ? _parseEnum(DatabaseType.values, json['databaseType'])
          : null,
      databaseComfortLevel: json['databaseComfortLevel'] != null
          ? _parseEnum(ComfortLevel.values, json['databaseComfortLevel'])
          : null,
      databasesUsed: List<String>.from(json['databasesUsed'] ?? []),
      codingFrequency: json['codingFrequency'] != null
          ? _parseEnum(CodingFrequency.values, json['codingFrequency'])
          : null,
      debuggingConfidence: json['debuggingConfidence'] != null
          ? _parseEnum(DebuggingConfidence.values, json['debuggingConfidence'])
          : null,
      problemSolvingAreas: List<String>.from(json['problemSolvingAreas'] ?? []),
    );
  }

  // ✅ FIXED: Safe enum parsing helper
  static T? _parseEnum<T extends Enum>(List<T> values, String name) {
    try {
      return values.firstWhere((e) => e.name == name);
    } catch (e) {
      return null;
    }
  }
}

class SkillEntryModel {
  final SkillCategory skill;
  final ProficiencyLevel level;

  SkillEntryModel({
    required this.skill,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'skill': skill.name,
      'level': level.name,
    };
  }

  factory SkillEntryModel.fromJson(Map<String, dynamic> json) {
    return SkillEntryModel(
      skill: SkillCategory.values.firstWhere(
        (e) => e.name == json['skill'],
        orElse: () => SkillCategory.other, // ✅ FIXED: Default value
      ),
      level: ProficiencyLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => ProficiencyLevel.beginner, // ✅ FIXED: Default value
      ),
    );
  }
}
