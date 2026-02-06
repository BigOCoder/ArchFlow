// lib/screens/common/under_development_screen.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class UnderDevelopmentScreen extends StatefulWidget {
  final String? featureName;
  
  const UnderDevelopmentScreen({
    super.key,
    this.featureName,
  });

  @override
  State<UnderDevelopmentScreen> createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Under Development',
          style: GoogleFonts.lato(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated construction icon
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.brandGreen.withOpacity(0.2),
                              AppColors.brandGreen.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandGreen.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.construction_outlined,
                          size: 100,
                          color: AppColors.brandGreen,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 48),

              // Title
              Text(
                'Under Development',
                style: GoogleFonts.lato(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Feature name (if provided)
              if (widget.featureName != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.brandGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    widget.featureName!,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Description
              Text(
                'This feature is currently being built.\nWe\'re working hard to bring it to you soon!',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  height: 1.6,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Info cards
              _InfoCard(
                icon: Icons.rocket_launch_outlined,
                title: 'Coming Soon',
                description: 'Expected in next update',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.notifications_outlined,
                title: 'Stay Updated',
                description: 'We\'ll notify you when ready',
                isDark: isDark,
              ),

              const Spacer(),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: Text(
                        'Go Back',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to home or dashboard
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home_outlined, size: 20),
                      label: Text(
                        'Home',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withOpacity(0.5)
            : AppColors.lightSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkDivider.withOpacity(0.3)
              : AppColors.lightDivider.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brandGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.brandGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
