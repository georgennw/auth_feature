import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

sealed class RegistrationState extends Equatable {
  final bool isButtonActive;

  const RegistrationState({this.isButtonActive = false});

  RegistrationState copyWith({bool? isButtonActive});
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial({super.isButtonActive});

  @override
  RegistrationInitial copyWith({bool? isButtonActive}) {
    return RegistrationInitial(
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => [isButtonActive];
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading({super.isButtonActive});

  @override
  RegistrationLoading copyWith({bool? isButtonActive}) {
    return RegistrationLoading(
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => [isButtonActive];
}

class RegistrationSuccess extends RegistrationState {
  final User user;

  const RegistrationSuccess(this.user, {super.isButtonActive});

  @override
  RegistrationSuccess copyWith({bool? isButtonActive}) {
    return RegistrationSuccess(
      user,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => [user, isButtonActive];
}

class RegistrationError extends RegistrationState {
  final AuthFailure failure;

  const RegistrationError(this.failure, {super.isButtonActive});

  @override
  RegistrationError copyWith({bool? isButtonActive}) {
    return RegistrationError(
      failure,
      isButtonActive: isButtonActive ?? this.isButtonActive,
    );
  }

  @override
  List<Object?> get props => [failure, isButtonActive];
}
