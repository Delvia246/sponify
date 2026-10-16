import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
<<<<<<< HEAD

import '../models/song.dart';
import 'history_service.dart';

enum PlayerRepeatMode { off, all, one }
=======
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song.dart';
import 'session_service.dart';
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2

class PlayerService extends ChangeNotifier {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

<<<<<<< HEAD
  final AudioPlayer player = AudioPlayer();
=======
  final AudioPlayer _player = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;
  static const String baseUrl = 'http://localhost/sponify/backend/api/';
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2

  List<Song> _playlist = [];
  int _currentIndex = 0;

  bool _isShuffle = false;
  PlayerRepeatMode _repeatMode = PlayerRepeatMode.off;

  // ============================================
  // GETTERS
  // ============================================
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _playlist.length)
      ? _playlist[_currentIndex]
      : null;

<<<<<<< HEAD
  bool get isPlaying => player.playing;
  bool get isShuffle => _isShuffle;
  PlayerRepeatMode get repeatMode => _repeatMode;

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  // ============================================
  // PLAY PLAYLIST
  // ============================================
=======
  // Play seluruh playlist mulai dari index tertentu
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
  Future<void> playPlaylist(List<Song> songs, int startIndex) async {
    if (songs.isEmpty) return;

    if (_playlist.length == songs.length &&
        _currentIndex == startIndex &&
        currentSong?.id == songs[startIndex].id) {
      if (!player.playing) await player.play();
      notifyListeners();
<<<<<<< HEAD
      return;
=======
      // Catat ke listening history
      _recordHistory(song.id);
    } catch (e) {
      debugPrint('Error play: $e');
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
    }

    _playlist = List.from(songs);
    _currentIndex = startIndex;

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      // Simpan ke history
      await HistoryService.addSong(_playlist[_currentIndex]);
    } catch (e) {
      debugPrint('Error playPlaylist: $e');
    }
    notifyListeners();
  }

<<<<<<< HEAD
  // ============================================
  // TOGGLE PLAY / PAUSE
  // ============================================
=======
  // Kirim log ke backend (fire and forget)
  Future<void> _recordHistory(int songId) async {
    try {
      final user = await SessionService.getUser();
      if (user == null) return;

      await http.post(
        Uri.parse('${baseUrl}record_history.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': user.id,
          'song_id': songId,
        }),
      );
    } catch (e) {
      debugPrint('Error record history: $e');
    }
  }

>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    notifyListeners();
  }

  // ============================================
  // NEXT
  // ============================================
  Future<void> next() async {
    if (_playlist.isEmpty) return;

    if (_repeatMode == PlayerRepeatMode.one) {
      await player.seek(Duration.zero);
      await player.play();
      notifyListeners();
      return;
    }

    if (_isShuffle && _playlist.length > 1) {
      int randomIndex;
      do {
        randomIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length;
      } while (randomIndex == _currentIndex);
      _currentIndex = randomIndex;
    } else {
      _currentIndex++;
      if (_currentIndex >= _playlist.length) {
        if (_repeatMode == PlayerRepeatMode.all) {
          _currentIndex = 0;
        } else {
          _currentIndex = _playlist.length - 1;
          await player.pause();
          notifyListeners();
          return;
        }
      }
    }

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      // Simpan ke history
      await HistoryService.addSong(_playlist[_currentIndex]);
    } catch (e) {
      debugPrint('Error next: $e');
    }
    notifyListeners();
  }

  // ============================================
  // PREVIOUS
  // ============================================
  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    if (player.position.inSeconds > 3) {
      await player.seek(Duration.zero);
      return;
    }

    if (_isShuffle && _playlist.length > 1) {
      int randomIndex;
      do {
        randomIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length;
      } while (randomIndex == _currentIndex);
      _currentIndex = randomIndex;
    } else {
      _currentIndex--;
      if (_currentIndex < 0) {
        _currentIndex = _playlist.length - 1;
      }
    }

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      // Simpan ke history
      await HistoryService.addSong(_playlist[_currentIndex]);
    } catch (e) {
      debugPrint('Error previous: $e');
    }
    notifyListeners();
  }

  // ============================================
  // SEEK
  // ============================================
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  // ============================================
  // SHUFFLE
  // ============================================
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  // ============================================
  // REPEAT
  // ============================================
  void cycleRepeat() {
    if (_repeatMode == PlayerRepeatMode.off) {
      _repeatMode = PlayerRepeatMode.all;
    } else if (_repeatMode == PlayerRepeatMode.all) {
      _repeatMode = PlayerRepeatMode.one;
    } else {
      _repeatMode = PlayerRepeatMode.off;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
