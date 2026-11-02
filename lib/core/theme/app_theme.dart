import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const _errorColor = Color(0xFF7A0000);

  static OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: color, width: width),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          primary: AppColors.navy,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.navy,
            minimumSize: const Size.fromHeight(60),
            side: const BorderSide(color: AppColors.navy, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.field,
          border: _border(Colors.transparent, 0),
          enabledBorder: _border(Colors.transparent, 0),
          focusedBorder: _border(AppColors.navy, 2),
          errorBorder: _border(_errorColor, 1.5),
          focusedErrorBorder: _border(_errorColor, 2),
          errorStyle: const TextStyle(
              color: _errorColor, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColors.mint,
          indicatorColor: Colors.white,
        ),
      );
}
