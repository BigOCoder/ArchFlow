

import 'package:archflow/shared/widgets/app_color.dart';
import 'package:flutter/material.dart';

class SuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onTap;
  
  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(suggestion),
                onPressed: () => onTap(suggestion),
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                side: BorderSide(
                  color: AppColors.brandGreen.withOpacity(0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
