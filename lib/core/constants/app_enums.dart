// lib/core/constants/app_enums.dart
// Contains all enum definitions without extensions

/// User role selected during registration
enum UserRole { 
  juniorDeveloper, 
  student 
}

/// Highest education level of the user
enum EducationLevel { 
  diploma, 
  undergraduate, 
  postgraduate, 
  selfTaught 
}

/// Computer science background
enum CsBackground { 
  cs, 
  nonCs, 
  noDegree 
}

/// Skill proficiency level
enum ProficiencyLevel { 
  beginner, 
  intermediate, 
  advanced 
}

/// Preferred timeline to achieve goal
enum Timeline { 
  oneToTwoWeeks, 
  oneMonth, 
  threeMonths, 
  sixPlusMonths 
}

/// Architecture knowledge level
enum ArchitectureLevel { 
  none, 
  mvc, 
  layered, 
  clean, 
  microservices 
}

/// Database type preference
enum DatabaseType { 
  relational, 
  nosql, 
  both 
}

/// Database comfort level
enum ComfortLevel { 
  basicQueries, 
  schemaDesign, 
  indexing, 
  transactions 
}

/// Coding frequency
enum CodingFrequency { 
  rarely, 
  sometimes, 
  daily 
}

/// Debugging confidence level
enum DebuggingConfidence { 
  low, 
  medium, 
  high 
}

/// Integration providers
enum IntegrationProvider { 
  github, 
  linear, 
  jira 
}

/// Primary learning / career goal
enum PrimaryGoal {
  fundamentals,
  realWorldProject,
  internship,
  interview,
  startup,
  collegeProject,
}

/// Skill category
enum SkillCategory {
  webDevelopment,
  androidDevelopment,
  backendDevelopment,
  dsa,
  other,
}

/// Project category for project creation
enum ProjectCategory {
  business,
  education,
  social,
  finance,
  healthcare,
  productivity,
  other,
}

/// User type for requirements gathering
enum UserType {
  generalUsers('General Users'),
  businesses('Businesses'),
  admins('Admins'),
  developers('Developers');

  final String displayName;
  const UserType(this.displayName);
}

/// User scale for project size
enum UserScale {
  small('Small (0-1k users)'),
  medium('Medium (1k-100k users)'),
  large('Large (100k+ users)');

  final String displayName;
  const UserScale(this.displayName);
}

/// Feature priority
enum FeaturePriority {
  mustHave('Must-have'),
  shouldHave('Should-have'),
  niceToHave('Nice-to-have');

  final String displayName;
  const FeaturePriority(this.displayName);
}

/// Project timeline
enum ProjectTimeline {
  oneToThreeMonths('1-2 weeks'),
  threeToSixMonths('1 months'),
  sixToTwelveMonths('3 months'),
  moreThanTwelveMonths('6+ months');

  final String displayName;
  const ProjectTimeline(this.displayName);
}

/// Budget range
enum BudgetRange {
  learning('No budget (learning project)'),
  low('Low'),
  medium('Medium'),
  high('High');

  final String displayName;
  const BudgetRange(this.displayName);
}

/// Expected traffic
enum ExpectedTraffic {
  low('Low'),
  medium('Medium'),
  high('High');

  final String displayName;
  const ExpectedTraffic(this.displayName);
}

/// AI Chat conversation phase
enum ChatPhase {
  idle,
  ideaDiscussion,
  requirementGathering,
  architectureDesign,
  taskPlanning,
  execution,
}

/// Chat message type
enum MessageType {
  user,
  ai,
  system,
}

/// Chat message intent/purpose
enum MessageIntent {
  conversational,
  requirementGathering,
  architectureSuggestion,
  taskBreakdown,
  codeReview,
  traceability,
}

/// Frontend technologies
enum FrontendTechnology { 
  react, 
  flutter, 
  angular, 
  vue, 
  htmlCssJs, 
  other 
}

/// Backend technologies
enum BackendTechnology { 
  springBoot, 
  nodeJs, 
  django, 
  firebase, 
  csharp, 
  other 
}

/// API knowledge level
enum ApiKnowledge { 
  beginner, 
  intermediate, 
  advanced 
}

/// Architecture experience level
enum ArchitectureExperience {
  neverWorked,
  mvc,
  layeredArch,
  cleanArch,
  microservices,
}

/// Core computer science subjects
enum CoreSubject {
  dataStructures,
  oop,
  dbms,
  operatingSystem,
  computerNetworks,
}

/// Familiar programming concepts
enum FamiliarConcept {
  mvc,
  repositoryPattern,
  dtos,
  solidPrinciples,
  designPatterns,
}

/// Database systems
enum DatabaseSystem { 
  mysql, 
  postgresql, 
  oracle, 
  mongodb, 
  firebase, 
  other 
}

/// Problem solving skill areas
enum ProblemSolvingArea {
  loopsAndConditions,
  functions,
  oop,
  dsaBasics,
  advancedDsa,
}
