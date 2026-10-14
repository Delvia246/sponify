import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/playlist.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/song.dart';

class LibraryService {
  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  // Ambil playlist milik user
  Future<List<Playlist>> getPlaylists(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}playlists.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List list = data['data'];
          return list.map((item) => Playlist.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getPlaylists: $e');
      return [];
    }
  }

  // Bikin playlist baru
  Future<bool> createPlaylist(
      int userId, String name, String description) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}playlists.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'name': name,
          'description': description,
        }),
      );
      final data = jsonDecode(response.body);
      return response.statusCode == 201 && data['success'] == true;
    } catch (e) {
      debugPrint('Error createPlaylist: $e');
      return false;
    }
  }

  // Ambil semua artis
  Future<List<Artist>> getArtists() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}artists.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List list = data['data'];
          return list.map((item) => Artist.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getArtists: $e');
      return [];
    }
  }

  // Ambil semua album
  Future<List<Album>> getAlbums() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}albums.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List list = data['data'];
          return list.map((item) => Album.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getAlbums: $e');
      return [];
    }
  }

  // Ambil semua lagu dalam playlist
  Future<List<Song>> getPlaylistSongs(int playlistId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}playlist_songs.php?playlist_id=$playlistId'),
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
      debugPrint('Error getSongsInPlaylist: $e');
      return [];
    }
  }
}