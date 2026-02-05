import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:archflow/themeData/app_color.dart';

class PasswordRuleItem extends StatelessWidget {
  final String label;
  final bool isValid;

  const PasswordRuleItem({
    super.key,
    required this.label,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isValid
                ? AppColors.brandGreen
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: isValid
                  ? AppColors.brandGreen
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
