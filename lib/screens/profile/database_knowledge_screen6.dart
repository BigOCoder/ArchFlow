import 'package:archflow/data/models/app_enums.dart';
import 'package:archflow/provider/authProvider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:archflow/themeData/app_color.dart';
import 'package:archflow/utils/app_snackbar.dart';
import 'package:archflow/widget/common/step_header.dart';
import 'package:archflow/widget/common/app_dropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DatabaseKnowledgeScreen extends ConsumerStatefulWidget {
  const DatabaseKnowledgeScreen({super.key});

  @override
  ConsumerState<DatabaseKnowledgeScreen> createState() =>
      _DatabaseKnowledgeScreenState();
}

class _DatabaseKnowledgeScreenState
    extends ConsumerState<DatabaseKnowledgeScreen> {
  DatabaseType? _databaseType;
  ComfortLevel? _comfortLevel;

  final Map<String, bool> _databases = {};

  static const List<String> _relational = [
    'MySQL',
    'PostgreSQL',
    'Oracle',
    'SQL Server',
  ];

  static const List<String> _nosql = [
    'MongoDB',
    'Firebase',
    'Redis',
    'DynamoDB',
  ];

  static const List<String> _other = ['Other'];

  /// ---------------- STATE RESTORE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _databaseType ??= onboarding.databaseType;
    _comfortLevel ??= onboarding.databaseComfortLevel;

    if (_databaseType != null && _databases.isEmpty) {
      _loadDatabases(_databaseType!);

      for (final db in onboarding.databasesUsed) {
        if (_databases.containsKey(db)) {
          _databases[db] = true;
        }
      }
    }
  }

  /// ---------------- HELPERS ----------------
  void _loadDatabases(DatabaseType type) {
    _databases.clear();

    List<String> list;
    switch (type) {
      case DatabaseType.relational:
        list = [..._relational, ..._other];
        break;
      case DatabaseType.nosql:
        list = [..._nosql, ..._other];
        break;
      case DatabaseType.both:
        list = [..._relational, ..._nosql, ..._other];
        break;
    }

    for (final db in list) {
      _databases[db] = false;
    }
  }

  bool get _canProceed =>
      _databaseType != null &&
      _comfortLevel != null &&
      _databases.values.any((v) => v);

  /// ---------------- SUBMIT ----------------
  void _submit() {
    if (!_canProceed) {
      AppSnackBar.show(
        context,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        message: 'Please complete all database details',
      );
      return;
    }

    final selected = _databases.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);

    notifier.setDatabaseType(_databaseType!);
    notifier.setDatabaseComfortLevel(_comfortLevel!);
    notifier.setDatabasesUsed(selected);
    notifier.nextStep();
  }

  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () {
            ref.read(onboardingProvider.notifier).previousStep();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepHeader(currentStep: 6, title: 'Database Knowledge'),

            const SizedBox(height: 24),

            Text(
              'Tell us about your database experience.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 32),

            /// 🗄 DATABASE TYPE
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
              ),
              child: AppDropdown<DatabaseType>(
                label: 'Database Type',
                icon: Icons.storage,
                value: _databaseType,
                hasError: false,
                entries: DatabaseType.values
                    .map(
                      (type) => DropdownMenuEntry(
                        value: type,
                        label: type.displayName,
                      ),
                    )
                    .toList(),
                onSelected: (v) {
                  setState(() {
                    _databaseType = v;
                    if (v != null) {
                      _loadDatabases(v);
                    }
                  });
                },
              ),
            ),

            /// 🧠 DATABASES USED
            if (_databaseType != null)
              Container(
                margin: const EdgeInsets.only(bottom: 24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Databases Used',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._databases.keys.map((db) {
                      return CheckboxListTile(
                        value: _databases[db],
                        onChanged: (v) =>
                            setState(() => _databases[db] = v ?? false),
                        title: Text(
                          db,
                          style: GoogleFonts.lato(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        activeColor: AppColors.brandGreen,
                      );
                    }),
                  ],
                ),
              ),

            /// ⚡ COMFORT LEVEL
            if (_databaseType != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
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
                child: AppDropdown<ComfortLevel>(
                  label: 'Comfort Level',
                  icon: Icons.trending_up,
                  value: _comfortLevel,
                  hasError: false,
                  entries: ComfortLevel.values
                      .map(
                        (level) => DropdownMenuEntry(
                          value: level,
                          label: level.displayName,
                        ),
                      )
                      .toList(),
                  onSelected: (v) {
                    setState(() {
                      _comfortLevel = v;
                    });
                  },
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canProceed ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandGreen,
                  foregroundColor: Colors.white,
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
    );
  }
}
