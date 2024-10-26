import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart';
import 'register_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late RegisterUser registerUser;
  late MockUserRepository mockUserRepository;

  setUp(() {
    GetIt.instance.registerSingleton<UserRepository>(MockUserRepository());
    mockUserRepository = GetIt.instance<UserRepository>() as MockUserRepository;
    registerUser = RegisterUser(mockUserRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('RegisterUser', () {
    const email = 'newuser@example.com';
    const password = 'password123';
    const user = User(id: 2, email: email, token: 'new_token');

    test(
        'should call register on the repository with correct email and password',
        () async {
      // Arrange
      when(mockUserRepository.register(email, password))
          .thenAnswer((_) async => user);

      // Act
      final result = await registerUser(email, password);

      // Assert
      expect(result, equals(user));
      verify(mockUserRepository.register(email, password)).called(1);
    });

    test('should throw an exception when registration fails', () async {
      // Arrange
      when(mockUserRepository.register(email, password))
          .thenThrow(Exception('Registration failed'));

      // Act & Assert
      expect(
        () async => await registerUser(email, password),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Registration failed'))),
      );
      verify(mockUserRepository.register(email, password)).called(1);
    });
  });
}
