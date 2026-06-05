import 'package:equatable/equatable.dart';

sealed class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationSubmitted extends RegistrationEvent {
  final String username;
  final String email;
  final String password;
  final String gender;
  final String age;

  RegistrationSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.age,
  });

  @override
  List<Object?> get props => [username, email, password, gender, age];
}