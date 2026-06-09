import 'package:equatable/equatable.dart';

sealed class AuthFailure extends Equatable {
  const AuthFailure();

  @override
  List<Object?> get props => [];
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure();
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure();
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();
}
