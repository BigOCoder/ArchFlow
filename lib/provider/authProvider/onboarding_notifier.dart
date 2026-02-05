import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_state.dart';
import 'package:archflow/data/models/app_enums.dart';
import 'package:archflow/screens/profile/skills_proficiency_screen2.dart';

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  // 🔁 Navigation
  void nextStep() {
    if (state.returnStep != null) {
      // ⬅️ go back to review
      state = state.copyWith(
        step: state.returnStep!,
        returnStep: null, // reset
      );
    } else {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void previousStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  // 🎓 Education
  void setEducationLevel(EducationLevel level) {
    state = state.copyWith(educationLevel: level);
  }

  void setCsBackground(CsBackground bg) {
    state = state.copyWith(csBackground: bg);
  }

  // 🧠 Skills
  void setSkills(List<SkillEntry> skills) {
    state = state.copyWith(skills: skills);
  }

  void setCoreSubjects(List<String> subjects) {
    state = state.copyWith(coreSubjects: subjects);
  }

  void setPrimaryGoal(PrimaryGoal goal) {
    state = state.copyWith(primaryGoal: goal);
  }

  void setTimeline(Timeline timeline) {
    state = state.copyWith(timeline: timeline);
  }

  void setArchitectureLevel(ArchitectureLevel level) {
    state = state.copyWith(architectureLevel: level);
  }

  void setFamiliarConcepts(List<String> concepts) {
    state = state.copyWith(familiarConcepts: concepts);
  }

  void setDatabaseType(DatabaseType type) {
    state = state.copyWith(databaseType: type);
  }

  void setDatabaseComfortLevel(ComfortLevel level) {
    state = state.copyWith(databaseComfortLevel: level);
  }

  void setDatabasesUsed(List<String> databases) {
    state = state.copyWith(databasesUsed: databases);
  }

  void setCodingFrequency(CodingFrequency value) {
    state = state.copyWith(codingFrequency: value);
  }

  void setDebuggingConfidence(DebuggingConfidence value) {
    state = state.copyWith(debuggingConfidence: value);
  }

  void setProblemSolvingAreas(List<String> areas) {
    state = state.copyWith(problemSolvingAreas: areas);
  }

  void goToStep(int step, {int? returnStep}) {
    state = state.copyWith(step: step, returnStep: returnStep);
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
