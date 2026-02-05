import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:archflow/themeData/app_color.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTapTerms;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTapTerms,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.brandGreen,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.lato(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              children: [
                const TextSpan(text: 'I agree to Chatify '),
                TextSpan(
                  text: 'Terms of Use & Privacy Policy',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandGreen,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onTapTerms,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
