import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuEntry<T>> entries;
  final ValueChanged<T?> onSelected;
  final bool hasError;

  const AppDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.entries,
    required this.onSelected,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed - uses theme
    final borderColor = hasError
        ? AppColors.error
        : Theme.of(context).dividerColor;

    // ✅ Fixed - uses theme
    final labelColor = Theme.of(context).textTheme.bodySmall?.color;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: DropdownMenu<T>(
            initialSelection: value,
            width: constraints.maxWidth,
            label: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                // ✅ Fixed - uses theme
                color: labelColor,
              ),
            ),
            leadingIcon: Icon(
              icon,
              color: AppColors.brandGreen,
            ),
            dropdownMenuEntries: entries,
            onSelected: onSelected,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: GoogleFonts.lato(
                fontSize: 14,
                // ✅ Fixed - uses theme
                color: labelColor,
              ),
              hintStyle: GoogleFonts.lato(
                fontSize: 14,
                // ✅ Fixed - uses theme
                color: labelColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),

              /// 🔲 Default border
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: borderColor),
              ),

              /// 🟢 Focused border
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.brandGreen,
                  width: 2,
                ),
              ),

              /// 🔴 Error borders
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
