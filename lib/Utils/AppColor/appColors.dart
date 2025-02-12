import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - dark yellow (mustard yellow) as primary
  static const Color primaryColor = Color(0xFFFFC107); // Dark Yellow / Mustard Yellow
  static const Color primaryVariant =   Color(0xFFFFCC80); // Darker yellow-orange for accents
  static const Color secondaryColor = Color(0xFF607D8B); 
  static const Color whiteColor=Colors.white;
  static const Color blackColor=Colors.black;

  // Background colors - soft, neutral backgrounds
  static const Color backgroundColor = Color(0xFFF7F7F7); // Light grey for backgrounds
  static const Color appBarColor = Color(0xFFFFC107); // Dark Yellow for app bar (matches primary color)

  // Text colors - strong contrast for readability
  static const Color textColorPrimary = Color(0xFF212121); // Dark Grey for primary text
  static const Color textColorSecondary = Color(0xFF757575); // Medium Grey for secondary text

  // Accent colors - these will complement the primary dark yellow
  static const Color accentColor = Color(0xFFFF5722); // Deep Orange for highlights, call-to-action buttons

  // Success, Warning, and Error colors
  static const Color successColor = Color(0xFF4CAF50); // Green for success messages
  static const Color warningColor = Color(0xFFFFC107); // Yellow (slightly different tone) for warnings
  static const Color errorColor = Color(0xFFF44336); // Red for error messages

  // Custom colors for diversity
  static const Color customBlue = Color(0xFF1E88E5); // Rich Blue for links and highlights
  static const Color customPink = Color(0xFFE91E63); // Pink for vibrant accents
  
  // Neutral colors - shades for backgrounds, cards, and borders
  static const Color neutralLight = Color(0xFFF5F5F5); // Very Light Grey for soft backgrounds
  static const Color neutralDark = Color(0xFF616161); // Dark Grey for elements and text
  static const Color neutralGrey = Color(0xFF9E9E9E); // Medium Grey for borders or subtle elements

  // Earthy or warm tones that complement the yellow
  static const Color earthyBrown = Color(0xFF795548); // Earthy brown for warmth
  static const Color lightBeige = Color(0xFFF5DEB3); // Beige for light backgrounds
  static const Color softOrange = Color(0xFFFF7043); // A softer orange for secondary highlights
}

