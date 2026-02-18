import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/features/team/presentation/screens/create_team_screen.dart';
import 'package:archflow/features/team/presentation/widgets/team_member_card.dart';
import 'package:archflow/features/team/presentation/widgets/empty_team_illustration.dart';
import 'package:archflow/features/team/data/models/team_member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<TeamMember> _teamMembers = [
    TeamMember(
      id: '1',
      name: 'Kartik Kamatkar',
      username: '@kartikkamatkar',
      role: TeamRole.lead,
      avatarEmoji: '👩🏽‍💼',
      joinedAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
    TeamMember(
      id: '2',
      name: 'Sneha Patil',
      username: '@sneha_p',
      role: TeamRole.developer,
      avatarEmoji: '👱‍♀️',
      joinedAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    TeamMember(
      id: '3',
      name: 'Amol Deshmukh',
      username: '@amol_d',
      role: TeamRole.designer,
      avatarEmoji: '👨🏿',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  List<TeamMember> get _filteredMembers {
    if (_searchQuery.isEmpty) return _teamMembers;
    return _teamMembers.where((member) {
      return member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          member.username.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _handleBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Fixed - build was broken (missing isDark + return WillPopScope)
    final bool hasMembers = _teamMembers.isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        // ✅ Removed backgroundColor - uses theme
        appBar: AppBar(
          // ✅ Removed backgroundColor & elevation - uses theme
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // ✅ Removed color - uses theme iconTheme
            onPressed: _handleBack,
          ),
          title: Text(
            'Workspace Dashboard',
            style: GoogleFonts.lato(
              // ✅ Fixed - uses theme
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TEAM MEMBERS',
                                style: GoogleFonts.lato(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  // ✅ Fixed - uses theme
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Manage roles, permissions, and collaborative access for your projects.',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                  // ✅ Fixed - uses theme
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (hasMembers)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.brandGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.brandGreen.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.people,
                                      color: AppColors.brandGreen,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'TOTAL MEMBERS',
                                      style: GoogleFonts.lato(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        // ✅ Fixed - uses theme
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _teamMembers.length.toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                  style: GoogleFonts.lato(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.brandGreen,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Search Bar & Add Button
              if (hasMembers)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            // ✅ Fixed - uses theme
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              // ✅ Fixed - uses theme
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter GitHub username or email',
                              hintStyle: GoogleFonts.lato(
                                // ✅ Fixed - uses theme
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              prefixIcon: Icon(
                                Icons.code,
                                // ✅ Fixed - uses theme
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            style: GoogleFonts.lato(
                              // ✅ Fixed - uses theme
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Add Member Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddMemberDialog(context),
                          icon: const Icon(Icons.person_add, size: 20),
                          label: Text(
                            'Add Member',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // ✅ Removed style - uses theme
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Content Area
              Expanded(
                child: hasMembers
                    ? _buildMembersList()
                    : _buildEmptyState(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Removed isDark param
  Widget _buildMembersList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredMembers.length,
      // ✅ Fixed - duplicate param name _ shadowing issue
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return TeamMemberCard(
          member: _filteredMembers[index],
          onRemove: () => _handleRemoveMember(_filteredMembers[index]),
        );
      },
    );
  }

  // ✅ Removed isDark param
  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),

          const EmptyTeamIllustration(),

          const SizedBox(height: 32),

          Text(
            'Build Your Team',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // ✅ Fixed - uses theme
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Start collaborating by creating your first team.\nInvite developers, designers, and project managers.',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 15,
              height: 1.6,
              // ✅ Fixed - uses theme
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateTeamScreen()),
                );
              },
              icon: const Icon(Icons.group_add, size: 24),
              label: Text(
                'Create Team',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ✅ Removed style - uses theme
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () => _showAddMemberDialog(context),
            child: Text(
              'or Add Individual Member',
              style: GoogleFonts.lato(
                fontSize: 15,
                color: AppColors.brandGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // ✅ Removed backgroundColor - uses theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Team Member',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            // ✅ Fixed - uses theme
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This feature will integrate with GitHub OAuth to add members.',
          style: GoogleFonts.lato(
            // ✅ Fixed - uses theme
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: GoogleFonts.lato(color: AppColors.brandGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _handleRemoveMember(TeamMember member) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // ✅ Removed backgroundColor - uses theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Remove ${member.name}?',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            // ✅ Fixed - uses theme
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This member will lose access to all team projects.',
          style: GoogleFonts.lato(
            // ✅ Fixed - uses theme
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.lato(
                // ✅ Fixed - uses theme
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _teamMembers.removeWhere((m) => m.id == member.id);
              });
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Remove',
              style: GoogleFonts.lato(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
