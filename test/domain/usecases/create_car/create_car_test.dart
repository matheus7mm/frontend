import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart'; //
import 'create_car_test.mocks.dart';

@GenerateMocks([CarRepository])
void main() {
  late CreateCar createCar;
  late MockCarRepository mockCarRepository;

  setUp(() {
    // Register the mock repository in GetIt
    GetIt.instance.registerSingleton<CarRepository>(MockCarRepository());
    mockCarRepository = GetIt.instance<CarRepository>() as MockCarRepository;

    // Initialize CreateCar with the mock repository
    createCar = CreateCar(mockCarRepository);
  });

  tearDown(() {
    GetIt.instance.reset(); // Clean up GetIt registrations after each test
  });

  group('CreateCar', () {
    const carName = 'Tesla Model S';
    const carModel = '2023';
    const car = Car(id: 1, name: carName, model: carModel);

    test('should call createCar on the repository with correct name and model',
        () async {
      // Arrange
      when(mockCarRepository.createCar(carName, carModel))
          .thenAnswer((_) async => car);

      // Act
      final result = await createCar(carName, carModel);

      // Assert
      expect(result, equals(car));
      verify(mockCarRepository.createCar(carName, carModel)).called(1);
    });

    test('should throw an exception when creating car fails', () async {
      // Arrange
      when(mockCarRepository.createCar(carName, carModel))
          .thenThrow(Exception('Creation failed'));

      // Act & Assert
      expect(
        () async => await createCar(carName, carModel),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Creation failed'))),
      );
      verify(mockCarRepository.createCar(carName, carModel)).called(1);
    });
  });
}
