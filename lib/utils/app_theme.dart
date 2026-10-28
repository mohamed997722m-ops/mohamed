import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Colors.green;
  static const Color backgroundWhite = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
