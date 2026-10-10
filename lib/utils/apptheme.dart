import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2F8078);
  static const income = Color(0xFF1FA561);
  static const expense = Color(0xFFF0544F);
  static const label = Color(0xFF6B6B6B);
  static const border = Color(0xFFDADADA);
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)
            .copyWith(primary: AppColors.primary),
        scaffoldBackgroundColor: Colors.white,
      );
}