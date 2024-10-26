import 'package:dio/dio.dart';

// domain layer
import '../../domain/entities/car.dart';

// data layer
import '../models/car_model.dart';

class RemoteCarDataSource {
  final Dio dio;

  RemoteCarDataSource(this.dio);

  Future<List<Car>> getCars() async {
    final response = await dio.get('/cars');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((carData) => CarModel.fromJson(carData).toDomain())
          .toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }

  Future<Car> createCar(String name, String model) async {
    final response = await dio.post('/cars', data: {
      'name': name,
      'model': model,
    });

    if (response.statusCode == 201) {
      return CarModel.fromJson(response.data).toDomain();
    } else {
      throw Exception('Failed to create car');
    }
  }

  Future<void> updateCar(int id, String name, String model) async {
    await dio.put('/cars/$id', data: {
      'name': name,
      'model': model,
    });
  }

  Future<void> deleteCar(int id) async {
    await dio.delete('/cars/$id');
  }
}
