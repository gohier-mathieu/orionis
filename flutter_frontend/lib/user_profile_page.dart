import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String username;

  UserProfilePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile: $username'),
      ),
      body: Center(
        child: Text(
          'Welcome to your profile, $username!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
