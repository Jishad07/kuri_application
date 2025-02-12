import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // Light Theme
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF6750A4), // Purple primary color
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF6750A4),
        secondary: const Color(0xFF625B71),
        surface: Colors.white,
        background: Colors.grey[50]!,
        error: Colors.red[700]!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black87),
        displayMedium: TextStyle(color: Colors.black87),
        displaySmall: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  // Dark Theme
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFD0BCFF), // Light purple for dark theme
      scaffoldBackgroundColor: const Color(0xFF1C1B1F),
      cardColor: const Color(0xFF2D2D2D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1B1F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFD0BCFF),
        secondary: const Color(0xFFCCC2DC),
        surface: const Color(0xFF2D2D2D),
        background: const Color(0xFF1C1B1F),
        error: Colors.red[300]!,
        onPrimary: Colors.black87,
        onSecondary: Colors.black87,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black87,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }
}
