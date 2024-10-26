import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String identifier;
  final String password;

  const LoginEvent(this.identifier, this.password);

  @override
  List<Object> get props => [identifier, password];
}

class AuthValidationChangedEvent extends AuthEvent {
  final Map<String, String> fields;

  const AuthValidationChangedEvent({required this.fields});

  @override
  List<Object> get props => [fields];
}

class AutoLoginEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
