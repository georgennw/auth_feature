import 'package:equatable/equatable.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {}

class ForgotPasswordOtpChanged extends ForgotPasswordEvent {
  final String otp;
  const ForgotPasswordOtpChanged(this.otp);
  @override
  List<Object?> get props => [otp];
}

class ForgotPasswordOtpSubmitted extends ForgotPasswordEvent {}

class ForgotPasswordResendOtpRequested extends ForgotPasswordEvent {}

class ForgotPasswordResetFieldsChanged extends ForgotPasswordEvent {
  final String newPassword;
  final String confirmPassword;
  const ForgotPasswordResetFieldsChanged(
    this.newPassword,
    this.confirmPassword,
  );
  @override
  List<Object?> get props => [newPassword, confirmPassword];
}

class ForgotPasswordResetSubmitted extends ForgotPasswordEvent {}

class ForgotPasswordTimerTicked extends ForgotPasswordEvent {
  final int seconds;
  const ForgotPasswordTimerTicked(this.seconds);
  @override
  List<Object?> get props => [seconds];
}

class ForgotPasswordReset extends ForgotPasswordEvent {
  const ForgotPasswordReset();
}
