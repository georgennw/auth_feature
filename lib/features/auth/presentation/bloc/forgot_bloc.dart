import 'dart:async';

import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator_rules.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/usecases/forgot_usecase.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_event.dart';
import 'package:auth/features/auth/presentation/bloc/forgot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _useCase;
  StreamSubscription<int>? _timerSubscription;

  ForgotPasswordBloc(this._useCase) : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);
    on<ForgotPasswordOtpChanged>(_onOtpChanged);
    on<ForgotPasswordOtpSubmitted>(_onOtpSubmitted);
    on<ForgotPasswordResendOtpRequested>(_onResendOtp);
    on<ForgotPasswordResetFieldsChanged>(_onResetFieldsChanged);
    on<ForgotPasswordResetSubmitted>(_onResetSubmitted);
    on<ForgotPasswordTimerTicked>(_onTimerTicked);
    on<ForgotPasswordReset>(_onReset);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.email,
        isButtonActive: event.email.isValidEmail,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _useCase.sendOtp(state.email);

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isLoading: false,
            step: ForgotPasswordStep.otpForm,
            isButtonActive: false,
          ),
        );
        _startTimer();
      case FailureResult(failure: final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  void _onOtpChanged(
    ForgotPasswordOtpChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        otp: event.otp,
        isButtonActive: event.otp.isValidOtp,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onOtpSubmitted(
    ForgotPasswordOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _useCase.verifyOtp(state.email, state.otp);

    switch (result) {
      case Success():
        _timerSubscription?.cancel();
        emit(
          state.copyWith(
            isLoading: false,
            step: ForgotPasswordStep.resetPasswordForm,
            isButtonActive: false,
          ),
        );
      case FailureResult(failure: final AuthFailure failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  void _onResendOtp(
    ForgotPasswordResendOtpRequested event,
    Emitter<ForgotPasswordState> emit,
  ) {
    if (state.timerSeconds > 0) return;
    _useCase.sendOtp(state.email);
    _startTimer();
  }

  void _onResetFieldsChanged(
    ForgotPasswordResetFieldsChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final bool isPasswordValid = event.newPassword.isValidPassword;
    final bool isMatching = event.newPassword == event.confirmPassword;

    emit(
      state.copyWith(
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        isButtonActive: isPasswordValid && isMatching,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onResetSubmitted(
    ForgotPasswordResetSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _useCase.resetPassword(
      email: state.email,
      code: state.otp,
      newPassword: state.newPassword,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(isLoading: false, step: ForgotPasswordStep.success),
        );
      case FailureResult(failure: final failure):
        emit(state.copyWith(isLoading: false, failure: failure));
    }
  }

  void _onTimerTicked(
    ForgotPasswordTimerTicked event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(timerSeconds: event.seconds));
  }

  void _startTimer() {
    _timerSubscription?.cancel();
    _timerSubscription = Stream<int>.periodic(
      const Duration(seconds: 1),
      (x) => 59 - x,
    ).take(60).listen((seconds) => add(ForgotPasswordTimerTicked(seconds)));
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}

void _onReset(ForgotPasswordReset event, Emitter<ForgotPasswordState> emit) {
  emit(const ForgotPasswordState());
}
