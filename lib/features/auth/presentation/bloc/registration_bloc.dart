import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth/features/auth/presentation/bloc/registration_event.dart';
import 'package:auth/features/auth/presentation/bloc/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUseCase _registerUsecase;

  RegistrationBloc(this._registerUsecase) : super(RegistrationInitial()) {
    on<RegistrationSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());
    final result = await _registerUsecase(
      username: event.username,
      email: event.email,
      pass: event.password,
      gender: event.gender,
      age: event.age,
    );

    switch (result) {
      case Success(value: final user):
        emit(RegistrationSuccess(user));
      case FailureResult(failure: final failure):
        emit(RegistrationError(failure));
    }
  }
}
