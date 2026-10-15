import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/song.dart';

class HistoryService {
  static const String _key = 'recently_played';

  // Simpan lagu yang baru diputar
  static Future<void> addSong(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    // Hapus kalau sudah ada (biar tidak duplikat)
    existing.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return map['id'] == song.id;
    });

    // Tambah di depan
    existing.insert(
      0,
      jsonEncode({
        'id': song.id,
        'title': song.title,
        'duration': song.duration,
        'audio_url': song.audioUrl,
        'album': song.album,
        'cover_url': song.coverUrl,
        'artist': song.artist,
      }),
    );

    // Batasi 30 lagu terakhir
    if (existing.length > 30) {
      existing.removeRange(30, existing.length);
    }

    await prefs.setStringList(_key, existing);
  }

  // Ambil semua history
  static Future<List<Song>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((s) => Song.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  // Hapus semua
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
