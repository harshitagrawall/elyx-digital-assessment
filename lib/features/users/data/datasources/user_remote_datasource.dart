import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/secure_storeage.dart';
import '../models/user_model.dart';

class UserResponseModel {
  final List<UserModel> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponseModel({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['data'] as List<dynamic>;
    final users = usersJson.map((u) => UserModel.fromJson(u)).toList();

    return UserResponseModel(
      users: users,
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}

abstract class UserRemoteDataSource {
  Future<UserResponseModel> getUsers({int page = 1, int perPage = 6});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final SecureStorage secureStorage = SecureStorage();

  static const String baseUrl = 'https://reqres.in/api/users';

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserResponseModel> getUsers({int page = 1, int perPage = 6}) async {
    final apiKey = await secureStorage.readApiKey();
    if (apiKey == null) throw Exception('API key not set');

    final uri = Uri.parse('$baseUrl?page=$page&per_page=$perPage');

    final response = await client.get(uri, headers: {
      'x-api-key': apiKey,
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return UserResponseModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
