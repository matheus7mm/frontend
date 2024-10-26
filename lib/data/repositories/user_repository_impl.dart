import '../datasources/remote_user_data_source.dart';

import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/entities.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteUserDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<User> register(
    String email,
    String password, {
    String? phoneNumber,
  }) async {
    return remoteDataSource.register(email, password, phoneNumber: phoneNumber);
  }

  @override
  Future<User> loginWithToken(String token) async {
    final response = await remoteDataSource.loginWithToken(token);
    return response;
  }
}
