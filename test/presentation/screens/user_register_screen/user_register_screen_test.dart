import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:frontend/presentation/presenters/presenters.dart';
import 'package:frontend/presentation/screens/screens.dart';
import 'package:frontend/presentation/screens/widgets/widgets.dart';
import 'package:frontend/domain/domain.dart';

import 'user_register_screen_test.mocks.dart';

@GenerateMocks([UserRegisterBloc])
void main() {
  late MockUserRegisterBloc mockUserRegisterBloc;

  setUp(() {
    mockUserRegisterBloc = MockUserRegisterBloc();
    when(mockUserRegisterBloc.stream)
        .thenAnswer((_) => const Stream<UserRegisterState>.empty());
    when(mockUserRegisterBloc.state).thenReturn(UserRegisterInitial());
  });

  tearDown(() {
    mockUserRegisterBloc.close();
  });

  Widget createWidgetUnderTest() {
    final goRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => UserRegisterScreen(),
        ),
        GoRoute(
          path: '/car_list',
          builder: (context, state) =>
              const Scaffold(body: Text('Car List Screen')),
        ),
      ],
    );

    return BlocProvider<UserRegisterBloc>.value(
      value: mockUserRegisterBloc,
      child: MaterialApp.router(routerConfig: goRouter),
    );
  }

  group('UserRegisterScreen', () {
    testWidgets(
        'renders email, phone, and password fields and initially disabled register button',
        (WidgetTester tester) async {
      when(mockUserRegisterBloc.state).thenReturn(UserRegisterInitial());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CustomTextField), findsNWidgets(3));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      final GradientButton gradientButton =
          tester.widget<GradientButton>(find.byType(GradientButton));
      expect(gradientButton.onTap, isNull);
    });

    testWidgets('enables register button when valid inputs are entered',
        (WidgetTester tester) async {
      when(mockUserRegisterBloc.state).thenReturn(
        const UserRegisterValidationState(
          isFormValid: true,
          fieldValidities: {
            'email': true,
            'phoneNumber': true,
            'password': true,
          },
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(
          find.byWidgetPredicate(
              (widget) => widget is CustomTextField && widget.label == 'Email'),
          'test@example.com');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField && widget.label == 'Phone Number'),
          '1234567890');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField && widget.label == 'Password'),
          'password123');
      await tester.pumpAndSettle();

      final gradientButton =
          tester.widget<GradientButton>(find.byType(GradientButton));
      expect(gradientButton.onTap, isNotNull);
    });

    testWidgets(
        'displays error messages for invalid email, phone, and password inputs',
        (WidgetTester tester) async {
      when(mockUserRegisterBloc.state).thenReturn(
        const UserRegisterValidationState(
          isFormValid: false,
          fieldValidities: {
            'email': false,
            'phoneNumber': false,
            'password': false,
          },
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.enterText(
          find.byWidgetPredicate(
              (widget) => widget is CustomTextField && widget.label == 'Email'),
          'invalid-email');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField && widget.label == 'Phone Number'),
          '123');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField && widget.label == 'Password'),
          '123');
      await tester.pumpAndSettle();

      expect(find.text('Invalid email'), findsOneWidget);
      expect(find.text('Invalid phone number'), findsOneWidget);
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('shows error message when registration fails',
        (WidgetTester tester) async {
      const errorMessage = 'Registration failed';
      when(mockUserRegisterBloc.stream).thenAnswer(
          (_) => Stream.value(const UserRegisterFailure(errorMessage)));
      when(mockUserRegisterBloc.state)
          .thenReturn(const UserRegisterFailure(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('navigates to car list on successful registration',
        (WidgetTester tester) async {
      const mockUser =
          User(id: 1, email: 'test@example.com', token: 'mock_token');
      when(mockUserRegisterBloc.stream)
          .thenAnswer((_) => Stream.value(const UserRegisterSuccess(mockUser)));
      when(mockUserRegisterBloc.state)
          .thenReturn(const UserRegisterSuccess(mockUser));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Car List Screen'), findsOneWidget);
    });
  });
}
