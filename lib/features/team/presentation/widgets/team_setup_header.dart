// lib/features/team/presentation/widgets/team_setup_header.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamSetupHeader extends StatelessWidget {
  const TeamSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.brandGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.brandGreen.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.dashboard_outlined,
                size: 16,
                color: AppColors.brandGreen,
              ),
              const SizedBox(width: 8),
              Text(
                'PROJECT DASHBOARD',
                style: GoogleFonts.lato(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandGreen,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),

        // Title with gradient
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              isDark ? Colors.white : Colors.black,
              isDark ? Colors.white70 : Colors.black87,
            ],
          ).createShader(bounds),
          child: Text(
            'SETUP YOUR TEAM',
            style: GoogleFonts.lato(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
        ),
        
        const SizedBox(height: 16),

        // Subtitle with accent
        Container(
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColors.brandGreen,
                width: 4,
              ),
            ),
          ),
          child: Text(
            'Choose to create a new team from scratch or select from existing team templates.',
            style: GoogleFonts.lato(
              fontSize: 16,
              color: isDark 
                  ? AppColors.darkTextSecondary 
                  : AppColors.lightTextSecondary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
