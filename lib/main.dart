import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'core/utils/secure_storeage.dart';
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/pages/user_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  final secureStorage = SecureStorage();
  await secureStorage.writeApiKey('reqres-free-v1');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<UserBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User List with Pagination',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: UserListScreen(),
      ),
    );
  }
}
