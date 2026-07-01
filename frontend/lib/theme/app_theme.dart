import 'package:flutter/material.dart';

class AppTheme {
  // Vibrant Food Delivery Palette (Orange/Yellow)
  static const Color primaryBrand = Color(0xFFFF7A00); // Vibrant Orange
  static const Color backgroundCanvas = Color(0xFFFEF3E6); // Distinct Warm cream
  static const Color white = Colors.white;
  
  // Text Colors
  static const Color textDark = Color(0xFF1C1C1C); // Deep charcoal
  static const Color textMuted = Color(0xFF707070); // Muted gray
  
  static const Color danger = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);

  // Common Border Radius for Premium UI
  static final BorderRadius commonRadius = BorderRadius.circular(16);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBrand,
      scaffoldBackgroundColor: backgroundCanvas,
      fontFamily: 'Outfit', // High-end typography
      
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontFamily: 'Outfit',
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrand,
          foregroundColor: white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            fontSize: 16,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBrand,
          side: const BorderSide(color: primaryBrand, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            fontSize: 16,
          ),
        ),
      ),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBrand,
        primary: primaryBrand,
        surface: white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBrand,
      scaffoldBackgroundColor: const Color(0xFF111827),
      fontFamily: 'Outfit',
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111827),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontFamily: 'Outfit',
        ),
      ),
      
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryBrand,
        primary: primaryBrand,
        surface: const Color(0xFF1F2937),
      ),
    );
  }

  // Premium Soft Shadow Container Decoration
  static BoxDecoration get containerShadow {
    return BoxDecoration(
      color: white,
      borderRadius: commonRadius,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04), // Ultra-clean, subtle shadow
          blurRadius: 16,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  // Premium Dark Container Decoration
  static BoxDecoration get darkContainerShadow {
    return BoxDecoration(
      color: const Color(0xFF1F2937),
      borderRadius: commonRadius,
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 24,
          offset: const Offset(0, 8),
        )
      ],
    );
  }
}
