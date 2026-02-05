import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:archflow/themeData/app_color.dart';

class StepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;

  const StepHeader({
    super.key,
    required this.currentStep,
    required this.title,
    this.totalSteps = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final progress = currentStep / totalSteps;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// 🔘 CIRCULAR PROGRESS
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: isDark
                    ? AppColors.darkDivider
                    : AppColors.lightDivider,
                valueColor: const AlwaysStoppedAnimation(
                  AppColors.brandGreen,
                ),
              ),

              /// 🔢 STEP NUMBER
              Text(
                '$currentStep',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandGreen,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        /// 📝 STEP TEXT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step $currentStep',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.brandGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
