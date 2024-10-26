import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart';
import 'delete_car_test.mocks.dart';

@GenerateMocks([CarRepository])
void main() {
  late DeleteCar deleteCar;
  late MockCarRepository mockCarRepository;

  setUp(() {
    GetIt.instance.registerSingleton<CarRepository>(MockCarRepository());
    mockCarRepository = GetIt.instance<CarRepository>() as MockCarRepository;
    deleteCar = DeleteCar(mockCarRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('DeleteCar', () {
    const carId = 1;

    test('should call deleteCar on the repository with correct id', () async {
      // Arrange
      when(mockCarRepository.deleteCar(carId)).thenAnswer((_) async => {});

      // Act
      await deleteCar(carId);

      // Assert
      verify(mockCarRepository.deleteCar(carId)).called(1);
    });

    test('should throw an exception when deletion fails', () async {
      // Arrange
      when(mockCarRepository.deleteCar(carId))
          .thenThrow(Exception('Deletion failed'));

      // Act & Assert
      expect(
        () async => await deleteCar(carId),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Deletion failed'))),
      );
      verify(mockCarRepository.deleteCar(carId)).called(1);
    });
  });
}
