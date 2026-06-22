import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/theme/app_colors.dart';
import 'package:auth/core/validator/validator_ext.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_event.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_state.dart';
import 'package:auth/features/auth/presentation/utils/auth_fail_ext.dart';
import 'package:auth/features/auth/presentation/widgets/auth_button.dart';
import 'package:auth/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:auth/features/auth/presentation/widgets/otp_cell.dart';
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

  final FocusNode _otpFocusNode = FocusNode();

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
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (BuildContext context, ForgotPasswordState state) {
            if (state.step == ForgotPasswordStep.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  duration: const Duration(seconds: 3),
                  margin: const EdgeInsets.only(
                    bottom: 24,
                    left: 24,
                    right: 24,
                  ),
                  content: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.passwordResetSuccess,
                            style: const TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (BuildContext context, ForgotPasswordState state) {
            final bool isError = state.failure != null;

            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 16),
                    child: IconButton(
                      onPressed: state.isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
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
                        children: <Widget>[
                          const SizedBox(height: 12),
                          if (state.step == ForgotPasswordStep.emailForm)
                            _EmailStepView(emailController: _emailController)
                          else if (state.step == ForgotPasswordStep.otpForm)
                            _OtpStepView(
                              otpController: _otpController,
                              otpFocusNode: _otpFocusNode,
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
                          const SizedBox(height: 30),
                          AuthButton(
                            text: state.step == ForgotPasswordStep.emailForm
                                ? l10n.buttonContinue
                                : state.step == ForgotPasswordStep.otpForm
                                ? l10n.buttonVerify
                                : l10n.buttonSavePassword,
                            isLoading: state.isLoading,
                            isActive: state.isButtonActive,
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (state.step ==
                                    ForgotPasswordStep.emailForm) {
                                  context.read<ForgotPasswordBloc>().add(
                                    ForgotPasswordEmailSubmitted(),
                                  );
                                } else if (state.step ==
                                    ForgotPasswordStep.otpForm) {
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
                        ],
                      ),
                    ),
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
          validator: (String? v) => v.toEmailError(context),
        ),
      ],
    );
  }
}

class _OtpStepView extends StatelessWidget {
  final TextEditingController otpController;
  final ForgotPasswordState state;
  final FocusNode otpFocusNode;
  const _OtpStepView({
    required this.otpController,
    required this.state,
    required this.otpFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.enterCodeTitle,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterCodeSubtitle,
          style: const TextStyle(fontSize: 15, color: Color(0xFF949494)),
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                otpFocusNode.requestFocus();
                SystemChannels.textInput.invokeMethod('TextInput.show');
              },
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.0,
                    child: AuthTextField(
                      controller: otpController,
                      focusNode: otpFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      autofocus: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (int i) {
                      final bool isFocused =
                          (state.otp.length == i) ||
                          (state.otp.length == 4 && i == 3);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OtpCell(
                          char: state.otp.length > i ? state.otp[i] : '',
                          isFocused: isFocused,
                          hasError: state.failure != null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (state.failure != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                state.failure!.toLocalizeString(context),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
          ),
        const SizedBox(height: 22),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: state.isTimerRunning
                    ? null
                    : () {
                        otpController.clear();
                        context.read<ForgotPasswordBloc>().add(
                          ForgotPasswordResendOtpRequested(),
                        );
                      },
                child: Text(
                  l10n.linkResendCode,
                  style: TextStyle(
                    color: state.isTimerRunning
                        ? AppColors.buttonInactive
                        : AppColors.buttonActive,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 45,
                child: Text(
                  "00:${state.timerSeconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    color: Color(0xFF949494),
                    fontSize: 15,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordStepView extends StatefulWidget {
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
  State<_ResetPasswordStepView> createState() => _ResetPasswordStepViewState();
}

class _ResetPasswordStepViewState extends State<_ResetPasswordStepView> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
          controller: widget.passwordController,
          hintText: l10n.hintPassword,
          enabled: !widget.isLoading,
          isError: widget.isError,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          validator: (String? v) => v.toPasswordError(context),
          onChanged: (v) => context.read<ForgotPasswordBloc>().add(
            ForgotPasswordResetFieldsChanged(
              v,
              widget.confirmPasswordController.text,
            ),
          ),
          icon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.labelRepeatPassword,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: widget.confirmPasswordController,
          hintText: l10n.hintPassword,
          enabled: !widget.isLoading,
          isError: widget.isError,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          validator: (String? v) {
            if (v != widget.passwordController.text) {
              return l10n.errorPasswordsDoNotMatch;
            }
            return null;
          },
          onChanged: (v) => context.read<ForgotPasswordBloc>().add(
            ForgotPasswordResetFieldsChanged(widget.passwordController.text, v),
          ),
          icon: IconButton(
            icon: Icon(
              _obscureConfirm ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
      ],
    );
  }
}
