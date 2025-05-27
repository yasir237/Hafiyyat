// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Cybersecurity color scheme
  static const Color darkNavy = Color(0xFF0A192F);
  static const Color cyberGreen = Color(0xFF64FFDA);
  static const Color mediumNavy = Color(0xFF112240);
  static const Color lightGray = Color(0xFFCCD6F6);
  
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: cyberGreen,
    colorScheme: const ColorScheme.light(
      primary: cyberGreen,
      secondary: lightGray,
      surface: mediumNavy,
      onPrimary: darkNavy,
      onSecondary: darkNavy,
      onSurface: lightGray,
    ),
    scaffoldBackgroundColor: darkNavy,
    appBarTheme: const AppBarTheme(
      backgroundColor: mediumNavy,
      foregroundColor: lightGray,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cyberGreen,
        foregroundColor: darkNavy,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightGray),
      bodyMedium: TextStyle(color: lightGray),
      titleLarge: TextStyle(color: lightGray),
      titleMedium: TextStyle(color: lightGray),
    ),
  );

  // Dark theme (using same colors as light theme for consistency)
  static final ThemeData darkTheme = ThemeData(
    primaryColor: cyberGreen,
    colorScheme: const ColorScheme.dark(
      primary: cyberGreen,
      secondary: lightGray,
      surface: mediumNavy,
      onPrimary: darkNavy,
      onSecondary: darkNavy,
      onSurface: lightGray,
    ),
    scaffoldBackgroundColor: darkNavy,
    appBarTheme: const AppBarTheme(
      backgroundColor: mediumNavy,
      foregroundColor: lightGray,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cyberGreen,
        foregroundColor: darkNavy,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightGray),
      bodyMedium: TextStyle(color: lightGray),
      titleLarge: TextStyle(color: lightGray),
      titleMedium: TextStyle(color: lightGray),
    ),
  );
}