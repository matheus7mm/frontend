import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/data/repositories/user_repository_impl.dart';
import 'package:frontend/data/datasources/remote_user_data_source.dart';
import 'package:frontend/domain/entities/user.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteUserDataSource])
void main() {
  late UserRepositoryImpl userRepository;
  late MockRemoteUserDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteUserDataSource();
    userRepository = UserRepositoryImpl(mockRemoteDataSource);
  });

  group('UserRepositoryImpl', () {
    const user = User(id: 1, email: 'test@example.com', token: 'token123');

    test('should log in a user using data source', () async {
      // Arrange
      when(mockRemoteDataSource.login('test@example.com', 'password'))
          .thenAnswer((_) async => user);

      // Act
      final result = await userRepository.login('test@example.com', 'password');

      // Assert
      expect(result, user);
      verify(mockRemoteDataSource.login('test@example.com', 'password'))
          .called(1);
    });

    test('should register a user using data source', () async {
      // Arrange
      when(mockRemoteDataSource.register('newuser@example.com', 'password123',
              phoneNumber: '+123456789'))
          .thenAnswer((_) async => user);

      // Act
      final result = await userRepository.register(
          'newuser@example.com', 'password123',
          phoneNumber: '+123456789');

      // Assert
      expect(result, user);
      verify(mockRemoteDataSource.register('newuser@example.com', 'password123',
              phoneNumber: '+123456789'))
          .called(1);
    });
  });
}
