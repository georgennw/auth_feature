import 'package:auth/core/utils/result.dart';
import 'package:auth/core/validator/validator_rules.dart';
import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/presentation/bloc/registration_event.dart';
import 'package:auth/features/auth/presentation/bloc/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUseCase _registerUseCase;

  RegistrationBloc(this._registerUseCase) : super(const RegistrationInitial()) {
    on<RegistrationFieldsChanged>(_onFieldsChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  void _onFieldsChanged(
    RegistrationFieldsChanged event,
    Emitter<RegistrationState> emit,
  ) {
    final bool isUsernameValid = event.username.isValidUsername;
    final bool isEmailValid = event.email.isValidEmail;
    final bool isPasswordValid = event.password.isValidPassword;
    final bool isGenderValid = event.gender.isValidGender;
    final bool isAgeValid = event.age.isValidAge;

    final bool isActive =
        isUsernameValid &&
        isEmailValid &&
        isPasswordValid &&
        isGenderValid &&
        isAgeValid;

    emit(
      RegistrationInitial(
        isButtonActive: isActive,
        selectedGender: event.gender,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(
      RegistrationLoading(
        isButtonActive: state.isButtonActive,
        selectedGender: state.selectedGender,
      ),
    );

    final Result<User, AuthFailure> result = await _registerUseCase.execute(
      username: event.username,
      email: event.email,
      pass: event.password,
      gender: event.gender,
      age: event.age,
    );

    switch (result) {
      case Success(value: final User user):
        emit(
          RegistrationSuccess(
            user,
            isButtonActive: state.isButtonActive,
            selectedGender: state.selectedGender,
          ),
        );
      case FailureResult(failure: final AuthFailure failure):
        emit(
          RegistrationError(
            failure,
            isButtonActive: state.isButtonActive,
            selectedGender: state.selectedGender,
          ),
        );
    }
  }
}
