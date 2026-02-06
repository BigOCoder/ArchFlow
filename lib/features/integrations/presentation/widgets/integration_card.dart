// lib/features/integrations/presentation/widgets/integration_card.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntegrationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback? onConnect;
  final VoidCallback? onSkip;
  final bool isLocked;

  const IntegrationCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    this.onConnect,
    this.onSkip,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.darkDivider.withOpacity(0.5)
                    : AppColors.lightDivider,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isLocked
                  ? (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)
                  : AppColors.brandGreen,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            description,
            style: GoogleFonts.lato(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Action Buttons
          if (!isLocked) ...[
            // Connect Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onConnect,
                icon: Icon(buttonIcon, size: 20),
                label: Text(
                  buttonText,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Skip Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: onSkip,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.darkDivider
                        : AppColors.lightDivider,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Skip for now',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Locked State Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: Icon(buttonIcon, size: 20),
                label: Text(
                  buttonText,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  foregroundColor: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  disabledBackgroundColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  disabledForegroundColor: isDark
                      ? AppColors.darkTextSecondary.withOpacity(0.5)
                      : AppColors.lightTextSecondary.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
