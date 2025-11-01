import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_response.dart';
import '../datasources/user_remote_datasource.dart';
import '../../../../core/network/network_info.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<UserResponse> getUsers({int page = 1, int perPage = 6}) async {
    if (await networkInfo.isConnected) {
      final responseModel = await remoteDataSource.getUsers(page: page, perPage: perPage);

      final users = responseModel.users.map((model) => User(
        id: model.id,
        email: model.email,
        firstName: model.firstName,
        lastName: model.lastName,
        avatar: model.avatar,
      )).toList();

      return UserResponse(
        users: users,
        page: responseModel.page,
        perPage: responseModel.perPage,
        total: responseModel.total,
        totalPages: responseModel.totalPages,
      );
    } else {
      throw Exception('No internet connection');
    }
  }
}
