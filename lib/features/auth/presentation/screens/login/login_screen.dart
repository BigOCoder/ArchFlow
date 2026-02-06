
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/auth_provider.dart';
import 'package:archflow/features/auth/presentation/screens/login/reset_password_screen.dart';
import 'package:archflow/features/auth/presentation/screens/register/register_screen.dart';
import 'package:archflow/features/auth/presentation/widgets/remember_me_row.dart';
import 'package:archflow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // ✅ ADD
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ ADD

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

// ✅ CHANGED: ConsumerState
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _obscurePassword = true;
  bool _rememberMe = false;

  // ✅ COMPLETELY NEW _submit METHOD
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      if (kDebugMode) print('❌ Form validation failed');
      return;
    }

    _formKey.currentState!.save();

    if (kDebugMode) {
      print('🎯 Starting login...');
      print('   Email: $_email');
      print('   Remember Me: $_rememberMe');
    }

    // ✅ CALL REAL API
    final success = await ref
        .read(authProvider.notifier)
        .login(email: _email, password: _password, rememberMe: _rememberMe);

    if (kDebugMode) {
      print('✅ Login result: $success');
    }

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        context,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.brandGreen,
        message: 'Login successful!',
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    } else {
      final error = ref.read(authProvider).error;
      if (kDebugMode) {
        print('❌ Login error: $error');
      }

      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: error ?? 'Login failed. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = ref.watch(
      authProvider.select((s) => s.isLoading),
    ); // ✅ ADD

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 80,
              bottom: 80,
              left: 40,
              right: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: GoogleFonts.lato(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please enter your email & password',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [
                          AutofillHints.email,
                          AutofillHints.username,
                        ],
                        decoration: appInputDecoration(
                          context: context,
                          label: 'Email',
                          hint: 'test@gmail.com',
                          icon: Icons.email,
                        ),
                        onChanged: (v) => _email = v,
                        validator: (v) =>
                            v == null || !RegExp(r'^\S+@\S+\.\S+$').hasMatch(v)
                            ? 'Enter a valid email'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        obscureText: _obscurePassword,
                        decoration: appInputDecoration(
                          context: context,
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        onChanged: (v) => _password = v,
                        validator: (v) => v == null || v.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                      ),

                      const SizedBox(height: 12),

                      RememberMeRow(
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                        onForgotPassword: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ResetPasswordScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit, // ✅ CHANGED
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandGreen,
                            foregroundColor: Colors.white,
                          ),
                          child:
                              isLoading // ✅ CHANGED
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.lato(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.lato(
                                color: AppColors.brandGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
