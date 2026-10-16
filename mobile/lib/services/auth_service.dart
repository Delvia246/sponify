import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  // LOGIN - return User kalau berhasil, null kalau gagal
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

  // REGISTER - return User (auto-login) kalau berhasil, null kalau gagal
  Future<User?> register(
      String username, String email, String password) async {
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

      if (response.statusCode == 201 && data['success'] == true) {
        // Auto-login setelah register berhasil
        return await login(email, password);
      }
      return null;
    } catch (e) {
      debugPrint('Error register: $e');
      return null;
    }
  }
}