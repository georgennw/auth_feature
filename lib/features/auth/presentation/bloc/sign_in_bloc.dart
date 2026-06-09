import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _signInUsecase;
  final Validator _validator;

  SignInBloc(this._signInUsecase, this._validator)
    : super(const SignInInitial()) {
    on<SignInFieldsChanged>(_onFieldsChanged);
    on<SignInSubmitted>(_onSubmitted);
  }

  void _onFieldsChanged(SignInFieldsChanged event, Emitter<SignInState> emit) {
    final isEmailValid = _validator.isEmailValid(event.email);
    final isPasswordValid = _validator.isPasswordValid(event.password);
    final isActive = isEmailValid && isPasswordValid;

    emit(state.copyWith(isButtonActive: isActive));
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading(isButtonActive: state.isButtonActive));

    final result = await _signInUsecase.execute(
      email: event.email,
      pass: event.password,
    );

    switch (result) {
      case Success(value: final user):
        emit(SignInSuccess(user, isButtonActive: state.isButtonActive));
      case FailureResult(failure: final failure):
        emit(SignInError(failure, isButtonActive: state.isButtonActive));
    }
  }
}
