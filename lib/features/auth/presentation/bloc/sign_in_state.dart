import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SignInState extends Equatable {
  final bool isButtonActive;

  const SignInState({this.isButtonActive = false});

  SignInState copyWith({bool? isButtonActive});

  @override
  List<Object?> get props => <Object?>[isButtonActive];
}

class SignInInitial extends SignInState {
  const SignInInitial({super.isButtonActive});

  @override
  SignInInitial copyWith({bool? isButtonActive}) {
    return SignInInitial(isButtonActive: isButtonActive ?? this.isButtonActive);
  }
}

class SignInLoading extends SignInState {
  const SignInLoading({super.isButtonActive});

  @override
  SignInLoading copyWith({bool? isButtonActive}) {
    return SignInLoading(isButtonActive: isButtonActive ?? this.isButtonActive);
  }
}

class SignInSuccess extends SignInState {
  final User user;

  const SignInSuccess(this.user, {super.isButtonActive});

  @override
  SignInSuccess copyWith({bool? isButtonActive}) {
    return SignInSuccess(
      user,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => <Object?>[user, isButtonActive];
}

class SignInError extends SignInState {
  final AuthFailure failure;

  const SignInError(this.failure, {super.isButtonActive});

  @override
  SignInError copyWith({bool? isButtonActive}) {
    return SignInError(
      failure,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => <Object?>[failure, isButtonActive];
}
