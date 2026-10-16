import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class MoodService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  Future<List<Song>> getSongsByMood(String mood) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}mood_songs.php?mood=$mood'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List list = data['data'];
          return list.map((item) => Song.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getSongsByMood: $e');
      return [];
    }
  }
}