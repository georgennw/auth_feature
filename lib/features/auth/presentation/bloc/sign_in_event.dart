import 'package:auth/core/l10n/app_localizations.dart';
import 'package:equatable/equatable.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
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
  final AppLocalizations l10n;

  const SignInFieldsChanged({
    required this.email,
    required this.password,
    required this.l10n,
  });

  @override
  List<Object?> get props => [email, password, l10n];
}
