import 'package:clapmi/global_object_folder_jacket/global_classes/customColor.dart';
import 'package:flutter/material.dart';

final customAppTheme = CustomAppTheme();

/// App color constants for consistent theming across the app
/// Extracted from hardcoded values to enable centralized color management
class AppColorConstants {
  AppColorConstants._();

  // Primary colors
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF0C0D0D);

  // Background colors
  static const Color scaffoldBackground = Color(0xFF0C0D0D);
  static const Color cardBackground = Color(0xFF1C1C1E);
  static const Color inputBackground = Color(0xFF2C2C2E);
  static const Color dropdownBackground = Color(0xFF1A1A1A);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textHint = Colors.white54;
  static const Color textMuted = Color(0xFF9A9A9A);

  // Accent colors
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);

  // Border colors
  static const Color borderLight = Color(0xFF3A3A3A);
  static const Color borderSubtle = Color(0x1AFFFFFF);
}

class CustomAppTheme extends ChangeNotifier {
  ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primaryColor,
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 42,
            color: Colors.white,
          ),
          displayLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );
}
