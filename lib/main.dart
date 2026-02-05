import 'package:archflow/core/config/env_config.dart';
import 'package:archflow/screens/home.dart';
import 'package:archflow/themeData/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await EnvConfig.initialize();

  // Print configuration in debug mode
  EnvConfig.printConfig();

  // Run the app
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌗 System-based theme
      themeMode: ThemeMode.system,

      // ☀️ Light theme
      theme: AppTheme.lightTheme,

      // 🌙 Dark theme
      darkTheme: AppTheme.darkTheme,

      home: const HomeScreen(),
    );
  }
}
