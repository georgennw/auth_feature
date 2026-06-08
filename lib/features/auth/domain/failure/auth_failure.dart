import 'package:equatable/equatable.dart';

sealed class AuthFailure extends Equatable {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Wrong login or password');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email already in sue');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User nor found');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('Network failure');
}
