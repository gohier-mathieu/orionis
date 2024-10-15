import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/main.dart';
import 'api_service.dart';
import 'login_page.dart';
import 'user_profile_page.dart'; // Importez la page de profil
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final userData = await ApiService.getUserData();
      setState(() {
        username = userData['username'];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedUsername = prefs.getString('username');
    if (kDebugMode) {
      print('Loaded username: $loadedUsername');
    }
    setState(() {
      username = loadedUsername;
    });
  }

  void _logout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _goToUserProfile() {
    if (username != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfilePage(username: username!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: MyApp.primaryColor,

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            if (username != null) ...[
              Text('Logged in as: $username'),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: _goToUserProfile, // Navigue vers la page de profil
                tooltip: 'View Profile',
              ),
            ] else
              Text('Loading username...'),
          ],
        ),
      ),
    );
  }
}
