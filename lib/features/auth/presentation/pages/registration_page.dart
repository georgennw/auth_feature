import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/validator/validator.dart';
import 'package:auth/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/registration_event.dart';
import 'package:auth/features/auth/presentation/bloc/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  String? _gender;
  bool _isButtonActive = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _ageController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_validateForm);
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _ageController.removeListener(_validateForm);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final l10n = AppLocalizations.of(context)!;
    final validator = context.read<Validator>();

    final isUsernameValid = _usernameController.text.trim().isNotEmpty;
    final isEmailValid =
        validator.email(_emailController.text.trim(), l10n) == null;
    final isPasswordValid =
        validator.password(_passwordController.text, l10n) == null;
    final isGenderValid = (_gender ?? '').isNotEmpty;
    final isAgeValid = _ageController.text.trim().isNotEmpty;

    final next =
        isUsernameValid &&
        isEmailValid &&
        isPasswordValid &&
        isGenderValid &&
        isAgeValid;

    if (next != _isButtonActive) {
      setState(() => _isButtonActive = next);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final gender = _gender ?? '';
    context.read<RegistrationBloc>().add(
      RegistrationSubmitted(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: gender,
        age: _ageController.text.trim(),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hintText,
    Widget? suffixIcon,
    bool isServerError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
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

    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isLoading = state is RegistrationLoading;
        final isError = state is RegistrationError;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
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
                            const SizedBox(height: 10),
                          IconButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.providePersonalInfo,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            l10n.username,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameController,
                            enabled: !isLoading,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.errUsernameRequired
                                : null,
                            decoration: _fieldDecoration(
                              hintText: l10n.hintUsername,
                              isServerError: isError,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            l10n.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            enabled: !isLoading,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => validator.email(v, l10n),
                            decoration: _fieldDecoration(
                              hintText: l10n.hintEmail,
                              isServerError: isError,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                l10n.password,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Tooltip(
                                message: l10n.passwordTooltip,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                triggerMode: TooltipTriggerMode.tap,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF5FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue.shade100,
                                  ),
                                ),
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !isLoading,
                            obscureText: !_showPassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => validator.password(v, l10n),
                            decoration: _fieldDecoration(
                              hintText: l10n.hintPassword,
                              isServerError: isError,
                              suffixIcon: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            l10n.gender,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _gender,
                            items: [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text(l10n.genderMale),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(l10n.genderFemale),
                              ),
                              DropdownMenuItem(
                                value: 'other',
                                child: Text(l10n.genderOther),
                              ),
                            ],
                            onChanged: isLoading
                                ? null
                                : (v) {
                                    setState(() => _gender = v);
                                    _validateForm();
                                  },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => (v == null || v.isEmpty)
                                ? l10n.errGenderRequired
                                : null,
                            decoration: _fieldDecoration(
                              hintText: l10n.hintGender,
                              isServerError: isError,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.age,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _ageController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? l10n.errAgeRequired
                                : null,
                            decoration: _fieldDecoration(
                              hintText: l10n.hintAge,
                              isServerError: isError,
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
                                  l10n.register,
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
                            l10n.textAlreadyHaveAccount,
                            style: const TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: Text(
                              l10n.linkSignIn,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
