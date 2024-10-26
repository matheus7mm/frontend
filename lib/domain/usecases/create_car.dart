import './../entities/entities.dart';
import './../repositories/repositories.dart';

class CreateCar {
  final CarRepository repository;

  CreateCar(this.repository);

  Future<Car> call(String name, String model) {
    return repository.createCar(name, model);
  }
}
