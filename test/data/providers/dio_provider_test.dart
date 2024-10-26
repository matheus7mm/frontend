import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'package:frontend/data/providers/providers.dart';

void main() {
  group('DioProvider', () {
    test('createDio should configure Dio with the correct base URL and headers',
        () {
      // Act
      final dio = DioProvider.createDio();

      // Assert
      expect(dio.options.baseUrl, 'https://your-api-url.com/api');
      expect(dio.options.headers['Content-Type'], 'application/json');
    });

    test('createDio should return a Dio instance', () {
      // Act
      final dio = DioProvider.createDio();

      // Assert
      expect(dio, isA<Dio>());
    });
  });
}
