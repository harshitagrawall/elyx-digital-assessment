import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(user.avatar),
              ),
            ),
            SizedBox(height: 24),
            Text(
              '${user.firstName} ${user.lastName}',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 12),
            _infoRow(Icons.email, user.email),
            Divider(height: 1, thickness: 1, color: Colors.grey[300]),
            _infoRow(Icons.phone, "Phone not available"),
            Divider(height: 1, thickness: 1, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
