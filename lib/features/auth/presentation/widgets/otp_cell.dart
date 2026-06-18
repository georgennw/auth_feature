import 'package:auth/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OtpCell extends StatelessWidget {
  final String char;
  final bool isFocused;
  final bool hasError;

  const OtpCell({
    required this.char,
    required this.isFocused,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : (isFocused ? AppColors.blue : AppColors.grey400),
          width: isFocused ? 2 : 1,
        ),
      ),
      child: Text(
        char,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
