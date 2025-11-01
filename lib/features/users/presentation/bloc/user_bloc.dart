import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;

  List<User> _allUsers = [];
  int _currentPage = 1;
  int _totalPages = 1;
  final int _perPage = 6;
  bool _isFetching = false;

  String _lastQuery = '';

  UserBloc({required this.getUsers}) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUsers>(_onSearchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
  }

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    _currentPage = 1;
    _allUsers.clear();
    _lastQuery = '';
    try {
      _isFetching = true;
      final response = await getUsers(page: _currentPage, perPage: _perPage);
      _allUsers = response.users;
      _totalPages = response.totalPages;
      _isFetching = false;

      if (_allUsers.isEmpty) {
        emit(UserError(message: 'No users found.'));
      } else {
        // Show all users initially
        emit(UserLoaded(users: _allUsers, filteredUsers: _allUsers));
      }
    } catch (e) {
      _isFetching = false;
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(LoadMoreUsers event, Emitter<UserState> emit) async {
    if (_isFetching) return;
    if (_currentPage >= _totalPages) return;

    _currentPage++;
    try {
      _isFetching = true;
      print('Loading page $_currentPage of $_totalPages');
      final response = await getUsers(page: _currentPage, perPage: _perPage);
      print('Fetched ${response.users.length} users');

      if (response.users.isEmpty) {
        _currentPage--;
      } else {
        _allUsers = List.from(_allUsers)..addAll(response.users);
        _totalPages = response.totalPages;

        // Reapply last search query if any
        if (_lastQuery.isEmpty) {
          emit(UserLoaded(users: _allUsers, filteredUsers: _allUsers));
        } else {
          final filtered = _allUsers.where((user) {
            return user.firstName.toLowerCase().contains(_lastQuery) ||
                user.lastName.toLowerCase().contains(_lastQuery);
          }).toList();
          emit(UserLoaded(users: _allUsers, filteredUsers: filtered));
        }
      }

      _isFetching = false;
    } catch (e) {
      _isFetching = false;
      _currentPage--;
      print('Load more error: $e');
    }
  }

  void _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final query = event.query.trim().toLowerCase();
      _lastQuery = query; // Save last search query

      if (query.isEmpty) {
        emit(UserLoaded(users: _allUsers, filteredUsers: _allUsers));
      } else {
        final filtered = _allUsers.where((user) {
          return user.firstName.toLowerCase().contains(query) ||
              user.lastName.toLowerCase().contains(query);
        }).toList();
        emit(UserLoaded(users: _allUsers, filteredUsers: filtered));
      }
    }
  }
}
