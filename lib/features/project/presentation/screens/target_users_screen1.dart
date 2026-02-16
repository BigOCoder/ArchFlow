// lib/screens/project/target_users_screen.dart
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_notifier.dart';
import 'package:archflow/features/project/presentation/providers/project_onboarding_state.dart';
import 'package:archflow/features/project/presentation/screens/project_review_screen.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/app_input_decoration.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TargetUsersScreen extends ConsumerStatefulWidget {
  const TargetUsersScreen({super.key});

  @override
  ConsumerState<TargetUsersScreen> createState() => _TargetUsersScreenState();
}

class _TargetUsersScreenState extends ConsumerState<TargetUsersScreen> {
  UserType? _primaryUserType;
  UserScale? _userScale;
  final List<UserRoleEntry> _userRoles = [];

  bool _userTypeError = false;
  bool _userScaleError = false;

  final _roleNameController = TextEditingController();
  final _roleDescController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final project = ref.read(projectOnboardingProvider);

    if (_primaryUserType == null && project.primaryUserType != null) {
      _primaryUserType = project.primaryUserType;
      _userScale = project.userScale;

      if (project.userRoles.isNotEmpty) {
        _userRoles.clear();
        _userRoles.addAll(project.userRoles);
      }
    }
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleDescController.dispose();
    super.dispose();
  }

  void _addRole() {
    final roleName = _roleNameController.text.trim();

    if (roleName.isEmpty) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please enter a role name',
      );
      return;
    }

    if (_userRoles.any((r) => r.name.toLowerCase() == roleName.toLowerCase())) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Role "$roleName" already exists',
      );
      return;
    }

    setState(() {
      _userRoles.add(
        UserRoleEntry(
          name: roleName,
          description: _roleDescController.text.trim(),
        ),
      );
      _roleNameController.clear();
      _roleDescController.clear();
    });

    AppSnackBar.show(
      context,
      icon: Icons.check_circle_outline,
      iconColor: AppColors.brandGreen,
      message: 'Role "$roleName" added',
    );
  }

  void _removeRole(int index) {
    final roleName = _userRoles[index].name;
    setState(() {
      _userRoles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Role "$roleName" removed', style: GoogleFonts.lato()),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
      ),
    );
  }

  Widget _deleteBackground({required Alignment alignment}) {
    final bool isLeft = alignment == Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: EdgeInsets.only(left: isLeft ? 24 : 0, right: isLeft ? 0 : 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            'Delete',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    bool hasError = false;

    if (_primaryUserType == null) {
      setState(() => _userTypeError = true);
      hasError = true;
    }

    if (_userScale == null) {
      setState(() => _userScaleError = true);
      hasError = true;
    }

    if (hasError) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please complete all required fields',
      );
      return;
    }

    ref
        .read(projectOnboardingProvider.notifier)
        .updateTargetUsers(
          primaryUserType: _primaryUserType!,
          userScale: _userScale!,
          userRoles: _userRoles,
        );

    final isEditing = ref.read(projectOnboardingProvider).isEditMode;

    if (isEditing) {
      ref.read(projectOnboardingProvider.notifier).clearEditMode();
      ref.read(projectOnboardingProvider.notifier).goToStep(5);
    } else {
      ref.read(projectOnboardingProvider.notifier).nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        ref.read(projectOnboardingProvider.notifier).previousStep();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              onPressed: () {
                ref.read(projectOnboardingProvider.notifier).previousStep();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepHeader(
                  currentStep: 2,
                  totalSteps: 5,
                  title: 'Target Users',
                ),
                const SizedBox(height: 24),

                Text(
                  'Define who will use your application.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                /// 1️⃣ Primary User Type (REQUIRED)
                AppDropdown<UserType>(
                  label: 'Primary User Type',
                  icon: Icons.person_outline,
                  value: _primaryUserType,
                  hasError: _userTypeError,
                  entries: UserType.values.map((type) {
                    return DropdownMenuEntry<UserType>(
                      value: type,
                      label: type.displayName,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      _primaryUserType = value;
                      _userTypeError = false;
                    });
                  },
                ),

                const SizedBox(height: 24),

                /// 2️⃣ User Scale (REQUIRED)
                Text(
                  'User Scale',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _userScaleError
                          ? AppColors.error
                          : Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: UserScale.values.map((scale) {
                      return RadioListTile<UserScale>(
                        value: scale,
                        groupValue: _userScale,
                        onChanged: (value) {
                          setState(() {
                            _userScale = value;
                            _userScaleError = false;
                          });
                        },
                        title: Text(
                          scale.displayName,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        activeColor: AppColors.brandGreen,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Optional Section Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Optional',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.lightDivider,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// 3️⃣ User Roles (OPTIONAL)
                Text(
                  'User Roles (Optional)',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Define different user roles in your application (e.g., Admin, Customer).',
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Display Added Roles
                if (_userRoles.isNotEmpty) ...[
                  ..._userRoles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final role = entry.value;

                    return Dismissible(
                      key: ValueKey(role.name + index.toString()),
                      direction: DismissDirection.horizontal,
                      background: _deleteBackground(
                        alignment: Alignment.centerLeft,
                      ),
                      secondaryBackground: _deleteBackground(
                        alignment: Alignment.centerRight,
                      ),
                      onDismissed: (_) => _removeRole(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.brandGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: AppColors.brandGreen,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.name,
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  if (role.description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      role.description,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.drag_handle,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // ✅ UPDATED: Role Name Input (using appInputDecoration)
                TextField(
                  controller: _roleNameController,
                  style: GoogleFonts.lato(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: appInputDecoration(
                    context: context,
                    label: '',
                    hint: 'Role name (e.g., Admin, Customer, Manager)',
                    isMultiline: true,
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ UPDATED: Role Description Input (using appInputDecoration)
                TextField(
                  controller: _roleDescController,
                  maxLines: 3,
                  style: GoogleFonts.lato(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: appInputDecoration(
                    context: context,
                    label: '',
                    hint: 'Description (optional)',
                    isMultiline: true,
                  ),
                ),

                const SizedBox(height: 16),

                // Add Role Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _addRole,
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add Role',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.brandGreen,
                      side: const BorderSide(color: AppColors.brandGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
