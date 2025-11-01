import 'package:elyx_digital_assessment_test/features/users/presentation/pages/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import 'no_internet.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoadingMore = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (currentScroll >= maxScroll - 200) {
        if (!_isLoadingMore) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(Duration(milliseconds: 300), () {
            if (!_isLoadingMore) {
              print('Scroll near bottom - dispatching LoadMoreUsers');
              _isLoadingMore = true;
              context.read<UserBloc>().add(LoadMoreUsers());
            }
          });
        }
      }
    });

    context.read<UserBloc>().add(LoadUsers());

    _searchController.addListener(() {
      setState(() {}); // To toggle clear button icon
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    _searchController.clear();
    context.read<UserBloc>().add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              textInputAction: TextInputAction.search,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    context.read<UserBloc>().add(SearchUsers(''));
                    FocusScope.of(context).unfocus();
                  },
                  tooltip: 'Clear search',
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onChanged: (query) {
                context.read<UserBloc>().add(SearchUsers(query));
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  print(
                    'UI Builder UserLoaded filteredUsers count: ${state.filteredUsers.length}',
                  );
                  _isLoadingMore = false;
                  print('Loaded ${state.filteredUsers.length} users total.');
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserError) {
                  if (state.message.toLowerCase().contains("no internet")) {
                    return NoInternetPage(
                      onRetry: () {
                        context.read<UserBloc>().add(LoadUsers());
                      },
                    ); // Show your no internet widget
                  } else {
                    return Center(child: Text(state.message));
                  }
                } else if (state is UserLoaded) {
                  if (state.filteredUsers.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.filteredUsers.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.filteredUsers.length) {
                          final bloc = context.read<UserBloc>();
                          if (bloc.currentPage < bloc.totalPages) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }
                        final user = state.filteredUsers[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserDetailPage(user: user),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    color: Colors.grey.shade300,
                                    blurRadius: 1,
                                  ),
                                ],
                                border: BoxBorder.all(
                                  color: Colors.white,
                                  width: .5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(user.avatar),
                                ),
                                title: Text(
                                  '${user.firstName} ${user.lastName}',
                                ),
                                subtitle: Text(user.email),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
