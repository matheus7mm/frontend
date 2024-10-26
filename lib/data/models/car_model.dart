import './../../domain/entities/entities.dart';

class CarModel {
  final int id;
  final String name;
  final String model;

  CarModel({
    required this.id,
    required this.name,
    required this.model,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
    };
  }

  Car toDomain() {
    return Car(
      id: id,
      name: name,
      model: model,
    );
  }
}
