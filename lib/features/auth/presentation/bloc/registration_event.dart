import 'package:equatable/equatable.dart';

sealed class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class RegistrationSubmitted extends RegistrationEvent {
  final String username;
  final String email;
  final String password;
  final String gender;
  final String age;

  const RegistrationSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props => [username, email, password, gender, age];
}

class RegistrationFieldsChanged extends RegistrationEvent {
  final String username;
  final String email;
  final String password;
  final String gender;
  final String age;

  const RegistrationFieldsChanged({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props => [username, email, password, gender, age];
}
