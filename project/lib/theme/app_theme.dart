import 'package:flutter/material.dart';

class SoloTheme {
  static const Color background = Color(0xFF0B0E14);
  static const Color cardBg = Color(0xFF131924);
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonCyan = Color(0xFF00B0FF);
  static const Color goldAccent = Color(0xFFFFC107);
  static const Color darkRed = Color(0xFFFF3366);
  static const Color textBright = Color(0xFFF1F5F9);
  static const Color textMuted = Color(0xFF64748B);

  static const Color rare = Color(0xFF3B82F6);
  static const Color epic = Color(0xFFA855F7);
  static const Color legendary = Color(0xFFFFB703);

  static BoxDecoration systemBoxDecoration({
    Color borderColor = const Color(0xFF1E293B),
    Color bg = cardBg,
  }) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColor, width: 1),
    );
  }
}