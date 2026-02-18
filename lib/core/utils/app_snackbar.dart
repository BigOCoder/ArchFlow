import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    IconData icon = Icons.mark_email_read_outlined,
    Color iconColor = AppColors.brandGreen,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor: Theme.of(context).colorScheme.surface,

        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),  
          ],
        ),
      ),
    );
  }
}
