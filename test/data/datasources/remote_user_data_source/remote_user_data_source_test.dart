import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:frontend/data/datasources/remote_user_data_source.dart';
import 'package:frontend/data/models/user_model.dart';

import 'remote_user_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late RemoteUserDataSource remoteUserDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    remoteUserDataSource = RemoteUserDataSource(mockDio);
  });

  group('RemoteUserDataSource', () {
    const userJson = {
      'id': 1,
      'email': 'test@example.com',
      'token': 'token123'
    };
    final userModel = UserModel.fromJson(userJson);

    test('should log in a user on successful API call', () async {
      // Arrange
      when(mockDio.post('/auth/login',
              data: {'identifier': 'test@example.com', 'password': 'password'}))
          .thenAnswer(
        (_) async => Response(
          data: userJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );

      // Act
      final result =
          await remoteUserDataSource.login('test@example.com', 'password');

      // Assert
      expect(result, userModel.toDomain());
      verify(mockDio.post('/auth/login',
              data: {'identifier': 'test@example.com', 'password': 'password'}))
          .called(1);
    });

    test('should throw an exception on unsuccessful login call', () async {
      // Arrange
      when(mockDio.post('/auth/login',
              data: {'identifier': 'test@example.com', 'password': 'password'}))
          .thenAnswer(
        (_) async => Response(
          data: 'Error',
          statusCode: 401,
          requestOptions: RequestOptions(path: '/auth/login'),
        ),
      );

      // Act & Assert
      expect(() => remoteUserDataSource.login('test@example.com', 'password'),
          throwsException);
    });

    test('should register a user on successful API call', () async {
      // Arrange
      when(mockDio.post('/auth/register', data: {
        'email': 'newuser@example.com',
        'password': 'password123',
        'phone_number': '+123456789'
      })).thenAnswer(
        (_) async => Response(
          data: userJson,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/auth/register'),
        ),
      );

      // Act
      final result = await remoteUserDataSource.register(
          'newuser@example.com', 'password123',
          phoneNumber: '+123456789');

      // Assert
      expect(result, userModel.toDomain());
      verify(mockDio.post('/auth/register', data: {
        'email': 'newuser@example.com',
        'password': 'password123',
        'phone_number': '+123456789'
      })).called(1);
    });

    test('should throw an exception on unsuccessful register call', () async {
      // Arrange
      when(mockDio.post('/auth/register', data: {
        'email': 'newuser@example.com',
        'password': 'password123',
        'phone_number': '+123456789'
      })).thenAnswer(
        (_) async => Response(
          data: 'Error',
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/register'),
        ),
      );

      // Act & Assert
      expect(
          () => remoteUserDataSource.register(
              'newuser@example.com', 'password123',
              phoneNumber: '+123456789'),
          throwsException);
    });
  });
}
