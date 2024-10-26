import './../repositories/repositories.dart';

class DeleteCar {
  final CarRepository repository;

  DeleteCar(this.repository);

  Future<void> call(int id) {
    return repository.deleteCar(id);
  }
}
