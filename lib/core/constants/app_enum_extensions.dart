// lib/core/constants/app_enum_extensions.dart
// Contains all extension methods for enums

import 'package:flutter/material.dart';
import 'app_enums.dart';

// ==================== DISPLAY NAME EXTENSIONS ====================

extension SkillCategoryExtension on SkillCategory {
  String get displayName {
    switch (this) {
      case SkillCategory.webDevelopment:
        return 'Web Development';
      case SkillCategory.androidDevelopment:
        return 'Android Development';
      case SkillCategory.backendDevelopment:
        return 'Backend Development';
      case SkillCategory.dsa:
        return 'Data Structures & Algorithms';
      case SkillCategory.other:
        return 'Other';
    }
  }

  String get backendValue {
    switch (this) {
      case SkillCategory.webDevelopment:
        return 'WEB_DEVELOPMENT';
      case SkillCategory.androidDevelopment:
        return 'ANDROID_DEVELOPMENT';
      case SkillCategory.backendDevelopment:
        return 'BACKEND_DEVELOPMENT';
      case SkillCategory.dsa:
        return 'DSA';
      case SkillCategory.other:
        return 'OTHER';
    }
  }
}

extension ProficiencyLevelExtension on ProficiencyLevel {
  String get displayName {
    switch (this) {
      case ProficiencyLevel.beginner:
        return 'Beginner';
      case ProficiencyLevel.intermediate:
        return 'Intermediate';
      case ProficiencyLevel.advanced:
        return 'Advanced';
    }
  }

  String get backendValue {
    switch (this) {
      case ProficiencyLevel.beginner:
        return 'BEGINNER';
      case ProficiencyLevel.intermediate:
        return 'INTERMEDIATE';
      case ProficiencyLevel.advanced:
        return 'ADVANCED';
    }
  }
}

extension EducationLevelExtension on EducationLevel {
  String get displayName {
    switch (this) {
      case EducationLevel.diploma:
        return 'Diploma';
      case EducationLevel.undergraduate:
        return 'Undergraduate';
      case EducationLevel.postgraduate:
        return 'Postgraduate';
      case EducationLevel.selfTaught:
        return 'Self-Taught';
    }
  }

  String get backendValue {
    switch (this) {
      case EducationLevel.diploma:
        return 'DIPLOMA';
      case EducationLevel.undergraduate:
        return 'UNDERGRADUATE';
      case EducationLevel.postgraduate:
        return 'POSTGRADUATE';
      case EducationLevel.selfTaught:
        return 'SELF_TAUGHT';
    }
  }
}

extension CsBackgroundExtension on CsBackground {
  String get displayName {
    switch (this) {
      case CsBackground.cs:
        return 'Computer Science / IT';
      case CsBackground.nonCs:
        return 'Non-CS Engineering';
      case CsBackground.noDegree:
        return 'No Formal Degree';
    }
  }

  String get backendValue {
    switch (this) {
      case CsBackground.cs:
        return 'CS_IT';
      case CsBackground.nonCs:
        return 'NON_CS';
      case CsBackground.noDegree:
        return 'NO_FORMAL_DEGREE';
    }
  }
}

extension TimelineExtension on Timeline {
  String get displayName {
    switch (this) {
      case Timeline.oneToTwoWeeks:
        return '1-2 Weeks';
      case Timeline.oneMonth:
        return '1 Month';
      case Timeline.threeMonths:
        return '3 Months';
      case Timeline.sixPlusMonths:
        return '6+ Months';
    }
  }

  String get backendValue {
    switch (this) {
      case Timeline.oneToTwoWeeks:
        return 'ONE_TO_TWO_WEEKS';
      case Timeline.oneMonth:
        return 'ONE_MONTH';
      case Timeline.threeMonths:
        return 'THREE_MONTHS';
      case Timeline.sixPlusMonths:
        return 'SIX_PLUS_MONTHS';
    }
  }
}

extension PrimaryGoalExtension on PrimaryGoal {
  String get displayName {
    switch (this) {
      case PrimaryGoal.fundamentals:
        return 'Learn Fundamentals';
      case PrimaryGoal.realWorldProject:
        return 'Build Real-World Projects';
      case PrimaryGoal.internship:
        return 'Prepare for Internship';
      case PrimaryGoal.interview:
        return 'Crack Technical Interviews';
      case PrimaryGoal.startup:
        return 'Build a Startup';
      case PrimaryGoal.collegeProject:
        return 'Complete College Project';
    }
  }

