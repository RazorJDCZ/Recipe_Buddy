import 'package:flutter/material.dart';

class AppTheme {
  static const Color mint = Color(0xFF5ED1B7);
  static const Color mintLight = Color(0xFFDDF7EF);
  static const Color dark = Color(0xFF101418);
  static const Color white = Colors.white;

  static ThemeData theme() {
    return ThemeData(
      primaryColor: mint,
      scaffoldBackgroundColor: white,

      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: dark,
        ),
        bodyMedium: TextStyle(
          color: dark,
          fontSize: 16,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mintLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mint,
          foregroundColor: white,
          elevation: 4,
          shadowColor: mint.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
