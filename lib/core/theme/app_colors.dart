import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const Color white = Colors.white;
  static const Color blue = Colors.blue;

  static const Color grey = Color(0xFF949494);
  static const Color grey400 = Color(0xFFBDBDBD);

  static const Color buttonActive = Color(0xFF007FFF);
  static final Color buttonInactive = const Color(0xFF90CFFF).withValues(alpha: 0.5);

  static const Color error = Color(0xFFFF3B30);
  static const Color errorText = Color(0xFFE53E3E);
  static const Color errorBackground = Color(0xFFFDE8E8);
  static final Color borderError = Colors.red.shade400;
  static final Color borderErrorFocused = Colors.red.shade600;
}
