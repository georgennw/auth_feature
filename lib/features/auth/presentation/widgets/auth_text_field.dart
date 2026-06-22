import 'package:auth/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool enabled;
  final bool obscureText;
  final bool isError;
  final Widget? icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final FocusNode? focusNode;

  const AuthTextField({
    required this.controller,
    this.hintText,
    this.enabled = true,
    this.obscureText = false,
    this.isError = false,
    this.icon,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onChanged,
    this.autofocus = false,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textInputAction: textInputAction,
      autofocus: autofocus,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.blue,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: icon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        filled: true,
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return AppColors.blue.withValues(alpha: 0.06);
          }
          if (isError) {
            return AppColors.borderError.withValues(alpha: 0.03);
          }
          return AppColors.white;
        }),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isError ? AppColors.borderError : AppColors.grey400,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.borderErrorFocused,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
