import 'package:dio/dio.dart';

class DioProvider {
  static Dio createDio({bool useMocks = false}) {
    Dio dio = Dio();
    dio.options.baseUrl = 'https://your-api-url.com/api';
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    if (useMocks) {
      dio.interceptors.add(MockApiInterceptor());
    }

    return dio;
  }
}

class MockApiInterceptor extends Interceptor {
  static List<Map<String, dynamic>> users = [
    {
      'id': 1,
      'email': 'matheus7mm@hotmail.com',
      'password': '123456',
      'token': 'mock_token'
    },
    {
      'id': 2,
      'email': 'super.jean.lais@gmail.com',
      'password': '123456',
      'token': 'new_mock_token'
    },
  ];

  static List<Map<String, dynamic>> cars = [
    {'id': 1, 'name': 'Tesla Model S', 'model': '2021'},
    {'id': 2, 'name': 'Ford Mustang', 'model': '2020'},
  ];

  int _generateId(List<Map<String, dynamic>> list) {
    return list.isEmpty
        ? 1
        : list
                .map((item) => item['id'] as int)
                .reduce((a, b) => a > b ? a : b) +
            1;
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == '/auth/login' && options.method == 'POST') {
      await Future.delayed(const Duration(seconds: 1));
      final identifier = options.data['identifier'];
      final password = options.data['password'];
      try {
        final user = users.firstWhere((user) =>
            (user['email'] == identifier || user['phone'] == identifier) &&
            user['password'] == password);

        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'id': user['id'],
              'email': user['email'],
              'token': user['token']
            },
          ),
        );
      } catch (e) {
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 401,
            data: {'message': 'Invalid credentials'},
          ),
        );
      }
    }

    if (options.path == '/auth/register' && options.method == 'POST') {
      final newUser = {
        'id': _generateId(users),
        'email': options.data['email'],
        'password': options.data['password'],
        'token': 'generated_token_${options.data['email']}',
      };
      users.add(newUser);

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: {
            'id': newUser['id'],
            'email': newUser['email'],
            'token': newUser['token'],
          },
        ),
      );
    }

    if (options.path == '/cars' && options.method == 'GET') {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: cars,
        ),
      );
    }

    if (options.path == '/cars' && options.method == 'POST') {
      final newCar = {
        'id': _generateId(cars),
        'name': options.data['name'],
        'model': options.data['model'],
      };
      cars.add(newCar);

      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 201,
          data: newCar,
        ),
      );
    }

    if (options.path.startsWith('/cars/') && options.method == 'PUT') {
      final carId = int.parse(options.path.split('/').last);
      final index = cars.indexWhere((car) => car['id'] == carId);
      if (index != -1) {
        cars[index] = {
          'id': carId,
          'name': options.data['name'],
          'model': options.data['model'],
        };
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: cars[index],
          ),
        );
      } else {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 404,
              data: {'message': 'Car not found'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }

    if (options.path.startsWith('/cars/') && options.method == 'DELETE') {
      final carId = int.parse(options.path.split('/').last);
      cars.removeWhere((car) => car['id'] == carId);
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 204,
        ),
      );
    }

    if (options.path == '/auth/me' && options.method == 'GET') {
      final authToken = options.headers['Authorization']?.split(' ')?.last;
      try {
        final user = users.firstWhere((user) => user['token'] == authToken);

        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'id': user['id'],
              'email': user['email'],
              'token': user['token']
            },
          ),
        );
      } catch (e) {
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'message': 'Invalid token'},
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }
    }

    super.onRequest(options, handler);
  }
}
