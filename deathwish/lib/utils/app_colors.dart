import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFCC95C0);
  static const Color secondary = Color(0xFFDBD4B4);
  static const Color accent = Color(0xFF7AA1D2);
  
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color surfaceLight = Color(0xFF3A3A3A);
  static const Color surfaceDark = Color(0xFF0F0F0F);
  
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textHint = Color(0xFF8A8A8A);
  static const Color textOnGradient = Color(0xFFFFFFFF);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF7AA1D2);
  
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, accent],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F8F8)],
  );
}