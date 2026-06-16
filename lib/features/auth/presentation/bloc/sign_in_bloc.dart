import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator_rules.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _signInUsecase;

  SignInBloc(this._signInUsecase)
    : super(const SignInInitial()) {
    on<SignInFieldsChanged>(_onFieldsChanged);
    on<SignInSubmitted>(_onSubmitted);
  }

  void _onFieldsChanged(SignInFieldsChanged event, Emitter<SignInState> emit) {
    final bool isEmailValid = event.email.isValidEmail;
    final bool isPasswordValid = event.password.isValidPassword;
    final bool isActive = isEmailValid && isPasswordValid;

    emit(SignInInitial(isButtonActive: isActive));
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading(isButtonActive: state.isButtonActive));

    final Result<User, AuthFailure> result = await _signInUsecase.execute(
      email: event.email,
      pass: event.password,
    );

    switch (result) {
      case Success(value: final User user):
        emit(SignInSuccess(user, isButtonActive: state.isButtonActive));
      case FailureResult(failure: final AuthFailure failure):
        emit(SignInError(failure, isButtonActive: state.isButtonActive));
    }
  }
}
