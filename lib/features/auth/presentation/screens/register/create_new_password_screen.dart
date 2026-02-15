import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/screens/login/login_screen.dart';
import 'package:archflow/features/auth/presentation/widgets/password_rule_item.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String _newPassword = '';
  // ignore: unused_field
  String _confirmPassword = '';

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _hasMinLength = false;

  void _updatePasswordChecks(String value) {
    setState(() {
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(value);
      _hasNumber = RegExp(r'[0-9]').hasMatch(value);
      _hasSpecialChar =
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
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
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Add at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Add at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Add at least one special character';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      debugPrint('NEW PASSWORD SET');

      if (!mounted) return;

      AppSnackBar.show(
        context,
        icon: Icons.check_circle,
        iconColor: AppColors.success,
        message: 'Password updated successfully',
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            Text(
              'Create new password 🔐',
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Create your new password. Make sure it is strong and secure.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 32),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    obscureText: _obscureNew,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'New Password',
                      hint: '••••••••',
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                      ),
                    ),
                    onChanged: (v) {
                      _newPassword = v;
                      _updatePasswordChecks(v);
                    },
                    validator: validatePassword,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    obscureText: _obscureConfirm,
                    decoration: appInputDecoration(
                      context: context,
                      label: 'Confirm New Password',
                      hint: '••••••••',
                      icon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                    ),
                    onChanged: (v) => _confirmPassword = v,
                    validator: (v) =>
                        v != _newPassword
                            ? 'Passwords do not match'
                            : null,
                  ),

                  const SizedBox(height: 12),

                  PasswordRuleItem(
                    label: 'At least 8 characters',
                    isValid: _hasMinLength,
                  ),
                  PasswordRuleItem(
                    label: 'One uppercase letter',
                    isValid: _hasUppercase,
                  ),
                  PasswordRuleItem(
                    label: 'One lowercase letter',
                    isValid: _hasLowercase,
                  ),
                  PasswordRuleItem(
                    label: 'One number',
                    isValid: _hasNumber,
                  ),
                  PasswordRuleItem(
                    label: 'One special character',
                    isValid: _hasSpecialChar,
                  ),
                ],
              ),
            ),
            
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Save New Password',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
