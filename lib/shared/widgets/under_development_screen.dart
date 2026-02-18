// lib/screens/common/under_development_screen.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class UnderDevelopmentScreen extends StatefulWidget {
  final String? featureName;

  const UnderDevelopmentScreen({super.key, this.featureName});

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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Removed backgroundColor - uses theme
      appBar: AppBar(
        // ✅ Removed elevation & backgroundColor - uses theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          // ✅ Removed color - uses theme iconTheme
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Under Development',
          style: GoogleFonts.lato(
            // ✅ Fixed - uses theme
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).colorScheme.onBackground,
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
                  // ✅ Fixed - uses theme
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Info cards
              _InfoCard(
                icon: Icons.rocket_launch_outlined,
                title: 'Coming Soon',
                description: 'Expected in next update',
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.notifications_outlined,
                title: 'Stay Updated',
                description: 'We\'ll notify you when ready',
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
                      // ✅ Removed style - uses theme
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home_outlined, size: 20),
                      label: Text(
                        'Home',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      // ✅ Removed style - uses theme
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

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ✅ Fixed - uses theme
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ✅ Fixed - uses theme
          color: Theme.of(context).dividerColor.withOpacity(0.3),
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
            child: Icon(icon, color: AppColors.brandGreen, size: 24),
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
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    // ✅ Fixed - uses theme
                    color: Theme.of(context).textTheme.bodySmall?.color,
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
