import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/theme/app_colors.dart';
import 'package:auth/core/validator/validator_ext.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_event.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_state.dart';
import 'package:auth/features/auth/presentation/pages/forgot_page.dart';
import 'package:auth/features/auth/presentation/pages/registration_page.dart';
import 'package:auth/features/auth/presentation/utils/auth_fail_ext.dart';
import 'package:auth/features/auth/presentation/widgets/auth_button.dart';
import 'package:auth/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:auth/features/auth/presentation/widgets/error_banner.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onSignInFieldsChanged);
    _passwordController.addListener(_onSignInFieldsChanged);
  }

  void _onSignInFieldsChanged() {
    context.read<SignInBloc>().add(
      SignInFieldsChanged(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (BuildContext context, SignInState state) {
            final bool isLoading = state is SignInLoading;
            final bool isError = state is SignInError;
            final String errorMessage = isError
                ? state.failure.toLocalizeString(context)
                : '';

            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: _FormSection(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isLoading: isLoading,
                      isError: isError,
                      errorMessage: errorMessage,
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
                  child: _FooterSection(
                    isLoading: isLoading,
                    isButtonActive: state.isButtonActive,
                    onSubmit: () {
                      context.read<SignInBloc>().add(
                        SignInSubmitted(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        ),
                      );
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

class _FormSection extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool isError;
  final String errorMessage;

  const _FormSection({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
  });

  @override
  State<_FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<_FormSection> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 91,
            child: widget.isError
                ? ErrorBanner(message: widget.errorMessage)
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.textSignInTitle,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            l10n.labelEmail,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.emailController,
            hintText: l10n.hintEmail,
            enabled: !widget.isLoading,
            isError: widget.isError,
            textInputAction: TextInputAction.next,
            validator: (String? value) => value.toEmailError(context),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.labelPassword,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.passwordController,
            hintText: l10n.hintPassword,
            enabled: !widget.isLoading,
            obscureText: !_showPassword,
            isError: widget.isError,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.errorPasswordRequired;
              }
              return null;
            },
            icon: IconButton(
              onPressed: widget.isLoading
                  ? null
                  : () => setState(() => _showPassword = !_showPassword),
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      context.read<ForgotPasswordBloc>().add(
                        const ForgotPasswordReset(),
                      );
                      context.read<SignInBloc>().add(
                        const SignInFieldsChanged(email: '', password: ''),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
              child: Text(
                l10n.linkForgotPassword,
                style: const TextStyle(color: AppColors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final bool isLoading;
  final bool isButtonActive;
  final VoidCallback onSubmit;

  const _FooterSection({
    required this.isLoading,
    required this.isButtonActive,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AuthButton(
          text: l10n.buttonSignIn,
          isLoading: isLoading,
          isActive: isButtonActive,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 20),
        AuthButton(
          text: 'Тест Крашлитики',
          isLoading: false,
          isActive: true,
          onPressed: () {
            FirebaseCrashlytics.instance.crash();
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              l10n.textDontHaveAccount,
              style: const TextStyle(fontSize: 15),
            ),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      context.read<SignInBloc>().add(
                        const SignInFieldsChanged(email: '', password: ''),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const RegistrationPage(),
                        ),
                      );
                    },
              child: Text(
                l10n.linkRegister,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
