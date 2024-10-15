import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'login_page.dart'; // Assurez-vous d'importer votre page d'accueil

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _country = '';
  String _password = '';
  String _confirmPassword = '';

  String? _usernameError;
  String? _emailError;

   

  void _register() async {
    setState(() {
      _usernameError = null;
      _emailError = null;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Vérifiez que les mots de passe correspondent
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        // Vérifiez si le nom d'utilisateur et l'e-mail sont disponibles
        bool isAvailable =
            await ApiService.checkUsernameAndEmail(_username, _email);

        // Ajoutez un log pour voir la disponibilité
        if (kDebugMode) {
          print('Username and email availability: $isAvailable');
        }

        if (!isAvailable) {
          setState(() {
            _usernameError = 'Username or email already in use';
            _emailError = 'Username or email already in use';
          });
          return;
        }

        setState(() {
          _usernameError = null;
          _emailError = null;
        });

        // Inscription
        await ApiService.register(
            _username, _email, _firstName, _lastName, _country, _password);
        await ApiService.login(_username, _password);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        setState(() {
          _usernameError = 'Registration failed: $e';
          _emailError = null; // Réinitialisez si nécessaire
        });
        if (kDebugMode) {
          print('Registration error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _usernameError, // Affichez l'erreur ici
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a username' : null,
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError, // Affichez l'erreur ici
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an email' : null,
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your first name' : null,
              onSaved: (value) => _firstName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your last name' : null,
              onSaved: (value) => _lastName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Country'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your country' : null,
              onSaved: (value) => _country =
                  value!, // Assurez-vous d'ajouter _country en tant que variable d'instance
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
              onSaved: (value) => _password = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please confirm your password' : null,
              onSaved: (value) => _confirmPassword = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
