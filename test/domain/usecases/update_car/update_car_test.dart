import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart';
import 'update_car_test.mocks.dart';

@GenerateMocks([CarRepository])
void main() {
  late UpdateCar updateCar;
  late MockCarRepository mockCarRepository;

  setUp(() {
    GetIt.instance.registerSingleton<CarRepository>(MockCarRepository());
    mockCarRepository = GetIt.instance<CarRepository>() as MockCarRepository;
    updateCar = UpdateCar(mockCarRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('UpdateCar', () {
    const carId = 1;
    const updatedName = 'Tesla Model X';
    const updatedModel = '2024';

    test(
        'should call updateCar on the repository with correct id, name, and model',
        () async {
      // Arrange
      when(mockCarRepository.updateCar(carId, updatedName, updatedModel))
          .thenAnswer((_) async => {});

      // Act
      await updateCar(carId, updatedName, updatedModel);

      // Assert
      verify(mockCarRepository.updateCar(carId, updatedName, updatedModel))
          .called(1);
    });

    test('should throw an exception when update fails', () async {
      // Arrange
      when(mockCarRepository.updateCar(carId, updatedName, updatedModel))
          .thenThrow(Exception('Update failed'));

      // Act & Assert
      expect(
        () async => await updateCar(carId, updatedName, updatedModel),
        throwsA(isA<Exception>()
            .having((e) => e.toString(), 'message', contains('Update failed'))),
      );
      verify(mockCarRepository.updateCar(carId, updatedName, updatedModel))
          .called(1);
    });
  });
}
