import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/presentation/presenters/presenters.dart';
import 'package:frontend/domain/domain.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([LoginUser, SaveToken, GetToken])
void main() {
  late AuthBloc authBloc;
  late MockLoginUser mockLoginUser;
  late MockSaveToken mockSaveToken;
  late MockGetToken mockGetToken;

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockSaveToken = MockSaveToken();
    mockGetToken = MockGetToken();

    authBloc = AuthBloc(
      loginUser: mockLoginUser,
      saveToken: mockSaveToken,
      getToken: mockGetToken,
    );
  });

  group('AuthBloc - Login', () {
    const email = 'test@example.com';
    const password = 'password123';

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(mockLoginUser.call(email, password)).thenAnswer(
            (_) async => const User(id: 1, email: email, token: 'mock_token'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(email, password)),
      expect: () => [
        AuthLoading(),
        const AuthSuccess(User(id: 1, email: email, token: 'mock_token')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(mockLoginUser.call(email, password))
            .thenThrow(Exception('Login failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(email, password)),
      expect: () => [
        AuthLoading(),
        const AuthFailure('Exception: Login failed'),
      ],
    );
  });

  group('AuthBloc - Validation', () {
    blocTest<AuthBloc, AuthState>(
      'emits ValidationState with isFormValid = false when fields are invalid',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthValidationChangedEvent(fields: {
        'identifier': '',
        'password': '123',
      })),
      expect: () => [
        const ValidationState(
          isFormValid: false,
          fieldValidities: {
            'identifier': false,
            'password': false,
          },
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits ValidationState with isFormValid = true when fields are valid',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthValidationChangedEvent(fields: {
        'identifier': 'valid@example.com',
        'password': 'validPass123',
      })),
      expect: () => [
        const ValidationState(
          isFormValid: true,
          fieldValidities: {
            'identifier': true,
            'password': true,
          },
        ),
      ],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] and saves token on successful login',
    build: () {
      when(mockLoginUser.call(any, any)).thenAnswer(
        (_) async =>
            const User(id: 1, email: 'test@example.com', token: 'mock_token'),
      );
      return authBloc;
    },
    act: (bloc) =>
        bloc.add(const LoginEvent('test@example.com', 'password123')),
    expect: () => [
      AuthLoading(),
      const AuthSuccess(
          User(id: 1, email: 'test@example.com', token: 'mock_token')),
    ],
    verify: (_) {
      verify(mockSaveToken.call('mock_token')).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] on successful auto-login with token',
    build: () {
      when(mockGetToken.call()).thenAnswer((_) async => 'mock_token');
      when(mockLoginUser.withToken('mock_token')).thenAnswer(
        (_) async =>
            const User(id: 1, email: 'test@example.com', token: 'mock_token'),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(AutoLoginEvent()),
    expect: () => [
      AuthLoading(),
      const AuthSuccess(
          User(id: 1, email: 'test@example.com', token: 'mock_token')),
    ],
    verify: (_) {
      verify(mockGetToken.call()).called(1);
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure] if token-based auto-login fails',
    build: () {
      when(mockGetToken.call()).thenAnswer((_) async => 'invalid_token');
      when(mockLoginUser.withToken('invalid_token'))
          .thenThrow(Exception('Failed to authenticate with token'));
      return authBloc;
    },
    act: (bloc) => bloc.add(AutoLoginEvent()),
    expect: () => [
      AuthLoading(),
      const AuthFailure('Exception: Failed to authenticate with token'),
    ],
    verify: (_) {
      verify(mockGetToken.call()).called(1);
      verifyNever(mockSaveToken.call(any));
    },
  );

  blocTest<AuthBloc, AuthState>(
    'emits ValidationState with correct validation on AuthValidationChangedEvent',
    build: () => authBloc,
    act: (bloc) => bloc.add(const AuthValidationChangedEvent(
        fields: {'identifier': 'validUser', 'password': 'validPass123'})),
    expect: () => [
      const ValidationState(
        isFormValid: true,
        fieldValidities: {'identifier': true, 'password': true},
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits ValidationState with invalid form on AuthValidationChangedEvent',
    build: () => authBloc,
    act: (bloc) => bloc.add(const AuthValidationChangedEvent(
        fields: {'identifier': '', 'password': 'short'})),
    expect: () => [
      const ValidationState(
        isFormValid: false,
        fieldValidities: {'identifier': false, 'password': false},
      ),
    ],
  );
}
