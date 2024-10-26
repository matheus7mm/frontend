import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/domain/domain.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group('UserRepository Interface', () {
    const testUser =
        User(id: 1, email: 'test@example.com', token: 'mock_token');

    test('should define login method', () {
      when(mockUserRepository.login('test@example.com', 'password'))
          .thenAnswer((_) async => testUser); // Return a valid User instance

      expect(() => mockUserRepository.login('test@example.com', 'password'),
          returnsNormally);
    });

    test('should define register method', () {
      when(mockUserRepository.register('newuser@example.com', 'password123'))
          .thenAnswer((_) async => testUser); // Return a valid User instance

      expect(
          () =>
              mockUserRepository.register('newuser@example.com', 'password123'),
          returnsNormally);
    });

    test('should define register method with phoneNumber', () {
      when(mockUserRepository.register('newuser@example.com', 'password123',
              phoneNumber: '+123456789'))
          .thenAnswer((_) async => testUser); // Return a valid User instance

      expect(
          () => mockUserRepository.register(
              'newuser@example.com', 'password123',
              phoneNumber: '+123456789'),
          returnsNormally);
    });
  });
}
