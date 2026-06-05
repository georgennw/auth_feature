import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {}
class SignInLoading extends SignInState {}
class SignInSuccess extends SignInState {
  final User user;
  SignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class SignInError extends SignInState {
  final AuthFailure failure;
  SignInError(this.failure);

  @override
  List<Object?> get props => [failure];
}
