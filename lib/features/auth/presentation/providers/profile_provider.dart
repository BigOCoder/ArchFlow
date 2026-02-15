import 'package:archflow/features/auth/data/models/profile_request_model.dart';
import 'package:archflow/features/auth/data/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _undefined = Object();

class ProfileState {
  final bool isLoading;
  final String? error;
  final bool isSubmitted;
  final Map<String, dynamic>? response;

  const ProfileState({
    this.isLoading = false,
    this.error,
    this.isSubmitted = false,
    this.response,
  });

  ProfileState copyWith({
    bool? isLoading,
    Object? error = _undefined,
    bool? isSubmitted,
    Map<String, dynamic>? response,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      response: response ?? this.response,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  Future<bool> submitProfile(ProfileRequestModel profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.submitProfile(profile);

      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
        response: response,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSubmitted: false,
        error: e.toString(),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const ProfileState();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
