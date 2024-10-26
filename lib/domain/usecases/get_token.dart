import '../repositories/repositories.dart';

class GetToken {
  final TokenRepository repository;

  GetToken(this.repository);

  Future<String?> call() async {
    return await repository.getToken();
  }
}
