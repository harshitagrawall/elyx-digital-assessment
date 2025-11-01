import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/network/connectivity_bloc/connectivity_bloc.dart';
import 'core/network/connectivity_bloc/connectivity_event.dart';
import 'core/network/network_info.dart';
import 'features/users/data/datasources/user_remote_datasource.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/get_users.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => UserBloc(getUsers: sl()));

  sl.registerLazySingleton(() => ConnectivityBloc(connectivity: sl()));

  sl.registerLazySingleton(() => GetUsers(repository: sl()));

  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => Connectivity());
}
