import 'package:auth/core/utils/result.dart';
import 'package:auth/features/auth/domain/usecases/sign_in_usecases.dart';
import 'package:auth/features/auth/presentation/%20bloc/sign_in_event.dart';
import 'package:auth/features/auth/presentation/%20bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUsecase _signInUsecase;

  SignInBloc(this._signInUsecase) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    final result = await _signInUsecase(
      email: event.email,
      pass: event.password,
    );

    switch (result) {
      case Success(value: final user):
        emit(SignInSuccess(user));
      case FailureResult(failure: final failure):
        emit(SignInError(failure));
    }
  }
}
