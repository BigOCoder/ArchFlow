// lib/data/models/project_model.dart

class ProjectModel {
  final String? id;
  
  // Basic Info
  final String name;
  final String summary;
  final String category;
  
  // Problem Statement
  final String problemStatement;
  final String? currentSolution;
  final String? whyInsufficient;
  
  // Target Users (Optional)
  final String? primaryUserType;
  final String? userScale;
  final List<String>? userRoles;
  
  // Features (Optional)
  final List<Map<String, dynamic>>? features;
  
  // Technical Details (Optional)
  final List<String>? platforms;
  final List<String>? supportedDevices;
  final String? expectedTimeline;
  final String? budgetRange;
  final String? expectedTraffic;
  final List<String>? dataSensitivity;
  final List<String>? complianceNeeds;
  
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProjectModel({
    this.id,
    required this.name,
    required this.summary,
    required this.category,
    required this.problemStatement,
    this.currentSolution,
    this.whyInsufficient,
    this.primaryUserType,
    this.userScale,
    this.userRoles,
    this.features,
    this.platforms,
    this.supportedDevices,
    this.expectedTimeline,
    this.budgetRange,
    this.expectedTraffic,
    this.dataSensitivity,
    this.complianceNeeds,
    required this.createdAt,
    this.updatedAt,
  });

  // ✅ toJson for API
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'summary': summary,
      'category': category,
      'problemStatement': problemStatement,
      'currentSolution': currentSolution,
      'whyInsufficient': whyInsufficient,
      'primaryUserType': primaryUserType,
      'userScale': userScale,
      'userRoles': userRoles,
      'features': features,
      'platforms': platforms,
      'supportedDevices': supportedDevices,
      'expectedTimeline': expectedTimeline,
      'budgetRange': budgetRange,
      'expectedTraffic': expectedTraffic,
      'dataSensitivity': dataSensitivity,
      'complianceNeeds': complianceNeeds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ✅ fromJson for parsing response - SAFER VERSION
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString(),  // ✅ Safe null handling
      name: json['name'] ?? '',    // ✅ Default empty string
      summary: json['summary'] ?? '',
      category: json['category'] ?? '',
      problemStatement: json['problemStatement'] ?? '',
      currentSolution: json['currentSolution'],
      whyInsufficient: json['whyInsufficient'],
      primaryUserType: json['primaryUserType'],
      userScale: json['userScale'],
      userRoles: json['userRoles'] != null 
          ? List<String>.from(json['userRoles']) 
          : null,
      features: json['features'] != null
          ? List<Map<String, dynamic>>.from(
              json['features'].map((x) => Map<String, dynamic>.from(x))
            )
          : null,
      platforms: json['platforms'] != null
          ? List<String>.from(json['platforms'])
          : null,
      supportedDevices: json['supportedDevices'] != null
          ? List<String>.from(json['supportedDevices'])
          : null,
      expectedTimeline: json['expectedTimeline'],
      budgetRange: json['budgetRange'],
      expectedTraffic: json['expectedTraffic'],
      dataSensitivity: json['dataSensitivity'] != null
          ? List<String>.from(json['dataSensitivity'])
          : null,
      complianceNeeds: json['complianceNeeds'] != null
          ? List<String>.from(json['complianceNeeds'])
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),  // ✅ Fallback to now
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
}
