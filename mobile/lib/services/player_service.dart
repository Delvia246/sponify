import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async'; // TAMBAHAN UNTUK TIMER
import '../models/song.dart';
import 'session_service.dart';

class PlayerService extends ChangeNotifier {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;

  bool _isShuffle = false;
  int _repeatMode = 0;

  // ============ VARIABEL SLEEP TIMER ============
  Timer? _sleepTimer;
  int? _sleepTimerMinutes;
  int? get sleepTimerMinutes => _sleepTimerMinutes;
  // ==============================================

  static const String baseUrl = 'http://localhost/sponify/backend/api/';

  AudioPlayer get player => _player;
  List<Song> get playlist => _playlist;
  Song? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _playlist.length)
          ? _playlist[_currentIndex]
          : null;
  bool get isPlaying => _player.playing;
  bool get isShuffle => _isShuffle;
  int get repeatMode => _repeatMode;
  Stream<Duration> get positionStream => _player.positionStream;

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void cycleRepeatMode() {
    _repeatMode = (_repeatMode + 1) % 3;
    notifyListeners();
  }

  // ============ FUNGSI SLEEP TIMER ============
  void startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    _sleepTimerMinutes = minutes;
    notifyListeners();

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      _player.pause(); // Pause lagu saat waktu habis
      _sleepTimerMinutes = null;
      _sleepTimer = null;
      notifyListeners();
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimerMinutes = null;
    _sleepTimer = null;
    notifyListeners();
  }
  // ==============================================

  Future<void> playPlaylist(List<Song> songs, int startIndex) async {
    _playlist = songs;
    _currentIndex = startIndex;
    notifyListeners();
    await _playCurrent();
  }

  Future<void> playSingle(Song song) async {
    _playlist = [song];
    _currentIndex = 0;
    notifyListeners();
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final song = currentSong;
    if (song == null) return;
    try {
      await _player.setUrl(song.audioUrl);
      _player.play();
      notifyListeners();
      _recordHistory(song.id);
    } catch (e) {
      debugPrint('Error play: $e');
    }
  }

  Future<void> _recordHistory(int songId) async {
    try {
      final user = await SessionService.getUser();
      if (user == null) return;
      await http.post(
        Uri.parse('${baseUrl}record_history.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': user.id, 'song_id': songId}),
      );
    } catch (e) {
      debugPrint('Error record history: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_player.audioSource == null) {
        await _playCurrent();
      } else {
        _player.play();
      }
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (_repeatMode == 2) {
      await _player.seek(Duration.zero);
      _player.play();
      return;
    }
    if (_isShuffle) {
      if (_playlist.length > 1) {
        int newIndex = _currentIndex;
        while (newIndex == _currentIndex) {
          newIndex = Random().nextInt(_playlist.length);
        }
        _currentIndex = newIndex;
      }
    } else {
      if (_currentIndex < _playlist.length - 1) {
        _currentIndex++;
      } else {
        if (_repeatMode == 1) {
          _currentIndex = 0;
        } else {
          return;
        }
      }
    }
    notifyListeners();
    await _playCurrent();
  }

  Future<void> previous() async {
    if (_isShuffle) {
      if (_playlist.length > 1) {
        int newIndex = _currentIndex;
        while (newIndex == _currentIndex) {
          newIndex = Random().nextInt(_playlist.length);
        }
        _currentIndex = newIndex;
      }
    } else {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else if (_repeatMode == 1) {
        _currentIndex = _playlist.length - 1;
      }
    }
    notifyListeners();
    await _playCurrent();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}