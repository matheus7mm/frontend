import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/repositories.dart';

class TokenRepositoryImpl implements TokenRepository {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
