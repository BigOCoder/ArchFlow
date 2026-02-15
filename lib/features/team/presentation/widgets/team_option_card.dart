// lib/features/team/presentation/widgets/team_option_card.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/team/presentation/widgets/animated_benefit_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamOptionCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final List<String> benefits;
  final String buttonText;
  final VoidCallback onPressed;

  const TeamOptionCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.benefits,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<TeamOptionCard> createState() => _TeamOptionCardState();
}

class _TeamOptionCardState extends State<TeamOptionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withOpacity(0.5)
                  : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
              width: 2,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: widget.color.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient + icon
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(0.15),
                      widget.color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // Icon
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color,
                              widget.color.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.description,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(0.3),
                            widget.color.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Benefits header
                    Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          size: 18,
                          color: widget.color,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'KEY BENEFITS',
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: widget.color,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Benefits list with animations
                    ...List.generate(
                      widget.benefits.length,
                      (index) => AnimatedBenefitItem(
                        text: widget.benefits[index],
                        color: widget.color,
                        delay: Duration(milliseconds: 100 * index),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.color,
                          foregroundColor: Colors.white,
                          elevation: _isHovered ? 8 : 0,
                          shadowColor: widget.color.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.buttonText,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedRotation(
                              turns: _isHovered ? 0.125 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
