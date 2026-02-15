// lib/features/team/presentation/screens/team_setup_screen.dart

import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/team/presentation/widgets/team_option_card.dart';
import 'package:archflow/features/team/presentation/widgets/team_setup_header.dart';
import 'package:archflow/features/team/presentation/widgets/team_help_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamSetupScreen extends ConsumerStatefulWidget {
  const TeamSetupScreen({super.key});

  @override
  ConsumerState<TeamSetupScreen> createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends ConsumerState<TeamSetupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.darkSurface 
                      : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark 
                        ? AppColors.darkDivider 
                        : AppColors.lightDivider,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: isDark 
                      ? AppColors.darkTextPrimary 
                      : AppColors.lightTextPrimary,
                  size: 20,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 24,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header with animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const TeamSetupHeader(),
                  ),
                ),
                
                SizedBox(height: isDesktop ? 60 : 40),

                // Cards
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildTeamOptions(context, isDark, isDesktop),
                ),

                const SizedBox(height: 60),

                // Help Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const TeamHelpSection(),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamOptions(BuildContext context, bool isDark, bool isDesktop) {
    final createCard = TeamOptionCard(
      color: const Color(0xFF2563EB),
      icon: Icons.add_circle_outline,
      title: 'CREATE NEW TEAM',
      description: 'Build a custom team by adding members and assigning roles from scratch',
      benefits: const [
        'Complete flexibility in member selection',
        'Custom role and designation assignment',
        'Define permissions and access levels',
        'Perfect for unique project requirements',
      ],
      buttonText: 'GET STARTED',
      onPressed: () {
        // TODO: Navigate to create team flow
      },
    );

    final browseCard = TeamOptionCard(
      color: AppColors.brandGreen,
      icon: Icons.groups_rounded,
      title: 'SELECT EXISTING TEAM',
      description: 'Use a pre-configured team template with members and roles already set up',
      benefits: const [
        'Quick setup with pre-defined teams',
        'Reuse successful team structures',
        'Maintain consistency across projects',
        'Save time on team configuration',
      ],
      buttonText: 'BROWSE TEAMS',
      onPressed: () {
        // TODO: Navigate to browse teams
      },
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: createCard),
          const SizedBox(width: 32),
          Expanded(child: browseCard),
        ],
      );
    } else {
      return Column(
        children: [
          createCard,
          const SizedBox(height: 24),
          browseCard,
        ],
      );
    }
  }
}
