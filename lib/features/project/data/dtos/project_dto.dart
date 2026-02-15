import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';

/// Role DTO for project creation
class ProjectRoleDto {
  final String roleName;
  final String? roleDescription;

  ProjectRoleDto({required this.roleName, this.roleDescription});

  Map<String, dynamic> toJson() => {
    'roleName': roleName,
    if (roleDescription != null && roleDescription!.isNotEmpty)
      'roleDescription': roleDescription,
  };

  factory ProjectRoleDto.fromJson(Map<String, dynamic> json) => ProjectRoleDto(
    roleName: json['roleName'] as String,
    roleDescription: json['roleDescription'] as String?,
  );
}

/// Feature DTO for project creation
class ProjectFeatureDto {
  final String featureName;
  final String? featureDescription;
  final FeaturePriority featurePriority;

  ProjectFeatureDto({
    required this.featureName,
    this.featureDescription,
    required this.featurePriority,
  });

  Map<String, dynamic> toJson() => {
    'featureName': featureName,
    if (featureDescription != null && featureDescription!.isNotEmpty)
      'featureDescription': featureDescription,
    'featurePriority': featurePriority.backendValue,
  };

  factory ProjectFeatureDto.fromJson(Map<String, dynamic> json) =>
      ProjectFeatureDto(
        featureName: json['featureName'] as String,
        featureDescription: json['featureDescription'] as String?,
        featurePriority: FeaturePriority.values.firstWhere(
          (e) => e.displayName == json['featurePriority'],
        ),
      );
}

/// Project Create Request DTO
class ProjectCreateDto {
  final String projectName;
  final ProjectCategory projectCategory;
  final String projectSummary;
  final UserType userType;
  final UserScale userScale;
  final List<ProjectRoleDto>? roles;
  final List<ProjectFeatureDto>? features;
  final String problemStatement;
  final String? currentSolution;
  final String? existingSolutionInsufficient;
  final PlatformType platform;
  final SupportedDevice supportedDevice;
  final ExpectedTimeline expectedTimeline;
  final BudgetRange budget;
  final ExpectedTraffic expectedTraffic;
  final DataSensitivity dataSensitivity;
  final ComplianceNeeds? complianceNeeds;

  ProjectCreateDto({
    required this.projectName,
    required this.projectCategory,
    required this.projectSummary,
    required this.userType,
    required this.userScale,
    this.roles,
    this.features,
    required this.problemStatement,
    this.currentSolution,
    this.existingSolutionInsufficient,
    required this.platform,
    required this.supportedDevice,
    required this.expectedTimeline,
    required this.budget,
    required this.expectedTraffic,
    required this.dataSensitivity,
    this.complianceNeeds,
  });

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'projectCategory': projectCategory.backendValue,
    'projectSummary': projectSummary,
    'userType': userType.backendValue, 
    'userScale': userScale.backendValue,
    'roles': roles?.map((r) => r.toJson()).toList(),
    'features': features?.map((f) => f.toJson()).toList(),
    'problemStatement': problemStatement,
    if (currentSolution != null && currentSolution!.isNotEmpty)
      'currentSolution': currentSolution,
    if (existingSolutionInsufficient != null &&
        existingSolutionInsufficient!.isNotEmpty)
      'existingSolutionInsufficient': existingSolutionInsufficient,
    'platform': platform.backendValue,
    'supportedDevice': supportedDevice.backendValue,
    'expectedTimeline': expectedTimeline.backendValue,
    'budget': budget.backendValue,
    'expectedTraffic': expectedTraffic.backendValue,
    'dataSensitivity': dataSensitivity.backendValue,
    if (complianceNeeds != null)
      'complianceNeeds': complianceNeeds!.backendValue,
  };
}
