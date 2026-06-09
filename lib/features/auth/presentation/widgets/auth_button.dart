import 'package:auth/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isActive;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive
                    ? AppColors.buttonActive
                    : AppColors.buttonInactive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
              onPressed: isActive ? onPressed : null,
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
