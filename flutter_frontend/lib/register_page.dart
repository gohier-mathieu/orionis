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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        // Inscription
        await ApiService.register(
            _username, _email, _firstName, _lastName, _country, _password);
        await ApiService.login(_username, _password);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful, logging in...')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), 
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
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
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a username' : null,
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
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
