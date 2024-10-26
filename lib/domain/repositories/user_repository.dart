import '../entities/user.dart';

abstract class UserRepository {
  Future<User> login(String identifier, String password);
  Future<User> register(String email, String password, {String? phoneNumber});
  Future<User> loginWithToken(String token);
}
