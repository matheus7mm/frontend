import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart';
import 'login_user_test.mocks.dart';

// Annotate with GenerateMocks to generate the mock class
@GenerateMocks([UserRepository])
void main() {
  late LoginUser loginUser;
  late UserRepository mockUserRepository;

  setUp(() {
    // Registering the mock in GetIt for dependency resolution
    GetIt.instance.registerSingleton<UserRepository>(MockUserRepository());
    mockUserRepository = GetIt.instance<UserRepository>() as MockUserRepository;

    // Initializing LoginUser with the mock repository
    loginUser = LoginUser(mockUserRepository);
  });

  tearDown(() {
    GetIt.instance.reset(); // Clean up GetIt registrations after each test
  });

  group('LoginUser', () {
    const email = 'test@example.com';
    const password = 'password123';
    var user = const User(
      id: 1,
      email: email,
      token: 'mock_token',
    );

    test('should call login on the repository with correct email and password',
        () async {
      // Arrange
      when(mockUserRepository.login(email, password))
          .thenAnswer((_) async => user);

      // Act
      final result = await loginUser(email, password);

      // Assert
      expect(result, equals(user));
      verify(mockUserRepository.login(email, password)).called(1);
    });

    test('should throw an exception when login fails', () async {
      // Arrange
      when(mockUserRepository.login(email, password))
          .thenThrow(Exception('Login failed'));

      // Act & Assert
      expect(
        () async => await loginUser(email, password),
        throwsA(isA<Exception>()
            .having((e) => e.toString(), 'message', contains('Login failed'))),
      );
      verify(mockUserRepository.login(email, password)).called(1);
    });
  });
}
