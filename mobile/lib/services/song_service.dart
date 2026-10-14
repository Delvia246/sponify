import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class SongService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  // Ambil semua lagu dari backend
  Future<List<Song>> getAllSongs() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}songs.php'),
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
      debugPrint('Error getAllSongs: $e');
      return [];
    }
  }

  // Cari lagu berdasarkan judul / artist
  Future<List<Song>> searchSongs(String query) async {
    final all = await getAllSongs();
    if (query.isEmpty) return all;
    final lower = query.toLowerCase();
    return all.where((song) =>
      song.title.toLowerCase().contains(lower) ||
      song.artist.toLowerCase().contains(lower)
    ).toList();
  }
}