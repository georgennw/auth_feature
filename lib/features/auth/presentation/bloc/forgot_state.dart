import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

enum ForgotPasswordStep { emailForm, otpForm, resetPasswordForm, success }

class ForgotPasswordState extends Equatable {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final ForgotPasswordStep step;
  final bool isLoading;
  final bool isButtonActive;
  final AuthFailure? failure;
  final int timerSeconds;

  const ForgotPasswordState({
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.step = ForgotPasswordStep.emailForm,
    this.isLoading = false,
    this.isButtonActive = false,
    this.failure,
    this.timerSeconds = 0,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    ForgotPasswordStep? step,
    bool? isLoading,
    bool? isButtonActive,
    AuthFailure? failure,
    int? timerSeconds,
    bool clearFailure = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      isButtonActive: isButtonActive ?? this.isButtonActive,
      failure: clearFailure ? null : (failure ?? this.failure),
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    email,
    otp,
    newPassword,
    confirmPassword,
    step,
    isLoading,
    isButtonActive,
    failure,
    timerSeconds,
  ];
}
