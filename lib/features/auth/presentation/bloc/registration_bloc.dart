import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/presentation/bloc/registration_event.dart';
import 'package:auth/features/auth/presentation/bloc/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUseCase _registerUseCase;
  final Validator _validator;

  RegistrationBloc(this._registerUseCase, this._validator)
    : super(const RegistrationInitial()) {
    on<RegistrationFieldsChanged>(_onFieldsChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  void _onFieldsChanged(
    RegistrationFieldsChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final bool isUsernameValid = event.username.trim().isNotEmpty;
    final bool isEmailValid = _validator.isEmailValid(event.email);
    final bool isPasswordValid = _validator.isPasswordValid(event.password);
    final bool isGenderValid = event.gender.isNotEmpty;
    final bool isAgeValid = event.age.trim().isNotEmpty;

    final bool isActive =
        isUsernameValid &&
        isEmailValid &&
        isPasswordValid &&
        isGenderValid &&
        isAgeValid;

    emit(state.copyWith(isButtonActive: isActive));
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading(isButtonActive: state.isButtonActive));

    final result = await _registerUseCase.execute(
      username: event.username,
      email: event.email,
      pass: event.password,
      gender: event.gender,
      age: event.age,
    );

    switch (result) {
      case Success(value: final user):
        emit(RegistrationSuccess(user, isButtonActive: state.isButtonActive));
      case FailureResult(failure: final failure):
        emit(RegistrationError(failure, isButtonActive: state.isButtonActive));
    }
  }
}
