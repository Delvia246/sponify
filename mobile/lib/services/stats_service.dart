import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StatsService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  // Ambil statistik listening user
  Future<Map<String, dynamic>?> getStats(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}stats.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error getStats: $e');
      return null;
    }
  }
}