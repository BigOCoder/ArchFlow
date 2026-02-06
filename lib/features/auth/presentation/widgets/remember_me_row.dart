import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RememberMeRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onForgotPassword;

  const RememberMeRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.brandGreen,
            ),
            Text(
              'Remember me',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onForgotPassword,
          child: Text(
            'Forgot password?',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.brandGreen,
            ),
          ),
        ),
      ],
    );
  }
}
