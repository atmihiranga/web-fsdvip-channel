import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode Colors (Current Defaults)
  static const Color background = Color(0xFF0F111A);
  static const Color backgroundDarker = Color(0xFF0A0C14);
  static const Color cardBackground = Color(0xFF161926);
  static const Color surface = Color(0xFF1F2235);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightBackgroundDarker = Color(0xFFF1F5F9);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFE2E8F0);

  // Accents (Shared or adaptable)
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF8B5CF6); // Violet
  static const Color accent = blue; // Cyan

  // Semantic Colors
  static const Color green = Color(0xFF10B981); // Emerald
  static const Color red = Color(0xFFEF4444); // Rose
  static const Color blue = Color(0xFF3B82F6); // Blue
  static const Color orange = Color(0xFFF59E0B); // Amber

  // Neutral Colors - Dark Mode
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color divider = Color(0xFF334155);

  // Neutral Colors - Light Mode
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF64748B);
  static const Color lightDivider = Color(0xFFE2E8F0);

  static Color white = Colors.white.withAlpha(225);
  static Color whiteDisabled = Colors.white.withAlpha(125);

  static const Color transparent = Colors.transparent;

  // Legacy mappings for compatibility (can be phased out)
  static const Color backgroundDarker2 = Color(0xFF1E293B);
  static const Color backgroundDarker3 = Color(0xFF334155);
  static const Color backgroundLighter = Color(0xFF1E293B);
  static const Color backgroundLighter2 = Color(0xFF334155);
}
