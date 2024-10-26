import '../repositories/repositories.dart';

class ClearToken {
  final TokenRepository repository;

  ClearToken(this.repository);

  Future<void> call() async {
    await repository.clearToken();
  }
}
