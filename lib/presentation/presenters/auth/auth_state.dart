import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ValidationState extends AuthState {
  final bool isFormValid;
  final Map<String, bool> fieldValidities;

  const ValidationState({
    required this.isFormValid,
    required this.fieldValidities,
  });

  @override
  List<Object?> get props => [isFormValid, fieldValidities];
}
