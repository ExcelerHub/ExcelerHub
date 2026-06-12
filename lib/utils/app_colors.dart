import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xff2563eb); // Deep Blue (#2563EB)
  static const Color secondary = Color(0xff60a5fa); // Light Blue (#60A5FA)
  static const Color accent = Color(0xfff59e0b); // Amber for achievements

  // Neutral Colors
  static const Color background = Color(0xfff8fafc); // Slate background
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xff0f172a); // Dark Slate (#0F172A)
  static const Color textSecondary = Color(0xff475569); // Medium Slate (#475569)
  static const Color textLight = Color(0xff94a3b8); // Light Slate (#94A3B8)

  // Status Colors
  static const Color success = Color(0xff10b981); // Emerald Green
  static const Color error = Color(0xffef4444); // Red
  static const Color warning = Color(0xfff59e0b); // Warning
  
  // Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xff1d4ed8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xff3b82f6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
