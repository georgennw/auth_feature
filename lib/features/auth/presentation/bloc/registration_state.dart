import 'package:auth/features/auth/domain/entities/user.dart';
import 'package:auth/features/auth/domain/failure/auth_failure.dart';
import 'package:equatable/equatable.dart';

sealed class RegistrationState extends Equatable {
  final bool isButtonActive;
  final String selectedGender;

  const RegistrationState({
    this.isButtonActive = false,
    this.selectedGender = '',
  });

  RegistrationState copyWith({bool? isButtonActive, String? selectedGender});
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial({super.isButtonActive, super.selectedGender});

  @override
  RegistrationInitial copyWith({bool? isButtonActive, String? selectedGender}) {
    return RegistrationInitial(
      isButtonActive: isButtonActive ?? this.isButtonActive,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => <Object?>[isButtonActive, selectedGender];
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading({super.isButtonActive, super.selectedGender});

  @override
  RegistrationLoading copyWith({bool? isButtonActive, String? selectedGender}) {
    return RegistrationLoading(
      isButtonActive: isButtonActive ?? this.isButtonActive,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => <Object?>[isButtonActive, selectedGender];
}

class RegistrationSuccess extends RegistrationState {
  final User user;

  const RegistrationSuccess(
    this.user, {
    super.isButtonActive,
    super.selectedGender,
  });

  @override
  RegistrationSuccess copyWith({bool? isButtonActive, String? selectedGender}) {
    return RegistrationSuccess(
      user,
      isButtonActive: isButtonActive ?? this.isButtonActive,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => <Object?>[user, isButtonActive, selectedGender];
}

class RegistrationError extends RegistrationState {
  final AuthFailure failure;

  const RegistrationError(
    this.failure, {
    super.isButtonActive,
    super.selectedGender,
  });

  @override
  RegistrationError copyWith({bool? isButtonActive, String? selectedGender}) {
    return RegistrationError(
      failure,
      isButtonActive: isButtonActive ?? this.isButtonActive,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  @override
  List<Object?> get props => <Object?>[failure, isButtonActive, selectedGender];
}
