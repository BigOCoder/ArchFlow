// lib/provider/project_provider.dart
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/features/project/data/models/project_model.dart';
import 'package:archflow/features/project/data/repositories/project_repository_impl.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProjectState {
  final ProjectModel? currentProject;
  final bool isLoading;
  final String? error;

  const ProjectState({
    this.currentProject,
    this.isLoading = false,
    this.error,
  });

  ProjectState copyWith({
    ProjectModel? currentProject,
    bool? isLoading,
    String? error,
  }) {
    return ProjectState(
      currentProject: currentProject ?? this.currentProject,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProjectNotifier extends Notifier<ProjectState> {
  @override
  ProjectState build() => const ProjectState();

  ProjectRepository get _repository => ref.read(projectRepositoryProvider);

  // ✅ EXPANDED: Store ALL onboarding data temporarily
  
  // Basic Info
  String? _tempName;
  String? _tempSummary;
  String? _tempCategory;
  
  // Target Users
  UserType? _tempPrimaryUserType;
  UserScale? _tempUserScale;
  List<UserRoleEntry>? _tempUserRoles;
  
  // Features
  List<FeatureEntry>? _tempFeatures;
  
  // Problem Statement
  String? _tempProblem;
  String? _tempCurrentSolution;
  String? _tempWhyInsufficient;
  
  // Technical Details
  List<String>? _tempPlatforms;
  List<String>? _tempSupportedDevices;
  String? _tempExpectedTimeline;
  String? _tempBudgetRange;
  String? _tempExpectedTraffic;
  List<String>? _tempDataSensitivity;
  List<String>? _tempComplianceNeeds;

  // ✅ Method 1: Update Basic Info
  void updateBasics({
    required String name,
    required String summary,
    required String category,
  }) {
    _tempName = name;
    _tempSummary = summary;
    _tempCategory = category;
  }

  // ✅ Method 2: Update Target Users
  void updateTargetUsers({
    UserType? primaryUserType,
    UserScale? userScale,
    List<UserRoleEntry>? userRoles,
  }) {
    _tempPrimaryUserType = primaryUserType;
    _tempUserScale = userScale;
    _tempUserRoles = userRoles;
  }

  // ✅ Method 3: Update Features
  void updateFeatures(List<FeatureEntry>? features) {
    _tempFeatures = features;
  }

  // ✅ Method 4: Update Problem Statement
  void updateProblem({
    required String problemStatement,
    String? currentSolution,
    String? whyInsufficient,
  }) {
    _tempProblem = problemStatement;
    _tempCurrentSolution = currentSolution;
    _tempWhyInsufficient = whyInsufficient;
  }

  // ✅ Method 5: Update Technical Details
  void updateTechnicalDetails({
    List<String>? platforms,
    List<String>? supportedDevices,
    String? expectedTimeline,
    String? budgetRange,
    String? expectedTraffic,
    List<String>? dataSensitivity,
    List<String>? complianceNeeds,
  }) {
    _tempPlatforms = platforms;
    _tempSupportedDevices = supportedDevices;
    _tempExpectedTimeline = expectedTimeline;
    _tempBudgetRange = budgetRange;
    _tempExpectedTraffic = expectedTraffic;
    _tempDataSensitivity = dataSensitivity;
    _tempComplianceNeeds = complianceNeeds;
  }

  // ✅ Method 6: Create Project with ALL data
  Future<bool> createProject() async {
    // Validate required fields
    if (_tempName == null ||
        _tempSummary == null ||
        _tempCategory == null ||
        _tempProblem == null) {
      state = state.copyWith(error: 'Missing required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // ✅ Create project with ALL collected data
      final project = ProjectModel(
        // Basic Info
        name: _tempName!,
        summary: _tempSummary!,
        category: _tempCategory!,
        
        // Problem Statement
        problemStatement: _tempProblem!,
        currentSolution: _tempCurrentSolution,
        whyInsufficient: _tempWhyInsufficient,
        
        // Target Users (optional - adapt based on your ProjectModel)
        primaryUserType: _tempPrimaryUserType?.displayName,
        userScale: _tempUserScale?.displayName,
        userRoles: _tempUserRoles?.map((r) => r.name).toList(),
        
        // Features (optional)
        features: _tempFeatures?.map((f) => {
          'name': f.name,
          'description': f.description,
          'priority': f.priority?.displayName ?? 'Not Set',
        }).toList(),
        
        // Technical Details (optional)
        platforms: _tempPlatforms,
        supportedDevices: _tempSupportedDevices,
        expectedTimeline: _tempExpectedTimeline,
        budgetRange: _tempBudgetRange,
        expectedTraffic: _tempExpectedTraffic,
        dataSensitivity: _tempDataSensitivity,
        complianceNeeds: _tempComplianceNeeds,
        
        createdAt: DateTime.now(),
      );

      final created = await _repository.createProject(project);
      state = state.copyWith(currentProject: created, isLoading: false);

      // Clear temp data
      _clearTemp();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  // ✅ Clear ALL temporary data
  void _clearTemp() {
    // Basic Info
    _tempName = null;
    _tempSummary = null;
    _tempCategory = null;
    
    // Target Users
    _tempPrimaryUserType = null;
    _tempUserScale = null;
    _tempUserRoles = null;
    
    // Features
    _tempFeatures = null;
    
    // Problem Statement
    _tempProblem = null;
    _tempCurrentSolution = null;
    _tempWhyInsufficient = null;
    
    // Technical Details
    _tempPlatforms = null;
    _tempSupportedDevices = null;
    _tempExpectedTimeline = null;
    _tempBudgetRange = null;
    _tempExpectedTraffic = null;
    _tempDataSensitivity = null;
    _tempComplianceNeeds = null;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final projectProvider = NotifierProvider<ProjectNotifier, ProjectState>(
  ProjectNotifier.new,
);