  String get backendValue {
    switch (this) {
      case PrimaryGoal.interview:
        return 'JOB_INTERVIEW_PREPARATION';
      case PrimaryGoal.fundamentals:
        return 'LEARNING_FUNDAMENTALS';
      case PrimaryGoal.realWorldProject:
        return 'BUILDING_REAL_WORLD_PROJECT';
      case PrimaryGoal.internship:
        return 'INTERNSHIP_PREPARATION';
      case PrimaryGoal.startup:
        return 'STARTUP';
      case PrimaryGoal.collegeProject:
        return 'COLLEGE_PROJECT';
    }
  }
}

extension ArchitectureLevelExtension on ArchitectureLevel {
  String get displayName {
    switch (this) {
      case ArchitectureLevel.none:
        return 'None';
      case ArchitectureLevel.mvc:
        return 'MVC';
      case ArchitectureLevel.layered:
        return 'Layered Architecture';
      case ArchitectureLevel.clean:
        return 'Clean Architecture';
      case ArchitectureLevel.microservices:
        return 'Microservices';
    }
  }
}

extension DatabaseTypeExtension on DatabaseType {
  String get displayName {
    switch (this) {
      case DatabaseType.relational:
        return 'Relational (SQL)';
      case DatabaseType.nosql:
        return 'NoSQL';
      case DatabaseType.both:
        return 'Both';
    }
  }

  String get backendValue {
    switch (this) {
      case DatabaseType.relational:
        return 'RELATIONAL';
      case DatabaseType.nosql:
        return 'NOSQL';
      case DatabaseType.both:
        return 'BOTH';
    }
  }
}

extension ComfortLevelExtension on ComfortLevel {
  String get displayName {
    switch (this) {
      case ComfortLevel.basicQueries:
        return 'Basic Queries';
      case ComfortLevel.schemaDesign:
        return 'Schema Design';
      case ComfortLevel.indexing:
        return 'Indexing & Optimization';
      case ComfortLevel.transactions:
        return 'Transactions & ACID';
    }
  }

  String get backendValue {
    switch (this) {
      case ComfortLevel.basicQueries:
        return 'BASIC_QUERIES';
      case ComfortLevel.schemaDesign:
        return 'SCHEMA_DESIGN';
      case ComfortLevel.indexing:
        return 'INDEXING';
      case ComfortLevel.transactions:
        return 'TRANSACTIONS';
    }
  }
}

extension CodingFrequencyExtension on CodingFrequency {
  String get displayName {
    switch (this) {
      case CodingFrequency.rarely:
        return 'Rarely';
      case CodingFrequency.sometimes:
        return 'Sometimes';
      case CodingFrequency.daily:
        return 'Daily';
    }
  }

  String get backendValue {
    switch (this) {
      case CodingFrequency.rarely:
        return 'RARELY';
      case CodingFrequency.sometimes:
        return 'SOMETIMES';
      case CodingFrequency.daily:
        return 'DAILY';
    }
  }
}

extension DebuggingConfidenceExtension on DebuggingConfidence {
  String get displayName {
    switch (this) {
      case DebuggingConfidence.low:
        return 'Low';
      case DebuggingConfidence.medium:
        return 'Medium';
      case DebuggingConfidence.high:
        return 'High';
    }
  }

  String get backendValue {
    switch (this) {
      case DebuggingConfidence.low:
        return 'LOW';
      case DebuggingConfidence.medium:
        return 'MEDIUM';
      case DebuggingConfidence.high:
        return 'HIGH';
    }
  }
}

extension ProjectCategoryExtension on ProjectCategory {
  String get displayName {
    switch (this) {
      case ProjectCategory.business:
        return 'Business';
      case ProjectCategory.education:
        return 'Education';
      case ProjectCategory.social:
        return 'Social';
      case ProjectCategory.finance:
        return 'Finance';
      case ProjectCategory.healthcare:
        return 'Healthcare';
      case ProjectCategory.productivity:
        return 'Productivity';
      case ProjectCategory.other:
        return 'Other';
    }
  }
}

extension ChatPhaseExtension on ChatPhase {
  String get displayName {
    switch (this) {
      case ChatPhase.idle:
        return 'Ready to Start';
      case ChatPhase.ideaDiscussion:
        return 'Exploring Your Idea';
      case ChatPhase.requirementGathering:
        return 'Gathering Requirements';
      case ChatPhase.architectureDesign:
        return 'Designing Architecture';
      case ChatPhase.taskPlanning:
        return 'Planning Tasks';
      case ChatPhase.execution:
        return 'Execution Mode';
    }
  }

