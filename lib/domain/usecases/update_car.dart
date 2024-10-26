import './../repositories/repositories.dart';

class UpdateCar {
  final CarRepository repository;

  UpdateCar(this.repository);

  Future<void> call(int id, String name, String model) {
    return repository.updateCar(id, name, model);
  }
}
