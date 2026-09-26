import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0D0B1E);   // near-black navy
  static const surface = Color(0xFF1A1730);       // card / input backgrounds
  static const gradientStart = Color(0xFF3A0CA3); // deep blue-violet
  static const gradientEnd = Color(0xFFE63950);   // crimson red
  static const accent = Color(0xFFE63950);        // buttons, favorite heart
  static const textLight = Colors.white;
  static const textMuted = Color(0xFFAFAFC7);

  static const appBarGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}