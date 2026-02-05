import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:archflow/themeData/app_color.dart';

/// ✅ UNIFIED - Handles both single-line and multiline fields
InputDecoration appInputDecoration({
  required BuildContext context,
  required String label,
  required String hint,
  IconData? icon, // ✅ Optional now
  Widget? suffixIcon,
  bool isMultiline = false, // ✅ New parameter
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? AppColors.darkDivider : AppColors.lightDivider;

  // ✅ Smart border radius based on field type
  final borderRadius = isMultiline ? 12.0 : 30.0;

  // ✅ Smart padding based on field type
  final contentPadding = isMultiline
      ? const EdgeInsets.all(16)
      : const EdgeInsets.symmetric(horizontal: 20, vertical: 18);

  return InputDecoration(
    labelText: label.isNotEmpty ? label : null,
    hintText: hint,

    labelStyle: GoogleFonts.lato(
      fontSize: 14,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    ),
    hintStyle: GoogleFonts.lato(
      fontSize: 14,
      color: isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    ),

    // ✅ Only show icon if provided
    prefixIcon: icon != null ? Icon(icon, color: AppColors.brandGreen) : null,
    suffixIcon: suffixIcon,

    contentPadding: contentPadding,
    alignLabelWithHint: isMultiline, // ✅ Only for multiline
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
