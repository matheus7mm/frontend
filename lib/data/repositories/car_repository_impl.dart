import '../datasources/remote_car_data_source.dart';

import './../../domain/repositories/car_repository.dart';
import './../../domain/entities/entities.dart';

class CarRepositoryImpl implements CarRepository {
  final RemoteCarDataSource remoteDataSource;

  CarRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Car>> getCars() async {
    return remoteDataSource.getCars();
  }

  @override
  Future<Car> createCar(String name, String model) async {
    return remoteDataSource.createCar(name, model);
  }

  @override
  Future<void> updateCar(int id, String name, String model) async {
    return remoteDataSource.updateCar(id, name, model);
  }

  @override
  Future<void> deleteCar(int id) async {
    return remoteDataSource.deleteCar(id);
  }
}
