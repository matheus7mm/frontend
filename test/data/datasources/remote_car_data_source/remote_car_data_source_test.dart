import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:frontend/data/datasources/remote_car_data_source.dart';
import 'package:frontend/data/models/car_model.dart';

import 'remote_car_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late RemoteCarDataSource remoteCarDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    remoteCarDataSource = RemoteCarDataSource(mockDio);
  });

  group('RemoteCarDataSource', () {
    const carJson = {'id': 1, 'name': 'Tesla', 'model': 'Model S'};
    final carModel = CarModel.fromJson(carJson);

    test('should fetch list of cars on successful API call', () async {
      // Arrange
      when(mockDio.get('/cars')).thenAnswer(
        (_) async => Response(
          data: [carJson],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cars'),
        ),
      );

      // Act
      final result = await remoteCarDataSource.getCars();

      // Assert
      expect(result, [carModel.toDomain()]);
      verify(mockDio.get('/cars')).called(1);
    });

    test('should throw an exception on unsuccessful getCars call', () async {
      // Arrange
      when(mockDio.get('/cars')).thenAnswer(
        (_) async => Response(
          data: 'Error',
          statusCode: 404,
          requestOptions: RequestOptions(path: '/cars'),
        ),
      );

      // Act & Assert
      expect(remoteCarDataSource.getCars(), throwsException);
    });

    test('should create a car on successful API call', () async {
      // Arrange
      when(mockDio.post('/cars', data: {'name': 'Tesla', 'model': 'Model S'}))
          .thenAnswer(
        (_) async => Response(
          data: carJson,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/cars'),
        ),
      );

      // Act
      final result = await remoteCarDataSource.createCar('Tesla', 'Model S');

      // Assert
      expect(result, carModel.toDomain());
      verify(mockDio.post('/cars', data: {'name': 'Tesla', 'model': 'Model S'}))
          .called(1);
    });

    test('should throw an exception on unsuccessful createCar call', () async {
      // Arrange
      when(mockDio.post('/cars', data: {'name': 'Tesla', 'model': 'Model S'}))
          .thenAnswer(
        (_) async => Response(
          data: 'Error',
          statusCode: 400,
          requestOptions: RequestOptions(path: '/cars'),
        ),
      );

      // Act & Assert
      expect(() => remoteCarDataSource.createCar('Tesla', 'Model S'),
          throwsException);
    });

    test('should update a car on successful API call', () async {
      // Arrange
      when(mockDio.put('/cars/1', data: {'name': 'Tesla', 'model': 'Model S'}))
          .thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cars/1'),
        ),
      );

      // Act
      await remoteCarDataSource.updateCar(1, 'Tesla', 'Model S');

      // Assert
      verify(mockDio.put('/cars/1',
          data: {'name': 'Tesla', 'model': 'Model S'})).called(1);
    });

    test('should delete a car on successful API call', () async {
      // Arrange
      when(mockDio.delete('/cars/1')).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cars/1'),
        ),
      );

      // Act
      await remoteCarDataSource.deleteCar(1);

      // Assert
      verify(mockDio.delete('/cars/1')).called(1);
    });
  });
}
