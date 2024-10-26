import './../entities/entities.dart';

abstract class CarRepository {
  Future<List<Car>> getCars();
  Future<Car> createCar(String name, String model);
  Future<void> updateCar(int id, String name, String model);
  Future<void> deleteCar(int id);
}
