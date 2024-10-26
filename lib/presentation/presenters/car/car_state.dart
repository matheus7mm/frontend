import 'package:equatable/equatable.dart';
import '../../../domain/entities/car.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarSuccess extends CarState {
  final List<Car> cars;

  const CarSuccess(this.cars);

  @override
  List<Object> get props => [cars];
}

class CarFailure extends CarState {
  final String error;

  const CarFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CarValidationState extends CarState {
  final bool isFormValid;
  final Map<String, bool> fieldValidities;

  const CarValidationState({
    required this.isFormValid,
    required this.fieldValidities,
  });

  @override
  List<Object> get props => [isFormValid, fieldValidities];
}

class CarLogoutSuccess extends CarState {}
