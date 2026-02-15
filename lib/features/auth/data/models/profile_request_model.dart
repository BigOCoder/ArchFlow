// lib/features/auth/data/models/profile_request_model.dart

class ProfileRequestModel {
  final String education;
  final String background;
  final List<String> coreSubjects;
  final List<SkillModel> skills;
  final String primaryGoal;
  final String timeline;
  final String? frontendTechnology;
  final String? backendTechnology;
  final String? apiKnowledge;
  final String? architectureExperience;
  final List<String> familiarConcepts;
  final DatabaseKnowledgeModel databaseKnowledge;
  final String codingFrequency;
  final String debuggingConfidence;
  final String problemSolvingArea;

  ProfileRequestModel({
    required this.education,
    required this.background,
    required this.coreSubjects,
    required this.skills,
    required this.primaryGoal,
    required this.timeline,
    this.frontendTechnology,
    this.backendTechnology,
    this.apiKnowledge,
    this.architectureExperience,
    required this.familiarConcepts,
    required this.databaseKnowledge,
    required this.codingFrequency,
    required this.debuggingConfidence,
    required this.problemSolvingArea,
  });

  Map<String, dynamic> toJson() {
    return {
      'education': education,
      'background': background,
      'coreSubjects': coreSubjects,
      'skills': skills.map((s) => s.toJson()).toList(),
      'primaryGoal': primaryGoal,
      'timeline': timeline,
      if (frontendTechnology != null) 'frontendTechnology': frontendTechnology,
      if (backendTechnology != null) 'backendTechnology': backendTechnology,
      if (apiKnowledge != null) 'apiKnowledge': apiKnowledge,
      if (architectureExperience != null) 'architectureExperience': architectureExperience,
      'familiarConcepts': familiarConcepts,
      'databaseKnowledge': databaseKnowledge.toJson(),
      'codingFrequency': codingFrequency,
      'debuggingConfidence': debuggingConfidence,
      'problemSolvingArea': problemSolvingArea,
    };
  }
}

class SkillModel {
  final String skill;
  final String level;

  SkillModel({
    required this.skill,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'skill': skill,
      'level': level,
    };
  }
}

class DatabaseKnowledgeModel {
  final String databaseType;
  final String comfortLevel;
  final List<String> databasesKnown;

  DatabaseKnowledgeModel({
    required this.databaseType,
    required this.comfortLevel,
    required this.databasesKnown,
  });

  Map<String, dynamic> toJson() {
    return {
      'databaseType': databaseType,
      'comfortLevel': comfortLevel,
      'databasesKnown': databasesKnown,
    };
  }
}
