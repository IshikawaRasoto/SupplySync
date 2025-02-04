import 'package:flutter/material.dart';

part 'styles.dart';
part 'colors.dart';

class AppTheme {
  static final theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.primary,
    cardColor: AppColors.button,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: const TextStyle(
        color: AppColors.text,
        fontSize: 20,
      ),
      toolbarHeight: 50,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: AppColors.buttonText,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.text,
      ),
    ),
  );
}
