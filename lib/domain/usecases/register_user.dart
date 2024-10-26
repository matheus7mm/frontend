import './../entities/entities.dart';
import './../repositories/repositories.dart';

class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  Future<User> call(String email, String password, {String? phoneNumber}) {
    return repository.register(email, password, phoneNumber: phoneNumber);
  }
}
