import 'package:dio/dio.dart';

// domain layer
import './../../domain/entities/entities.dart';

// data layer
import '../models/user_model.dart';

class RemoteUserDataSource {
  final Dio dio;

  RemoteUserDataSource(this.dio);

  Future<User> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {
      'identifier': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data).toDomain();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> register(String email, String password,
      {String? phoneNumber}) async {
    final response = await dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
    });

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data).toDomain();
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<User> loginWithToken(String token) async {
    final response = await dio.get('/auth/me',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data).toDomain();
    } else {
      throw Exception('Failed to authenticate with token');
    }
  }
}
