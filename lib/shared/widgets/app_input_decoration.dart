import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration appInputDecoration({
  required BuildContext context,
  required String label,
  required String hint,
  IconData? icon,
  Widget? suffixIcon,
  bool isMultiline = false,
}) {
  final borderColor = Theme.of(context).dividerColor;

  final borderRadius = isMultiline ? 12.0 : 30.0;

  final contentPadding = isMultiline
      ? const EdgeInsets.all(16)
      : const EdgeInsets.symmetric(horizontal: 20, vertical: 18);

  return InputDecoration(
    labelText: label.isNotEmpty ? label : null,
    hintText: hint,

    labelStyle: GoogleFonts.lato(
      fontSize: 14,
      color: Theme.of(context).textTheme.bodySmall?.color,
    ),
    hintStyle: GoogleFonts.lato(
      fontSize: 14,
      color: Theme.of(context).textTheme.bodySmall?.color,
    ),

    prefixIcon: icon != null ? Icon(icon, color: AppColors.brandGreen) : null,
    suffixIcon: suffixIcon,

    contentPadding: contentPadding,
    alignLabelWithHint: isMultiline,

    /// 🔲 Default border
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor),
    ),

    /// 🟢 Focused border
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.brandGreen, width: 2),
    ),

    /// 🔴 Error borders
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
  );
}
