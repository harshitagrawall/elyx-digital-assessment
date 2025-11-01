import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/connectivity_bloc/connectivity_bloc.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users.dart';
import '../bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => UserBloc(getUsers: sl()));

  // Connectivity Bloc
  sl.registerLazySingleton(() => ConnectivityBloc());

  // Use cases
  sl.registerLazySingleton(() => GetUsers(repository: sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(client: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
}
