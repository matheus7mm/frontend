import 'package:equatable/equatable.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

class GetCarsEvent extends CarEvent {}

class AddCarEvent extends CarEvent {
  final String name;
  final String model;

  const AddCarEvent(this.name, this.model);

  @override
  List<Object> get props => [name, model];
}

class UpdateCarEvent extends CarEvent {
  final int id;
  final String name;
  final String model;

  const UpdateCarEvent(this.id, this.name, this.model);

  @override
  List<Object> get props => [id, name, model];
}

class DeleteCarEvent extends CarEvent {
  final int id;

  const DeleteCarEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CarValidationEvent extends CarEvent {
  final String name;
  final String model;

  const CarValidationEvent({required this.name, required this.model});

  @override
  List<Object> get props => [name, model];
}

class LogoutEvent extends CarEvent {}
