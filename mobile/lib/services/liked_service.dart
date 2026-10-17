import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/song.dart';

class LikedService {
  static const String baseUrl = 'http://localhost/sponify/backend/api';

  Future<List<Song>> getLikedSongs(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/liked_songs.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'] ?? [];
          return list.map((json) => Song.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getLikedSongs: $e');
      return [];
    }
  }

  Future<bool> likeSong(int userId, int songId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/liked_songs.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error likeSong: $e');
      return false;
    }
  }

  Future<bool> unlikeSong(int userId, int songId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/liked_songs.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Error unlikeSong: $e');
      return false;
    }
  }

  Future<bool> isLiked(int userId, int songId) async {
    final liked = await getLikedSongs(userId);
    return liked.any((s) => s.id == songId);
  }

  Future<bool> toggleLike(int userId, int songId) async {
    final already = await isLiked(userId, songId);
    if (already) {
      return await unlikeSong(userId, songId);
    } else {
      return await likeSong(userId, songId);
    }
  }
}
