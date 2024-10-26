import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/presentation/presentation.dart';
import 'package:frontend/domain/domain.dart';
import 'car_list_screen_test.mocks.dart';

@GenerateMocks([CarBloc])
void main() {
  late MockCarBloc mockCarBloc;

  setUp(() {
    mockCarBloc = MockCarBloc();
    when(mockCarBloc.stream).thenAnswer((_) => const Stream<CarState>.empty());
  });

  tearDown(() {
    mockCarBloc.close();
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => CarListScreen(),
        ),
      ],
    );

    return BlocProvider<CarBloc>.value(
      value: mockCarBloc,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('CarListScreen', () {
    testWidgets('displays loading indicator when in CarLoading state',
        (WidgetTester tester) async {
      when(mockCarBloc.state).thenReturn(CarLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when in CarFailure state',
        (WidgetTester tester) async {
      const errorMessage = 'Failed to load cars';
      when(mockCarBloc.state).thenReturn(const CarFailure(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('displays list of cars when in CarSuccess state',
        (WidgetTester tester) async {
      final carList = [
        const Car(id: 1, name: 'Tesla', model: 'Model S'),
        const Car(id: 2, name: 'Ford', model: 'Mustang'),
      ];
      when(mockCarBloc.state).thenReturn(CarSuccess(carList));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Tesla'), findsOneWidget);
      expect(find.text('Model S'), findsOneWidget);
      expect(find.text('Ford'), findsOneWidget);
      expect(find.text('Mustang'), findsOneWidget);
    });

    testWidgets('deletes a car when Delete button is pressed',
        (WidgetTester tester) async {
      final carList = [const Car(id: 1, name: 'Tesla', model: 'Model S')];
      when(mockCarBloc.state).thenReturn(CarSuccess(carList));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      verify(mockCarBloc.add(const DeleteCarEvent(1))).called(1);
    });

    testWidgets('enables Add button when valid inputs are provided',
        (WidgetTester tester) async {
      when(mockCarBloc.state).thenReturn(const CarValidationState(
        isFormValid: true,
        fieldValidities: {'name': true, 'model': true},
      ));

      await tester.pumpWidget(createWidgetUnderTest());

      // Open add dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter car details in the dialog
      await tester.enterText(find.byType(TextField).at(0), 'Tesla');
      await tester.enterText(find.byType(TextField).at(1), 'Model X');
      await tester.pump();

      // Expect the Add button to be enabled and tap it
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pump();

      verify(mockCarBloc.add(const AddCarEvent('Tesla', 'Model X'))).called(1);
    });

    testWidgets(
        'emits validation event and shows error messages for invalid inputs',
        (WidgetTester tester) async {
      when(mockCarBloc.state).thenReturn(const CarValidationState(
        isFormValid: false,
        fieldValidities: {'name': false, 'model': false},
      ));

      await tester.pumpWidget(createWidgetUnderTest());

      // Open add dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Leave fields empty
      await tester.enterText(find.byType(TextField).at(0), '');
      await tester.enterText(find.byType(TextField).at(1), '');
      await tester.pump();

      // Check for error messages
      expect(find.text('Car name is required'), findsOneWidget);
      expect(find.text('Car model is required'), findsOneWidget);

      // Verify that CarValidationEvent was dispatched with empty fields
      verify(mockCarBloc.add(const CarValidationEvent(name: '', model: '')))
          .called(1);
    });
  });
}
