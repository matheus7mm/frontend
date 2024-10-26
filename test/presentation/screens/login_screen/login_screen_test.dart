import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/presentation/presentation.dart';
import 'package:frontend/presentation/screens/widgets/widgets.dart';
import 'package:frontend/domain/domain.dart';
import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // Start with an empty stream and AuthInitial state
    when(mockAuthBloc.stream)
        .thenAnswer((_) => const Stream<AuthState>.empty());
    when(mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createWidgetUnderTest() {
    final goRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/car_list',
          builder: (context, state) =>
              const Scaffold(body: Text('Car List Screen')),
        ),
      ],
    );

    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp.router(routerConfig: goRouter),
    );
  }

  group('LoginScreen', () {
    testWidgets('enables login button when valid inputs are entered',
        (WidgetTester tester) async {
      // Stub the AuthBloc stream with an initial state and a validation state
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.fromIterable([
            AuthInitial(),
            const ValidationState(
              isFormValid: true,
              fieldValidities: {
                'identifier': true,
                'password': true,
              },
            )
          ]));

      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid inputs to trigger validation
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField &&
              widget.label == 'Email or Phone Number'),
          'test@example.com');
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CustomTextField && widget.label == 'Password'),
          'password123');
      await tester.pumpAndSettle();

      // Check if the GradientButton onTap is enabled
      final gradientButton =
          tester.widget<GradientButton>(find.byType(GradientButton));
      expect(gradientButton.onTap, isNotNull);
    });

    testWidgets('shows error message when login fails',
        (WidgetTester tester) async {
      const errorMessage = 'Login failed';
      when(mockAuthBloc.stream)
          .thenAnswer((_) => Stream.value(const AuthFailure(errorMessage)));
      when(mockAuthBloc.state).thenReturn(const AuthFailure(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('navigates to car list on successful login',
        (WidgetTester tester) async {
      const mockUser =
          User(id: 1, email: 'test@example.com', token: 'mock_token');
      when(mockAuthBloc.stream)
          .thenAnswer((_) => Stream.value(const AuthSuccess(mockUser)));
      when(mockAuthBloc.state).thenReturn(const AuthSuccess(mockUser));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Car List Screen'), findsOneWidget);
    });
  });
}
