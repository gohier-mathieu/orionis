import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'login_page.dart';
import 'user_profile_page.dart'; // Importez la page de profil
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  int _currentIndex = 0;

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
      print('Error loading user data: $e');
    }
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedUsername = prefs.getString('username');
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

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      Center(child: Text('Welcome to the Home Page!')),
      UserProfilePage(
          username: username!), // Assurez-vous de passer l'utilisateur ici
      // Ajoutez d'autres pages si nécessaire
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
