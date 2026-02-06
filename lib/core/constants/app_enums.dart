// lib/data/models/app_enums.dart

import 'package:flutter/material.dart';

/// User role selected during registration
enum UserRole { juniorDeveloper, student }

/// Highest education level of the user
enum EducationLevel { diploma, undergraduate, postgraduate, selfTaught }

/// Computer science background
enum CsBackground { cs, nonCs, noDegree }

/// Skill proficiency level
enum ProficiencyLevel { beginner, intermediate, advanced }

/// Preferred timeline to achieve goal
enum Timeline { oneToTwoWeeks, oneMonth, threeMonths, sixPlusMonths }

enum ArchitectureLevel { none, mvc, layered, clean, microservices }

enum DatabaseType { relational, nosql, both }

enum ComfortLevel { basicQueries, schemaDesign, indexing, transactions }

enum CodingFrequency { rarely, sometimes, daily }

enum DebuggingConfidence { low, medium, high }

/// Primary learning / career goal
enum PrimaryGoal {
  fundamentals,
  realWorldProject,
  internship,
  interview,
  startup,
  collegeProject,
}

enum SkillCategory {
  webDevelopment,
  androidDevelopment,
  backendDevelopment,
  dsa,
  other,
}

/// ✅ NEW: Project category for project creation
enum ProjectCategory {
  business,
  education,
  social,
  finance,
  healthcare,
  productivity,
  other,
}

/// User Type Enum
enum UserType {
  generalUsers('General Users'),
  businesses('Businesses'),
  admins('Admins'),
  developers('Developers');

  final String displayName;
  const UserType(this.displayName);
}

/// User Scale Enum
enum UserScale {
  small('Small (0-1k users)'),
  medium('Medium (1k-100k users)'),
  large('Large (100k+ users)');

  final String displayName;
  const UserScale(this.displayName);
}

/// Feature Priority Enum
enum FeaturePriority {
  mustHave('Must-have'),
  shouldHave('Should-have'),
  niceToHave('Nice-to-have');

  final String displayName;
  const FeaturePriority(this.displayName);
}

enum ProjectTimeline {
  oneToThreeMonths('1-2 weeks'),
  threeToSixMonths('1 months'),
  sixToTwelveMonths('3 months'),
  moreThanTwelveMonths('6+ months');

  final String displayName;
  const ProjectTimeline(this.displayName);
}

enum BudgetRange {
  learning('No budget (learning project)'),
  low('Low'),
  medium('Medium'),
  high('High');

  final String displayName;
  const BudgetRange(this.displayName);
}

enum ExpectedTraffic {
  low('Low'),
  medium('Medium)'),
  high('High');

  final String displayName;
  const ExpectedTraffic(this.displayName);
}

/// ✅ NEW: AI Chat conversation phase
enum ChatPhase {
  idle,                 // No active conversation
  ideaDiscussion,       // Exploring the idea
  requirementGathering, // Structured Q&A
  architectureDesign,   // Proposing architecture
  taskPlanning,         // Breaking down tasks
  execution,            // During development
}

/// ✅ NEW: Chat message type
enum MessageType {
  user,    // Message from user
  ai,      // Message from AI assistant
  system,  // System message (errors, notifications)
}

/// ✅ NEW: Chat message intent/purpose
enum MessageIntent {
  conversational,          // General conversation
  requirementGathering,    // Asking structured questions
  architectureSuggestion,  // Proposing architecture
  taskBreakdown,           // Breaking features into tasks
  codeReview,              // Reviewing code
  traceability,            // Explaining "why" something exists
}

// ==================== EXTENSION METHODS ====================

// ✨ Extension methods for beautiful display names
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
}

extension CodingFrequencyExtension on CodingFrequency {
  String get displayName {
    switch (this) {
      case CodingFrequency.rarely:
        return 'Rarely (Few times a month)';
      case CodingFrequency.sometimes:
        return 'Sometimes (Few times a week)';
      case CodingFrequency.daily:
        return 'Daily';
    }
  }
}

extension DebuggingConfidenceExtension on DebuggingConfidence {
  String get displayName {
    switch (this) {
      case DebuggingConfidence.low:
        return 'Low - Need Help Often';
      case DebuggingConfidence.medium:
        return 'Medium - Can Figure Out Most';
      case DebuggingConfidence.high:
        return 'High - Confident & Independent';
    }
  }
}

/// ✅ NEW: Project category extension
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

/// ✅ NEW: Chat phase extension
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

/// ✅ NEW: Message type extension
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

/// ✅ NEW: Message intent extension
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
