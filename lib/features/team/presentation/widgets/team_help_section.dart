// lib/features/team/presentation/widgets/team_help_section.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamHelpSection extends StatelessWidget {
  const TeamHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.brandGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOT SURE WHICH TO CHOOSE?',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          // ✅ Fixed - uses theme
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Here\'s a quick guide to help you decide',
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          // ✅ Fixed - uses theme
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Options
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _HelpOption(
                      color: const Color(0xFF2563EB),
                      title: 'CREATE NEW TEAM IF:',
                      items: const [
                        'You need specific people for this project',
                        'The project has unique requirements',
                        'You want complete control over setup',
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: _HelpOption(
                      color: AppColors.brandGreen,
                      title: 'SELECT EXISTING TEAM IF:',
                      items: const [
                        'You have a proven team structure',
                        'You want to save setup time',
                        'The project is similar to past ones',
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _HelpOption(
                    color: const Color(0xFF2563EB),
                    title: 'CREATE NEW TEAM IF:',
                    items: const [
                      'You need specific people for this project',
                      'The project has unique requirements',
                      'You want complete control over setup',
                    ],
                  ),
                  const SizedBox(height: 24),
                  _HelpOption(
                    color: AppColors.brandGreen,
                    title: 'SELECT EXISTING TEAM IF:',
                    items: const [
                      'You have a proven team structure',
                      'You want to save setup time',
                      'The project is similar to past ones',
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HelpOption extends StatelessWidget {
  final Color color;
  final String title;
  final List<String> items;

  const _HelpOption({
    required this.color,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with dot
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Items
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.lato(
                      fontSize: 13.5,
                      // ✅ Fixed - uses theme
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
