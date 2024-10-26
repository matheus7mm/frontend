import './../entities/entities.dart';
import './../repositories/repositories.dart';

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<User> call(String email, String identifier) {
    return repository.login(email, identifier);
  }

  Future<User> withToken(String token) {
    return repository.loginWithToken(token);
  }
}
