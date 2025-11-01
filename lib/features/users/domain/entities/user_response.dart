import 'user.dart';

class UserResponse {
  final List<User> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponse({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });
}
