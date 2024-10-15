import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.1.10:8000/api'; // Utilisez l'adresse IP de votre machine pour l'émulateur Android


  static Future<bool> checkUsernameAndEmail(
      String username, String email) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.10:8000/api/check_username_email?username=$username&email=$email'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['available'];
    } else {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to check username and email');
    }
  }




  static Future<Map<String, dynamic>> register(
      String username,
      String email,
      String firstName,
      String lastName,
      String country,
      String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'country': country,
        'password': password
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  

 static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (kDebugMode) {
        print('Login response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Login response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Login response data: $data');
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        // Stocker le username
        if (data['username'] != null) {
          await prefs.setString('username', data['username']);
        } else {
          if (kDebugMode) {
            print('Warning: username not found in login response');
          }
        }

        return data;
      } else {
        if (kDebugMode) {
          print('Login failed with status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during login: $e');
      }
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/home/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
