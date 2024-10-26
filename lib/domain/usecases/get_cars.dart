import './../entities/entities.dart';
import './../repositories/repositories.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Future<List<Car>> call() {
    return repository.getCars();
  }
}
