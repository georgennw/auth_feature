import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const Color white = Colors.white;
  static const Color blue = Colors.blue;
  static const Color grey = Colors.grey;

  static final Color grey400 = Colors.grey.shade400;

  static const Color buttonActive = Color(0xFF007FFF);
  static final Color buttonInactive = const Color(
    0xFF90CFFF,
  ).withValues(alpha: 0.5);

  static const Color errorText = Color(0xFFE53E3E);
  static const Color errorBackground = Color(0xFFFDE8E8);
  static final Color borderError = Colors.red.shade400;
  static final Color borderErrorFocused = Colors.red.shade600;
}
