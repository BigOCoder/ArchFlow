import 'package:archflow/core/router/routes.dart';
import 'package:archflow/features/auth/presentation/providers/auth_provider.dart';
import 'package:archflow/features/auth/presentation/screens/login/login_screen.dart';
import 'package:archflow/features/auth/presentation/screens/login/reset_password_screen.dart';
import 'package:archflow/features/auth/presentation/screens/register/register_screen.dart';
import 'package:archflow/features/dashboard/presentation/screens/home.dart';
// Import other screens as needed...
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Bridges Riverpod's authProvider with GoRouter's refreshListenable.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    // Whenever authProvider changes, notify GoRouter to re-run redirect()
    _ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: notifier,   // re-evaluates redirect on auth changes

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Wait until the initial auth check completes
      if (authState.isLoading) return null;

      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;

      final isOnAuthRoute = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.resetPassword;

      // Not logged in and trying to access protected route → go to login
      if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;

      // Already logged in and visiting an auth page → go to home
      if (isAuthenticated && isOnAuthRoute) return AppRoutes.home;

      return null; // no redirect needed
    },

    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      // Add chat, profile, project, team, architecture, integrations, legal routes here
    ],
  );
});
