import 'package:archflow/features/auth/data/models/user_model.dart';
import 'package:archflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    Object? user = _undefined,
    bool? isLoading,
    Object? error = _undefined,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user == _undefined ? this.user : user as UserModel?,
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

const _undefined = Object();

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(() => _checkAuthStatus());
    return const AuthState();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // ✅ CHANGED: Added role parameter
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required bool agreedToTerms,
    String role = 'STUDENT', // ✅ NEW: Default to STUDENT
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        agreedToTerms: agreedToTerms,
        role: role, // ✅ NEW: Pass role to repository
      );

      state = state.copyWith(
        user: response.user,
        isAuthenticated:
            true, // ✅ CHANGED: true (no OTP verification in your API)
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  // ✅ NEW: Refresh token method
  Future<bool> refreshToken() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.refreshToken();

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      state = const AuthState();
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
