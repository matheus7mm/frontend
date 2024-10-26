import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get_it/get_it.dart';

import 'package:frontend/domain/domain.dart';
import 'get_cars_test.mocks.dart';

@GenerateMocks([CarRepository])
void main() {
  late GetCars getCars;
  late MockCarRepository mockCarRepository;

  setUp(() {
    GetIt.instance.registerSingleton<CarRepository>(MockCarRepository());
    mockCarRepository = GetIt.instance<CarRepository>() as MockCarRepository;
    getCars = GetCars(mockCarRepository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('GetCars', () {
    const cars = [Car(id: 1, name: 'Tesla', model: 'Model S')];

    test('should return a list of cars from the repository', () async {
      // Arrange
      when(mockCarRepository.getCars()).thenAnswer((_) async => cars);

      // Act
      final result = await getCars();

      // Assert
      expect(result, equals(cars));
      verify(mockCarRepository.getCars()).called(1);
    });

    test('should throw an exception when retrieval fails', () async {
      // Arrange
      when(mockCarRepository.getCars())
          .thenThrow(Exception('Retrieval failed'));

      // Act & Assert
      expect(
        () async => await getCars(),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Retrieval failed'))),
      );
      verify(mockCarRepository.getCars()).called(1);
    });
  });
}
