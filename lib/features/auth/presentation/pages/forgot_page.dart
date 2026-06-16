import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/theme/app_colors.dart';
import 'package:auth/core/validator/validator_ext.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_event.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_state.dart';
import 'package:auth/features/auth/presentation/utils/auth_fail_ext.dart';
import 'package:auth/features/auth/presentation/widgets/auth_button.dart';
import 'package:auth/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:auth/features/auth/presentation/widgets/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      context.read<ForgotPasswordBloc>().add(
        ForgotPasswordEmailChanged(_emailController.text),
      );
    });
    _otpController.addListener(() {
      context.read<ForgotPasswordBloc>().add(
        ForgotPasswordOtpChanged(_otpController.text),
      );
    });

    void resetListener() {
      context.read<ForgotPasswordBloc>().add(
        ForgotPasswordResetFieldsChanged(
          _passwordController.text,
          _confirmPasswordController.text,
        ),
      );
    }

    _passwordController.addListener(resetListener);
    _confirmPasswordController.addListener(resetListener);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state.step == ForgotPasswordStep.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.passwordResetSuccess)),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final bool isError = state.failure != null;
            final String errorMessage = isError
                ? state.failure!.toLocalizeString(context)
                : '';

            return Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                    child: IconButton(
                      onPressed: state.isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.blue,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 92,
                            child: isError
                                ? ErrorBanner(message: errorMessage)
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 12),
                          if (state.step == ForgotPasswordStep.emailForm)
                            _EmailStepView(emailController: _emailController)
                          else if (state.step == ForgotPasswordStep.otpForm)
                            _OtpStepView(
                              otpController: _otpController,
                              state: state,
                            )
                          else if (state.step ==
                              ForgotPasswordStep.resetPasswordForm)
                            _ResetPasswordStepView(
                              passwordController: _passwordController,
                              confirmPasswordController:
                                  _confirmPasswordController,
                              isLoading: state.isLoading,
                              isError: isError,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 20.0,
                    top: 10.0,
                  ),
                  child: AuthButton(
                    text: state.step == ForgotPasswordStep.emailForm
                        ? l10n.buttonContinue
                        : state.step == ForgotPasswordStep.otpForm
                        ? l10n.buttonVerify
                        : l10n.buttonSavePassword,
                    isLoading: state.isLoading,
                    isActive: state.isButtonActive,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (state.step == ForgotPasswordStep.emailForm) {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordEmailSubmitted(),
                          );
                        } else if (state.step == ForgotPasswordStep.otpForm) {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordOtpSubmitted(),
                          );
                        } else if (state.step ==
                            ForgotPasswordStep.resetPasswordForm) {
                          context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordResetSubmitted(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EmailStepView extends StatelessWidget {
  final TextEditingController emailController;
  const _EmailStepView({required this.emailController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.forgotPasswordTitle,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.forgotPasswordSubtitle,
          style: const TextStyle(fontSize: 15, color: AppColors.grey),
        ),
        const SizedBox(height: 40),
        Text(
          l10n.labelEmail,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: emailController,
          hintText: l10n.hintEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (v) => v.toEmailError(context),
        ),
      ],
    );
  }
}

class _OtpStepView extends StatelessWidget {
  final TextEditingController otpController;
  final ForgotPasswordState state;
  const _OtpStepView({required this.otpController, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String currentOtp = otpController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.enterCodeTitle,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterCodeSubtitle,
          style: const TextStyle(fontSize: 15, color: AppColors.grey),
        ),
        const SizedBox(height: 40),
        Stack(
          children: [
            Opacity(
              opacity: 0.0,
              child: TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                autofocus: true,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                final bool isFocused = currentOtp.length == index;
                final bool hasValue = currentOtp.length > index;
                final String char = hasValue ? currentOtp[index] : '';
                return Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.failure != null
                          ? AppColors.borderError
                          : isFocused
                          ? AppColors.blue
                          : AppColors.grey400,
                      width: isFocused ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    char,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: state.timerSeconds > 0
              ? Text(
                  "${l10n.resendCodeText} 00:${state.timerSeconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: AppColors.grey, fontSize: 15),
                )
              : TextButton(
                  onPressed: () {
                    otpController.clear();
                    context.read<ForgotPasswordBloc>().add(
                      ForgotPasswordResendOtpRequested(),
                    );
                  },
                  child: Text(
                    l10n.linkResendCode,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ResetPasswordStepView extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final bool isError;

  const _ResetPasswordStepView({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.setNewPasswordTitle,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.setNewPasswordSubtitle,
          style: const TextStyle(fontSize: 15, color: AppColors.grey),
        ),
        const SizedBox(height: 40),

        Text(
          l10n.labelNewPassword,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: passwordController,
          hintText: l10n.hintPassword,
          enabled: !isLoading,
          isError: isError,
          obscureText: true,
          textInputAction: TextInputAction.next,
          validator: (v) => v.toPasswordError(context),
        ),
        const SizedBox(height: 20),

        Text(
          l10n.labelRepeatPassword,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: confirmPasswordController,
          hintText: l10n.hintPassword,
          enabled: !isLoading,
          isError: isError,
          obscureText: true,
          textInputAction: TextInputAction.done,
          validator: (v) {
            if (v != passwordController.text) {
              return l10n.errorPasswordsDoNotMatch;
            }
            return null;
          },
        ),
      ],
    );
  }
}
