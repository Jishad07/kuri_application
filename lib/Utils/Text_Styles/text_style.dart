import 'package:flutter/material.dart';

class AppTextStyles {
  // Regular Text style
  static TextStyle regular({Color color = Colors.black, double fontSize = 14}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
    );
  }

  // Bold Text style
  static TextStyle bold({Color color = Colors.black, double fontSize = 14}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  // Large Text style
  static TextStyle large({Color color = Colors.black, double fontSize = 20}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
    );
  }

  // Heading Text style
  static TextStyle heading({Color color = Colors.black, double fontSize = 24}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }
//winner textstyle
    static TextStyle winnerTextStyle({Color color = Colors.green, double fontSize = 28}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  // Subheading Text style
  static TextStyle subheading({Color color = Colors.black, double fontSize = 18}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  // Italic Text style
  static TextStyle italic({Color color = Colors.black, double fontSize = 14}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle splashScreentext({
    Color=Colors.black,
    double fontSize=18
  }){
    return TextStyle(
      color: Color,
      fontSize: fontSize  
        );
  }
}
