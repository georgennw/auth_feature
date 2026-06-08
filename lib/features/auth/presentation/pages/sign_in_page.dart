import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/validator/validator.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_state.dart';
import 'package:auth/features/auth/presentation/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final l10n = AppLocalizations.of(context)!;
    final validator = context.read<Validator>();

    final isEmailValid =
        validator.email(_emailController.text.trim(), l10n) == null;
    final isPasswordValid =
        validator.password(_passwordController.text, l10n) == null;

    if ((isEmailValid && isPasswordValid) != _isButtonActive) {
      setState(() {
        _isButtonActive = isEmailValid && isPasswordValid;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignInBloc>().add(
        SignInSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    bool isServerError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isServerError ? Colors.red.shade400 : Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final validator = context.read<Validator>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            final isLoading = state is SignInLoading;
            final isError = state is SignInError;
            return Column(
              children: [
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
                          if (isError)
                            _buildErrorBanner(state.failure.message)
                          else
                            const SizedBox(height: 20),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            enabled: !isLoading,
                            validator: (value) => validator.email(value, l10n),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: _fieldDecoration(
                              hintText: l10n.hintEmail,
                              isServerError: isError,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.labelPassword,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !isLoading,
                            obscureText: true,
                            validator: (value) =>
                                validator.password(value, l10n),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                _fieldDecoration(
                                  hintText: l10n.hintPassword,
                                  isServerError: isError,
                                ).copyWith(
                                  suffixIcon: const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RegistrationPage(),
                                      ),
                                    ),
                              child: Text(
                                l10n.linkForgotPassword,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                              ),
                            ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isButtonActive
                                      ? const Color(0xFF007FFF)
                                      : const Color(
                                          0xFF90CFFF,
                                        ).withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _isButtonActive ? _submit : null,
                                child: Text(
                                  l10n.buttonSignIn,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.textDontHaveAccount,
                            style: const TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (context) => RegistrationBloc(
                                          context.read<RegisterUseCase>(),
                                        ),
                                        child: const RegistrationPage(),
                                      ),
                                    ),
                                  ),
                            child: Text(
                              l10n.linkRegister,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE53E3E), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFE53E3E),
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
