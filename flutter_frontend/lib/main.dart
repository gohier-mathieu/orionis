import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Color(0xFF6200EA);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color.fromARGB(255, 162, 15, 15);
  static const Color primaryAccentColor = Color(0xFFFFC107);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orionis',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Rendre l'AppBar transparente
          elevation: 0, // Supprimer l'ombre sous l'AppBar
          iconTheme: IconThemeData(color: primaryColor), // Couleur des icônes
          titleTextStyle: TextStyle(
              color: primaryColor,
              fontSize: 20), // Couleur du titre de l'AppBar
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: secondaryColor,
          surface: backgroundColor, // Définir la couleur de fond dans ColorScheme
          primary: primaryColor,
          primaryContainer: primaryAccentColor, // Optionnel pour définir un accent primaire
        ),
      ),
      home: FutureBuilder<bool>(
        future: ApiService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomePage();
            } else {
              return LoginPage();
            }
          }
          return CircularProgressIndicator();
        },
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
