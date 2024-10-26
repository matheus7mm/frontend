import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:frontend/domain/domain.dart';

import 'car_repository_test.mocks.dart';

@GenerateMocks([CarRepository])
void main() {
  late MockCarRepository mockCarRepository;

  setUp(() {
    mockCarRepository = MockCarRepository();
  });

  group('CarRepository Interface', () {
    const testCar = Car(id: 1, name: 'Test Car', model: 'Model X');

    test('should define getCars method', () {
      when(mockCarRepository.getCars()).thenAnswer((_) async => [testCar]);

      expect(() => mockCarRepository.getCars(), returnsNormally);
    });

    test('should define createCar method', () {
      when(mockCarRepository.createCar('Test Car', 'Model X'))
          .thenAnswer((_) async => testCar);

      expect(() => mockCarRepository.createCar('Test Car', 'Model X'),
          returnsNormally);
    });

    test('should define updateCar method', () {
      when(mockCarRepository.updateCar(1, 'Updated Car', 'Model Y'))
          .thenAnswer((_) async => Future.value());

      expect(() => mockCarRepository.updateCar(1, 'Updated Car', 'Model Y'),
          returnsNormally);
    });

    test('should define deleteCar method', () {
      when(mockCarRepository.deleteCar(1))
          .thenAnswer((_) async => Future.value());

      expect(() => mockCarRepository.deleteCar(1), returnsNormally);
    });
  });
}
