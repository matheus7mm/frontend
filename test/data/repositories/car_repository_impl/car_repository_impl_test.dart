import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:frontend/data/repositories/car_repository_impl.dart';
import 'package:frontend/data/datasources/remote_car_data_source.dart';
import 'package:frontend/domain/entities/car.dart';

import 'car_repository_impl_test.mocks.dart';

@GenerateMocks([RemoteCarDataSource])
void main() {
  late CarRepositoryImpl carRepository;
  late MockRemoteCarDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteCarDataSource();
    carRepository = CarRepositoryImpl(mockRemoteDataSource);
  });

  group('CarRepositoryImpl', () {
    const car = Car(id: 1, name: 'Tesla', model: 'Model S');

    test('should fetch a list of cars from data source', () async {
      // Arrange
      when(mockRemoteDataSource.getCars()).thenAnswer((_) async => [car]);

      // Act
      final result = await carRepository.getCars();

      // Assert
      expect(result, [car]);
      verify(mockRemoteDataSource.getCars()).called(1);
    });

    test('should create a car using data source', () async {
      // Arrange
      when(mockRemoteDataSource.createCar('Tesla', 'Model S'))
          .thenAnswer((_) async => car);

      // Act
      final result = await carRepository.createCar('Tesla', 'Model S');

      // Assert
      expect(result, car);
      verify(mockRemoteDataSource.createCar('Tesla', 'Model S')).called(1);
    });

    test('should update a car using data source', () async {
      // Arrange
      when(mockRemoteDataSource.updateCar(1, 'Tesla', 'Model X'))
          .thenAnswer((_) async => Future.value());

      // Act
      await carRepository.updateCar(1, 'Tesla', 'Model X');

      // Assert
      verify(mockRemoteDataSource.updateCar(1, 'Tesla', 'Model X')).called(1);
    });

    test('should delete a car using data source', () async {
      // Arrange
      when(mockRemoteDataSource.deleteCar(1))
          .thenAnswer((_) async => Future.value());

      // Act
      await carRepository.deleteCar(1);

      // Assert
      verify(mockRemoteDataSource.deleteCar(1)).called(1);
    });
  });
}
