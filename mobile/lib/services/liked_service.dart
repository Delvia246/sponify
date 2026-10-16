import 'dart:convert';
<<<<<<< HEAD

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/song.dart';

class LikedService {
  static const String baseUrl = 'http://localhost/sponify/backend/api';

  // ============================================
  // GET: Ambil semua liked songs user
  // ============================================
  Future<List<Song>> getLikedSongs(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/liked_songs.php?user_id=$userId'),
=======
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class LikedService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  // Ambil semua lagu yang disukai user
  Future<List<Song>> getLikedSongs(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}liked_songs.php?user_id=$userId'),
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
<<<<<<< HEAD
          final List<dynamic> list = data['data'] ?? [];
          return list.map((json) => Song.fromJson(json)).toList();
=======
          final List list = data['data'];
          return list.map((item) => Song.fromJson(item)).toList();
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getLikedSongs: $e');
      return [];
    }
  }

<<<<<<< HEAD
  // ============================================
  // POST: Like a song
  // ============================================
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

  // ============================================
  // DELETE: Unlike a song
  // ============================================
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

  // ============================================
  // Cek apakah lagu di-like
  // ============================================
  Future<bool> isLiked(int userId, int songId) async {
    final liked = await getLikedSongs(userId);
    return liked.any((s) => s.id == songId);
  }
}
=======
  // Toggle like/unlike — return true kalau sekarang liked, false kalau unlike
  Future<bool?> toggleLike(int userId, int songId) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}liked_songs.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'song_id': songId,
        }),
      );

      final data = jsonDecode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['success'] == true) {
        return data['data']['liked'] == true;
      }
      return null;
    } catch (e) {
      debugPrint('Error toggleLike: $e');
      return null;
    }
  }

  // Cek apakah sebuah lagu udah di-like
  Future<bool> isLiked(int userId, int songId) async {
    final liked = await getLikedSongs(userId);
    return liked.any((song) => song.id == songId);
  }
}
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
