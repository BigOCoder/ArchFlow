import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/auth_provider.dart';
import 'package:archflow/features/auth/presentation/screens/login/login_screen.dart';
import 'package:archflow/features/auth/presentation/screens/register/check_email_screen.dart';
import 'package:archflow/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:archflow/features/legal/terms_and_conditions_screen.dart';
import 'package:archflow/features/profile/presentation/screens/onboarding_flow.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ CHANGED: ConsumerStatefulWidget
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

// ✅ CHANGED: ConsumerState
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _password = ''; // ✅ ADD

  UserRole? _selectedRole;

  bool _agreeToTerms = false;
  bool _obscurePassword = true;

  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  // ignore: unused_field
  bool _hasMinLength = false;

  void _updatePasswordChecks(String value) {
    setState(() {
      _password = value; // ✅ ADD
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(value);
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
      _hasMinLength = value.length >= 8;
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Minimum 8 characters required';
    }
    if (!_hasUppercase) return 'Add at least one uppercase letter';
    if (!_hasLowercase) return 'Add at least one lowercase letter';
    if (!_hasNumber) return 'Add at least one number';
    if (!_hasSpecialChar) return 'Add at least one special character';
    return null;
  }

  // ✅ COMPLETELY NEW _submit METHOD
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      if (kDebugMode) print('❌ Form validation failed');
      return;
    }

    if (!_agreeToTerms) {
      if (kDebugMode) print('❌ Terms not agreed');
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please accept Terms & Privacy Policy',
      );
      return;
    }

    if (_selectedRole == null) {
      if (kDebugMode) print('❌ No role selected');
      AppSnackBar.show(context, message: 'Please select your role');
      return;
    }

    _formKey.currentState!.save();

    if (kDebugMode) {
      print('🎯 Starting registration...');
      print('   Name: $_fullName');
      print('   Email: $_email');
      print('   Role: $_selectedRole');
    }

    // ✅ CALL REAL API
    final success = await ref
        .read(authProvider.notifier)
        .register(
          name: _fullName,
          email: _email,
          password: _password,
          agreedToTerms: _agreeToTerms,
          role: _selectedRole == UserRole.student
              ? 'STUDENT'
              : 'JUNIOR_DEVELOPER',
        );

    if (kDebugMode) {
      print('✅ Registration result: $success');
    }

    if (!mounted) return;

    if (success) {
      AppSnackBar.show(
        context,
        icon: Icons.check_circle_outline,
        iconColor: AppColors.brandGreen,
        message: 'Account created successfully!',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckEmailScreen(email: _email),
        ),
      );
    } else {
      final error = ref.read(authProvider).error;
      if (kDebugMode) {
        print('❌ Registration error: $error');
      }

      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: error ?? 'Registration failed. Please try again.',
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
                  'Create an account',
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
                  'Create a new account to continue',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        decoration: appInputDecoration(
                          context: context,
                          label: 'Full Name',
                          hint: 'Samay Raina',
                          icon: Icons.person,
                        ),
                        onChanged: (v) => _fullName = v,
                        validator: (v) => v == null || v.length < 3
                            ? 'Enter a valid name'
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
                        onChanged: _updatePasswordChecks,
                        validator: validatePassword,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Select Your Role',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      RadioListTile<UserRole>(
                        value: UserRole.juniorDeveloper,
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v),
                        title: Text(
                          'Junior Developer',
                          style: GoogleFonts.lato(),
                        ),
                        subtitle: Text(
                          'Learning and building projects',
                          style: GoogleFonts.lato(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        activeColor: AppColors.brandGreen,
                      ),

                      RadioListTile<UserRole>(
                        value: UserRole.student,
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v),
                        title: Text('Student', style: GoogleFonts.lato()),
                        subtitle: Text(
                          'Studying and exploring concepts',
                          style: GoogleFonts.lato(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        activeColor: AppColors.brandGreen,
                      ),

                      const SizedBox(height: 20),

                      TermsCheckbox(
                        value: _agreeToTerms,
                        onChanged: (v) =>
                            setState(() => _agreeToTerms = v ?? false),
                        onTapTerms: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TermsAndConditionsScreen(),
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
                            foregroundColor: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          child:
                              isLoading // ✅ CHANGED
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Create Account',
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
                            "Already have an account?",
                            style: GoogleFonts.lato(),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Log in',
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
