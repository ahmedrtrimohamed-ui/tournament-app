import 'package:flutter/material.dart';

class AppColors {
  // Primary background & cards
  static const Color background = Color(0xFF0F111A);
  static const Color cardBg = Color(0xFF1E2130);
  static const Color surface = Color(0xFF161925);

  // Neon Accent Colors
  static const Color primary = Color(0xFF00E5FF); // Electric Blue
  static const Color secondary = Color(0xFF7C4DFF); // Purple
  static const Color success = Color(0xFF00FF94); // Neon Green
  static const Color error = Color(0xFFFF4D6D); // Red Gradient base
  static const Color warning = Color(0xFFFFC107); // Amber/Warning

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF00B8D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF651FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFFF1744), Color(0xFFFF5252)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glow effects
  static BoxShadow primaryGlow = BoxShadow(
    color: primary.withAlpha((255 * 0.4).toInt()),
    blurRadius: 15,
    spreadRadius: 2,
  );

  static BoxShadow secondaryGlow = BoxShadow(
    color: secondary.withAlpha((255 * 0.4).toInt()),
    blurRadius: 15,
    spreadRadius: 2,
  );
}