  IconData get icon {
    switch (this) {
      case ChatPhase.idle:
        return Icons.chat;
      case ChatPhase.ideaDiscussion:
        return Icons.lightbulb_outline;
      case ChatPhase.requirementGathering:
        return Icons.checklist;
      case ChatPhase.architectureDesign:
        return Icons.account_tree;
      case ChatPhase.taskPlanning:
        return Icons.task_alt;
      case ChatPhase.execution:
        return Icons.code;
    }
  }

  String get description {
    switch (this) {
      case ChatPhase.idle:
        return 'Let\'s start a conversation';
      case ChatPhase.ideaDiscussion:
        return 'Understanding your project vision';
      case ChatPhase.requirementGathering:
        return 'Defining clear requirements';
      case ChatPhase.architectureDesign:
        return 'Planning system architecture';
      case ChatPhase.taskPlanning:
        return 'Breaking down into actionable tasks';
      case ChatPhase.execution:
        return 'Building and reviewing code';
    }
  }
}

extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.user:
        return 'User';
      case MessageType.ai:
        return 'AI Assistant';
      case MessageType.system:
        return 'System';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.user:
        return Icons.person;
      case MessageType.ai:
        return Icons.psychology;
      case MessageType.system:
        return Icons.info_outline;
    }
  }
}

extension MessageIntentExtension on MessageIntent {
  String get displayName {
    switch (this) {
      case MessageIntent.conversational:
        return 'Conversation';
      case MessageIntent.requirementGathering:
        return 'Requirements';
      case MessageIntent.architectureSuggestion:
        return 'Architecture';
      case MessageIntent.taskBreakdown:
        return 'Task Planning';
      case MessageIntent.codeReview:
        return 'Code Review';
      case MessageIntent.traceability:
        return 'Traceability';
    }
  }
}

extension FrontendTechnologyExtension on FrontendTechnology {
  String get backendValue {
    switch (this) {
      case FrontendTechnology.react:
        return 'REACT';
      case FrontendTechnology.flutter:
        return 'FLUTTER';
      case FrontendTechnology.angular:
        return 'ANGULAR';
      case FrontendTechnology.vue:
        return 'VUE';
      case FrontendTechnology.htmlCssJs:
        return 'HTML_CSS_JS';
      case FrontendTechnology.other:
        return 'OTHER';
    }
  }

  String get displayName {
    switch (this) {
      case FrontendTechnology.react:
        return 'React';
      case FrontendTechnology.flutter:
        return 'Flutter';
      case FrontendTechnology.angular:
        return 'Angular';
      case FrontendTechnology.vue:
        return 'Vue.js';
      case FrontendTechnology.htmlCssJs:
        return 'HTML/CSS/JavaScript';
      case FrontendTechnology.other:
        return 'Other';
    }
  }
}

extension BackendTechnologyExtension on BackendTechnology {
  String get backendValue {
    switch (this) {
      case BackendTechnology.springBoot:
        return 'SPRING_BOOT';
      case BackendTechnology.nodeJs:
        return 'NODE_JS';
      case BackendTechnology.django:
        return 'DJANGO';
      case BackendTechnology.firebase:
        return 'FIREBASE';
      case BackendTechnology.csharp:
        return 'CSHARP';
      case BackendTechnology.other:
        return 'OTHER';
    }
  }

  String get displayName {
    switch (this) {
      case BackendTechnology.springBoot:
        return 'Spring Boot';
      case BackendTechnology.nodeJs:
        return 'Node.js';
      case BackendTechnology.django:
        return 'Django';
      case BackendTechnology.firebase:
        return 'Firebase';
      case BackendTechnology.csharp:
        return 'C# / .NET';
      case BackendTechnology.other:
        return 'Other';
    }
  }
}

extension ApiKnowledgeExtension on ApiKnowledge {
  String get backendValue {
    switch (this) {
      case ApiKnowledge.beginner:
        return 'BEGINNER';
      case ApiKnowledge.intermediate:
        return 'INTERMEDIATE';
      case ApiKnowledge.advanced:
        return 'ADVANCED';
    }
  }

  String get displayName {
    switch (this) {
      case ApiKnowledge.beginner:
        return 'Beginner';
      case ApiKnowledge.intermediate:
        return 'Intermediate';
      case ApiKnowledge.advanced:
        return 'Advanced';
    }
  }
}

extension ArchitectureExperienceExtension on ArchitectureExperience {
  String get backendValue {
    switch (this) {
      case ArchitectureExperience.neverWorked:
        return 'NEVER_WORKED';
      case ArchitectureExperience.mvc:
        return 'MVC';
      case ArchitectureExperience.layeredArch:
        return 'LAYERED_ARCH';
      case ArchitectureExperience.cleanArch:
        return 'CLEAN_ARCH';
      case ArchitectureExperience.microservices:
        return 'MICROSERVICES';
    }
  }

