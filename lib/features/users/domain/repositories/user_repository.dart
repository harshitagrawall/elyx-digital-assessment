
import '../entities/user_response.dart';

abstract class UserRepository {
  Future<UserResponse> getUsers({int page = 1, int perPage = 6});
}
