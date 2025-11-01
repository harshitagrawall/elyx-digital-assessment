import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final List<User> filteredUsers;

  UserLoaded({required List<User> users, required List<User> filteredUsers})
      : users = List.unmodifiable(users),
        filteredUsers = List.unmodifiable(filteredUsers);

  @override
  List<Object?> get props => [users, filteredUsers];
}


class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
