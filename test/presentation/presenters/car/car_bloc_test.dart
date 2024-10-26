import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/presentation/presenters/presenters.dart';
import 'package:frontend/domain/domain.dart';

import 'car_bloc_test.mocks.dart';

@GenerateMocks([GetCars, CreateCar, UpdateCar, DeleteCar, ClearToken])
void main() {
  late CarBloc carBloc;
  late MockGetCars mockGetCars;
  late MockCreateCar mockCreateCar;
  late MockUpdateCar mockUpdateCar;
  late MockDeleteCar mockDeleteCar;
  late MockClearToken mockClearToken;

  setUp(() {
    mockGetCars = MockGetCars();
    mockCreateCar = MockCreateCar();
    mockUpdateCar = MockUpdateCar();
    mockDeleteCar = MockDeleteCar();
    mockClearToken = MockClearToken();

    carBloc = CarBloc(
      getCars: mockGetCars,
      createCar: mockCreateCar,
      updateCar: mockUpdateCar,
      deleteCar: mockDeleteCar,
      clearToken: mockClearToken,
    );
  });

  group('CarBloc', () {
    const car = Car(id: 1, name: 'Tesla', model: 'Model S');
    final carList = [car];

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarSuccess] when GetCarsEvent is added and succeeds',
      build: () {
        when(mockGetCars.call()).thenAnswer((_) async => carList);
        return carBloc;
      },
      act: (bloc) => bloc.add(GetCarsEvent()),
      expect: () => [CarLoading(), CarSuccess(carList)],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarFailure] when GetCarsEvent is added and fails',
      build: () {
        when(mockGetCars.call()).thenThrow(Exception('Failed to load cars'));
        return carBloc;
      },
      act: (bloc) => bloc.add(GetCarsEvent()),
      expect: () =>
          [CarLoading(), const CarFailure('Exception: Failed to load cars')],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarValidationState] when CarValidationEvent is added',
      build: () => carBloc,
      act: (bloc) =>
          bloc.add(const CarValidationEvent(name: 'Tesla', model: 'Model S')),
      expect: () => [
        const CarValidationState(
          isFormValid: true,
          fieldValidities: {'name': true, 'model': true},
        ),
      ],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarSuccess] when AddCarEvent is added and succeeds',
      build: () {
        when(mockCreateCar.call('Tesla', 'Model S'))
            .thenAnswer((_) async => car);
        when(mockGetCars.call()).thenAnswer((_) async => carList);
        return carBloc;
      },
      act: (bloc) async {
        bloc.add(const CarValidationEvent(name: 'Tesla', model: 'Model S'));
        await Future.delayed(Duration.zero);
        bloc.add(const AddCarEvent('Tesla', 'Model S'));
      },
      expect: () => [
        const CarValidationState(
          isFormValid: true,
          fieldValidities: {'name': true, 'model': true},
        ),
        CarLoading(),
        CarSuccess(carList),
      ],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarFailure] when AddCarEvent fails',
      build: () {
        when(mockCreateCar.call('Tesla', 'Model S'))
            .thenThrow(Exception('Failed to create car'));
        return carBloc;
      },
      act: (bloc) async {
        bloc.add(const CarValidationEvent(name: 'Tesla', model: 'Model S'));
        await Future.delayed(Duration.zero);
        bloc.add(const AddCarEvent('Tesla', 'Model S'));
      },
      expect: () => [
        const CarValidationState(
          isFormValid: true,
          fieldValidities: {'name': true, 'model': true},
        ),
        CarLoading(),
        const CarFailure('Exception: Failed to create car'),
      ],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarSuccess] when UpdateCarEvent is added and succeeds',
      build: () {
        when(mockUpdateCar.call(1, 'Tesla', 'Model X'))
            .thenAnswer((_) async => car);
        when(mockGetCars.call()).thenAnswer((_) async => carList);
        return carBloc;
      },
      act: (bloc) async {
        bloc.add(const CarValidationEvent(name: 'Tesla', model: 'Model X'));
        await Future.delayed(Duration.zero);
        bloc.add(const UpdateCarEvent(1, 'Tesla', 'Model X'));
      },
      expect: () => [
        const CarValidationState(
          isFormValid: true,
          fieldValidities: {'name': true, 'model': true},
        ),
        CarLoading(),
        CarSuccess(carList),
      ],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarFailure] when UpdateCarEvent fails',
      build: () {
        when(mockUpdateCar.call(1, 'Tesla', 'Model X'))
            .thenThrow(Exception('Failed to update car'));
        return carBloc;
      },
      act: (bloc) async {
        bloc.add(const CarValidationEvent(name: 'Tesla', model: 'Model X'));
        await Future.delayed(Duration.zero);
        bloc.add(const UpdateCarEvent(1, 'Tesla', 'Model X'));
      },
      expect: () => [
        const CarValidationState(
          isFormValid: true,
          fieldValidities: {'name': true, 'model': true},
        ),
        CarLoading(),
        const CarFailure('Exception: Failed to update car'),
      ],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarSuccess] when DeleteCarEvent is added and succeeds',
      build: () {
        when(mockDeleteCar.call(1))
            .thenAnswer((_) async => Future<void>.value());
        when(mockGetCars.call()).thenAnswer((_) async => carList);
        return carBloc;
      },
      act: (bloc) => bloc.add(const DeleteCarEvent(1)),
      expect: () => [CarLoading(), CarSuccess(carList)],
    );

    blocTest<CarBloc, CarState>(
      'emits [CarLoading, CarFailure] when DeleteCarEvent fails',
      build: () {
        when(mockDeleteCar.call(1))
            .thenThrow(Exception('Failed to delete car'));
        return carBloc;
      },
      act: (bloc) => bloc.add(const DeleteCarEvent(1)),
      expect: () =>
          [CarLoading(), const CarFailure('Exception: Failed to delete car')],
    );

    // New test for LogoutEvent
    blocTest<CarBloc, CarState>(
      'emits [CarLogoutSuccess] when LogoutEvent is added and succeeds',
      build: () {
        when(mockClearToken.call())
            .thenAnswer((_) async => Future<void>.value());
        return carBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [CarLogoutSuccess()],
      verify: (_) {
        verify(mockClearToken.call()).called(1); // Verify token is cleared
      },
    );

    blocTest<CarBloc, CarState>(
      'emits [CarFailure] when LogoutEvent fails',
      build: () {
        when(mockClearToken.call()).thenThrow(Exception('Failed to logout'));
        return carBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [const CarFailure('Failed to logout')],
    );
  });
}
