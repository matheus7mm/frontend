import 'package:equatable/equatable.dart';

abstract class UserRegisterEvent extends Equatable {
  const UserRegisterEvent();
}

class RegisterEvent extends UserRegisterEvent {
  final String email;
  final String password;
  final String? phoneNumber;

  const RegisterEvent({
    required this.email,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, phoneNumber];
}

class ValidationChangedEvent extends UserRegisterEvent {
  final Map<String, String> fields;

  const ValidationChangedEvent({required this.fields});

  @override
  List<Object> get props => [fields];
}