  String get displayName {
    switch (this) {
      case ArchitectureExperience.neverWorked:
        return 'Never Worked With';
      case ArchitectureExperience.mvc:
        return 'MVC';
      case ArchitectureExperience.layeredArch:
        return 'Layered Architecture';
      case ArchitectureExperience.cleanArch:
        return 'Clean Architecture';
      case ArchitectureExperience.microservices:
        return 'Microservices';
    }
  }
}

extension CoreSubjectExtension on CoreSubject {
  String get backendValue {
    switch (this) {
      case CoreSubject.dataStructures:
        return 'DATA_STRUCTURES';
      case CoreSubject.oop:
        return 'OOP';
      case CoreSubject.dbms:
        return 'DBMS';
      case CoreSubject.operatingSystem:
        return 'OPERATING_SYSTEM';
      case CoreSubject.computerNetworks:
        return 'COMPUTER_NETWORKS';
    }
  }

  String get displayName {
    switch (this) {
      case CoreSubject.dataStructures:
        return 'Data Structures';
      case CoreSubject.oop:
        return 'Object-Oriented Programming';
      case CoreSubject.dbms:
        return 'Database Management Systems';
      case CoreSubject.operatingSystem:
        return 'Operating Systems';
      case CoreSubject.computerNetworks:
        return 'Computer Networks';
    }
  }
}

extension FamiliarConceptExtension on FamiliarConcept {
  String get backendValue {
    switch (this) {
      case FamiliarConcept.mvc:
        return 'MVC';
      case FamiliarConcept.repositoryPattern:
        return 'REPOSITORY_PATTERN';
      case FamiliarConcept.dtos:
        return 'DTOS';
      case FamiliarConcept.solidPrinciples:
        return 'SOLID_PRINCIPLES';
      case FamiliarConcept.designPatterns:
        return 'DESIGN_PATTERNS';
    }
  }

  String get displayName {
    switch (this) {
      case FamiliarConcept.mvc:
        return 'MVC';
      case FamiliarConcept.repositoryPattern:
        return 'Repository Pattern';
      case FamiliarConcept.dtos:
        return 'DTOs';
      case FamiliarConcept.solidPrinciples:
        return 'SOLID Principles';
      case FamiliarConcept.designPatterns:
        return 'Design Patterns';
    }
  }
}

extension DatabaseSystemExtension on DatabaseSystem {
  String get backendValue {
    switch (this) {
      case DatabaseSystem.mysql:
        return 'MYSQL';
      case DatabaseSystem.postgresql:
        return 'POSTGRESQL';
      case DatabaseSystem.oracle:
        return 'ORACLE';
      case DatabaseSystem.mongodb:
        return 'MONGODB';
      case DatabaseSystem.firebase:
        return 'FIREBASE';
      case DatabaseSystem.other:
        return 'OTHER';
    }
  }

  String get displayName {
    switch (this) {
      case DatabaseSystem.mysql:
        return 'MySQL';
      case DatabaseSystem.postgresql:
        return 'PostgreSQL';
      case DatabaseSystem.oracle:
        return 'Oracle';
      case DatabaseSystem.mongodb:
        return 'MongoDB';
      case DatabaseSystem.firebase:
        return 'Firebase';
      case DatabaseSystem.other:
        return 'Other';
    }
  }
}

extension ProblemSolvingAreaExtension on ProblemSolvingArea {
  String get backendValue {
    switch (this) {
      case ProblemSolvingArea.loopsAndConditions:
        return 'LOOPS_AND_CONDITIONS';
      case ProblemSolvingArea.functions:
        return 'FUNCTIONS';
      case ProblemSolvingArea.oop:
        return 'OOP';
      case ProblemSolvingArea.dsaBasics:
        return 'DSA_BASICS';
      case ProblemSolvingArea.advancedDsa:
        return 'ADVANCED_DSA';
    }
  }

  String get displayName {
    switch (this) {
      case ProblemSolvingArea.loopsAndConditions:
        return 'Loops & Conditions';
      case ProblemSolvingArea.functions:
        return 'Functions';
      case ProblemSolvingArea.oop:
        return 'Object-Oriented Programming';
      case ProblemSolvingArea.dsaBasics:
        return 'DSA Basics';
      case ProblemSolvingArea.advancedDsa:
        return 'Advanced DSA';
    }
  }
}
