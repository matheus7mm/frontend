import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final int id;
  final String name;
  final String model;

  const Car({
    required this.id,
    required this.name,
    required this.model,
  });

  @override
  List<Object?> get props => [id, name, model];
}
