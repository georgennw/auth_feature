import 'package:auth/core/l10n/app_localizations.dart';
import 'package:auth/core/theme/app_colors.dart';
import 'package:auth/core/validator/validator_ext.dart';
import 'package:auth/features/auth/presentation/bloc/registration_bloc.dart';
import 'package:auth/features/auth/presentation/bloc/registration_event.dart';
import 'package:auth/features/auth/presentation/bloc/registration_state.dart';
import 'package:auth/features/auth/presentation/utils/auth_fail_ext.dart';
import 'package:auth/features/auth/presentation/widgets/auth_button.dart';
import 'package:auth/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:auth/features/auth/presentation/widgets/error_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onRegistrationFieldsChanged);
    _emailController.addListener(_onRegistrationFieldsChanged);
    _passwordController.addListener(_onRegistrationFieldsChanged);
    _ageController.addListener(_onRegistrationFieldsChanged);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onRegistrationFieldsChanged() {
    context.read<RegistrationBloc>().add(
      RegistrationFieldsChanged(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        gender: context.read<RegistrationBloc>().state.selectedGender,
        age: _ageController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          listener: (BuildContext context, RegistrationState state) {
            if (state is RegistrationSuccess) {
              Navigator.of(context).pop();
            }
          },
          builder: (BuildContext context, RegistrationState state) {
            final bool isLoading = state is RegistrationLoading;
            final bool isError = state is RegistrationError;
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
                      usernameController: _usernameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      ageController: _ageController,
                      selectedGender: state.selectedGender,
                      isLoading: isLoading,
                      isError: isError,
                      errorMessage: errorMessage,
                      onGenderChanged: (String value) {
                        context.read<RegistrationBloc>().add(
                          RegistrationFieldsChanged(
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            gender: value,
                            age: _ageController.text,
                          ),
                        );
                      },
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
                      context.read<RegistrationBloc>().add(
                        RegistrationSubmitted(
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                          gender: state.selectedGender,
                          age: _ageController.text.trim(),
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
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController ageController;
  final String selectedGender;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final ValueChanged<String> onGenderChanged;

  const _FormSection({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.ageController,
    required this.selectedGender,
    required this.isLoading,
    required this.isError,
    required this.errorMessage,
    required this.onGenderChanged,
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
            height: 26,
            child: widget.isError
                ? ErrorBanner(message: widget.errorMessage)
                : null,
          ),
          IconButton(
            onPressed: widget.isLoading
                ? null
                : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.blue),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.usernameController,
            hintText: l10n.hintUsername,
            enabled: !widget.isLoading,
            isError: widget.isError,
            validator: (String? value) => value.toUsernameError(context),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.email,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.emailController,
            hintText: l10n.hintEmail,
            enabled: !widget.isLoading,
            isError: widget.isError,
            validator: (String? value) => value.toEmailError(context),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
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
                margin: const EdgeInsets.symmetric(horizontal: 24),
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  height: 1.3,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.blue,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.passwordController,
            hintText: l10n.hintPassword,
            enabled: !widget.isLoading,
            obscureText: !_showPassword,
            isError: widget.isError,
            validator: (String? value) => value.toPasswordError(context),
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
          const SizedBox(height: 20),
          Text(
            l10n.gender,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: widget.selectedGender.isEmpty
                ? null
                : widget.selectedGender,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: 'male',
                child: Text(l10n.genderMale),
              ),
              DropdownMenuItem<String>(
                value: 'female',
                child: Text(l10n.genderFemale),
              ),
              DropdownMenuItem<String>(
                value: 'other',
                child: Text(l10n.genderOther),
              ),
            ],
            onChanged: widget.isLoading
                ? null
                : (String? v) => widget.onGenderChanged(v ?? ''),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) => value.toGenderError(context),
            decoration: InputDecoration(
              hintText: l10n.hintGender,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.isError
                      ? AppColors.borderError
                      : AppColors.grey400,
                ),
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
          ),
          const SizedBox(height: 20),
          Text(
            l10n.age,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AuthTextField(
            controller: widget.ageController,
            hintText: l10n.hintAge,
            enabled: !widget.isLoading,
            isError: widget.isError,
            validator: (String? value) => value.toAgeError(context),
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
          text: l10n.register,
          isLoading: isLoading,
          isActive: isButtonActive,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              l10n.textAlreadyHaveAccount,
              style: const TextStyle(fontSize: 15),
            ),
            GestureDetector(
              onTap: isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(
                l10n.linkSignIn,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
