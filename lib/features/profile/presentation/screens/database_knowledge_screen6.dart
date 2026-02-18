import 'package:archflow/core/constants/app_enum_extensions.dart';
import 'package:archflow/core/constants/app_enums.dart';
import 'package:archflow/core/theme/app_color.dart';
import 'package:archflow/core/utils/app_snackbar.dart';
import 'package:archflow/features/auth/presentation/providers/onboarding_notifier.dart';
import 'package:archflow/features/profile/presentation/screens/final_review_screen.dart';
import 'package:archflow/shared/widgets/app_dropdown.dart';
import 'package:archflow/shared/widgets/step_header.dart';
import 'package:flutter/material.dart';
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

  final Map<String, String> _databasesMap = {
    'MySQL': 'MYSQL',
    'PostgreSQL': 'POSTGRESQL',
    'Oracle': 'ORACLE',
    'SQL Server': 'SQL_SERVER',
    'MongoDB': 'MONGODB',
    'Firebase': 'FIREBASE',
    'Redis': 'REDIS',
    'DynamoDB': 'DYNAMODB',
    'Other': 'OTHER',
  };

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final onboarding = ref.read(onboardingProvider);

    _databaseType ??= onboarding.databaseType;
    _comfortLevel ??= onboarding.databaseComfortLevel;

    if (_databaseType != null && _databases.isEmpty) {
      _loadDatabases(_databaseType!);

      for (final db in onboarding.databasesUsed) {
        final displayName = _databasesMap.entries
            .firstWhere((e) => e.value == db, orElse: () => MapEntry(db, db))
            .key;

        if (_databases.containsKey(displayName)) {
          _databases[displayName] = true;
        }
      }
    }
  }

  void _handleBackPressed() {
    ref.read(onboardingProvider.notifier).previousStep();
  }

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
        .map((e) => _databasesMap[e.key]!)
        .toList();

    final notifier = ref.read(onboardingProvider.notifier);

    notifier.setDatabaseType(_databaseType!);
    notifier.setDatabaseComfortLevel(_comfortLevel!);
    notifier.setDatabasesUsed(selected);

    final isEditing = ref.read(onboardingProvider).isEditingFromReview;

    if (isEditing) {
      notifier.clearEditMode();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinalReviewScreen()),
      );
    } else {
      notifier.nextStep();
    }
  }

  // ✅ Reusable section card helper
  Widget _sectionCard({required Widget child, double bottomMargin = 20}) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackPressed();
        return false;
      },
      child: Scaffold(
        // ✅ Removed backgroundColor - uses theme
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            // ✅ Removed color - uses theme iconTheme
            onPressed: _handleBackPressed,
          ),
          title: Text(
            'Database Knowledge',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(currentStep: 6, title: 'database experience?'),

              const SizedBox(height: 24),

              /// 🗄 DATABASE TYPE
              _sectionCard(
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
                _sectionCard(
                  bottomMargin: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Databases Used',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
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
                              color: Theme.of(context).colorScheme.onSurface,
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
                _sectionCard(
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
                  // ✅ Removed style - uses theme
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
    );
  }
}
