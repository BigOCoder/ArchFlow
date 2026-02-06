import 'package:archflow/shared/widgets/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.brandGreen,
      secondary: AppColors.brandGreen,
      surface: AppColors.lightBackground,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
    ),

    dividerColor: AppColors.lightDivider,
    iconTheme: const IconThemeData(color: AppColors.lightIcon),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTextPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.brandGreen,
      secondary: AppColors.brandGreen,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
    ),

    dividerColor: AppColors.darkDivider,
    iconTheme: const IconThemeData(color: AppColors.darkIcon),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkTextSecondary),
    ),
  );
}
