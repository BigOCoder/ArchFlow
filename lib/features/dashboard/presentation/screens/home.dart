import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/auth/presentation/screens/login/login_screen.dart';
import 'package:archflow/features/auth/presentation/screens/register/register_screen.dart';
import 'package:archflow/features/profile/presentation/screens/onboarding_flow.dart';
import 'package:archflow/features/project/presentation/screens/project_onboarding_flow_screen.dart';
import 'package:archflow/features/team/presentation/screens/team_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Image',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.brandGreen,
                          side: const BorderSide(color: AppColors.brandGreen),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProjectOnboardingFlow(),
                          ),
                        );
                      },
                      child: Text(
                        'Continue as a guest',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 65, 182, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
