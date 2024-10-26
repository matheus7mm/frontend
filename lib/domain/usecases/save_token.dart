import '../repositories/repositories.dart';

class SaveToken {
  final TokenRepository repository;

  SaveToken(this.repository);

  Future<void> call(String token) async {
    await repository.saveToken(token);
  }
}
