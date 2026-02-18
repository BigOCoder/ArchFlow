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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 32,
              color: isLocked
                  ? Theme.of(context).iconTheme.color
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
              color: Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).textTheme.bodyMedium?.color,
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
                  foregroundColor: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color,
                  side: BorderSide(color: Theme.of(context).dividerColor),
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
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color,
                  disabledBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.surface,
                  disabledForegroundColor: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  elevation: 0,
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
