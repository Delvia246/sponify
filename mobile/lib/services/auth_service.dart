import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return User.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error login: $e');
      return null;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 201 && data['success'] == true;
    } catch (e) {
      debugPrint('Error register: $e');
      return false;
    }
  }
}