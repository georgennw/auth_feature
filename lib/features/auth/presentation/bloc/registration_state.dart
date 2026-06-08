import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

sealed class RegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final User user;
  RegistrationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegistrationError extends RegistrationState {
  final AuthFailure failure;
  RegistrationError(this.failure);

  @override
  List<Object?> get props => [failure];
}
