import '../entities/user_response.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers({required this.repository});

  Future<UserResponse> call({int page = 1, int perPage = 6}) {
    return repository.getUsers(page: page, perPage: perPage);
  }
}
