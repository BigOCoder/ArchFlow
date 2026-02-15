import 'package:archflow/core/config/env_config.dart';
import 'package:archflow/core/theme/app_theme.dart';
import 'package:archflow/features/dashboard/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.initialize();

  EnvConfig.printConfig();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      home: const HomeScreen(),
    );
  }
}
