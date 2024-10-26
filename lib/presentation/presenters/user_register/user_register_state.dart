import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

abstract class UserRegisterState extends Equatable {
  const UserRegisterState();

  @override
  List<Object?> get props => [];
}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterLoading extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {
  final User user;

  const UserRegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class UserRegisterFailure extends UserRegisterState {
  final String error;

  const UserRegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UserRegisterValidationState extends UserRegisterState {
  final bool isFormValid;
  final Map<String, bool> fieldValidities;

  const UserRegisterValidationState({
    required this.isFormValid,
    required this.fieldValidities,
  });

  @override
  List<Object?> get props => [isFormValid, fieldValidities];
}
