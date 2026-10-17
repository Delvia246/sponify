import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'user': User.fromJson(data['data'])};
      }
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    } catch (e) {
      debugPrint('Error login: $e');
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
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
        final loginResult = await login(email, password);
        if (loginResult['success'] == true) {
          return {'success': true, 'user': loginResult['user']};
        } else {
          return {
            'success': false,
            'message':
                'Akun dibuat, tapi gagal login otomatis: ${loginResult['message']}',
          };
        }
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal mendaftar',
      };
    } catch (e) {
      debugPrint('Error register: $e');
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }

  // UPDATE USERNAME (Diubah mengembalikan Map untuk error message)
  Future<Map<String, dynamic>> updateUsername(
    int userId,
    String newUsername,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}update_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'username': newUsername}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true};
      }
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal update profil',
      };
    } catch (e) {
      debugPrint('Error updateUsername: $e');
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
