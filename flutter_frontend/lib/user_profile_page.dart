import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final String username;

  UserProfilePage({required this.username});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile: ${widget.username}'),
      ),
      body: Center(
        child: Text(
          'Welcome to your profile, ${widget.username}!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      
    );
  }
}
