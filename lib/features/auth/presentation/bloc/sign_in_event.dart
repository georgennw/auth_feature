import 'package:equatable/equatable.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  const SignInSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInFieldsChanged extends SignInEvent {
  final String email;
  final String password;

  const SignInFieldsChanged({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
