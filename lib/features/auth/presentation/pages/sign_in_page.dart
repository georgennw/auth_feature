import 'package:auth/features/auth/presentation/%20bloc/sign_in_bloc.dart';
import 'package:auth/features/auth/presentation/%20bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/%20bloc/sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/validator/validator.dart';

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
    final isEmailValid = Validator.email(_emailController.text) == null;
    final isPasswordValid = Validator.password(_passwordController.text) == null;

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
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            final isLoading = state is SignInLoading;
            final isError = state is SignInError;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              if (isError) 
                                _buildErrorBanner(state.failure.message)
                              else 
                                const SizedBox(height: 10),
                              const SizedBox(height: 45,),
                              const Text(
                                "It’s great to see you\ntoday!",
                                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, height: 1.2),
                              ),
                              const SizedBox(height: 40),
                              const Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                enabled: !isLoading,
                                validator: Validator.email,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: isError ? Colors.red.shade400 : Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 137, 189, 231), width: 2.0),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                              const SizedBox(height: 20),

                              const Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                enabled: !isLoading,
                                obscureText: true,
                                validator: Validator.password,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: isError ? Colors.red.shade400 : const Color.fromARGB(255, 86, 82, 82)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 137, 189, 231), width: 2.0),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),
                              const SizedBox(height: 8),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: isLoading ? null : () {},
                                  child: const Text("Forgot password?", style: TextStyle(color: Colors.blue, fontSize: 15)),
                                ),
                              ),
                              const Spacer(), 
                              const SizedBox(height: 20), 
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: isLoading
                                    ? const Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _isButtonActive 
                                              ? const Color(0xFF90CFFF) 
                                              : const Color(0xFF90CFFF).withValues(alpha: 0.7),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                          elevation: 0,
                                        ),
                                        onPressed: _isButtonActive ? _submit : null,
                                        child: const Text(
                                          "Sign in",
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don’t have an account? ", style: TextStyle(fontSize: 15)),
                                  GestureDetector(
                                    onTap: isLoading ? null : () {},
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              style: const TextStyle(color: Color(0xFFE53E3E), fontSize: 15, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}