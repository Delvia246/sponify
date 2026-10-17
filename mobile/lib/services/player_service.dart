import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/song.dart';
import 'history_service.dart';

enum PlayerRepeatMode { off, all, one }

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

  final AudioPlayer player = AudioPlayer();

  List<Song> _playlist = [];
  int _currentIndex = 0;

  bool _isShuffle = false;
  int _repeatMode = 0;

  // === QUEUE ===
  final List<Song> _queue = [];
  int _queueCount = 0;

  // === SLEEP TIMER ===
  Timer? _sleepTimer;
  Duration? _sleepTimerDuration;

  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  List<Song> get queue => List.unmodifiable(_queue);
  int get queueLength => _queueCount;

  // Sleep timer getters
  Duration? get sleepTimerDuration => _sleepTimerDuration;
  bool get isSleepTimerActive => _sleepTimer != null;

  Song? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _playlist.length)
      ? _playlist[_currentIndex]
      : null;

  bool get isPlaying => player.playing;
  bool get isShuffle => _isShuffle;
  int get repeatMode => _repeatMode;
  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration> get positionStream => player.positionStream;
  Stream<Duration?> get durationStream => player.durationStream;

  // === SLEEP TIMER LOGIC ===
  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    _sleepTimerDuration = duration;

    if (duration != null) {
      _sleepTimer = Timer(duration, () {
        player.pause();
        _sleepTimer = null;
        _sleepTimerDuration = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerDuration = null;
    notifyListeners();
  }

  // === QUEUE LOGIC ===
  void addToQueue(Song song) {
    if (_currentIndex < 0 || _currentIndex >= _playlist.length) {
      _playlist.add(song);
      _queue.add(song);
    } else {
      _playlist.insert(_currentIndex + 1 + _queueCount, song);
      _queue.add(song);
      _queueCount++;
    }
    notifyListeners();
  }

  void clearQueue() {
    _queue.clear();
    _queueCount = 0;
    notifyListeners();
  }

  Future<void> _recordHistory(int songId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 1;

      await http.post(
        Uri.parse('http://localhost/sponify/backend/api/record_history.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
    } catch (e) {
      debugPrint('Error recordHistory: $e');
    }
  }

  Future<void> playPlaylist(List<Song> songs, int startIndex) async {
    if (songs.isEmpty) return;

    if (_playlist.length == songs.length &&
        _currentIndex == startIndex &&
        currentSong?.id == songs[startIndex].id) {
      if (!player.playing) await player.play();
      notifyListeners();
      return;
    }

    _playlist = List.from(songs);
    _currentIndex = startIndex;
    _queueCount = 0;

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      await HistoryService.addSong(_playlist[_currentIndex]);
      await _recordHistory(_playlist[_currentIndex].id);
    } catch (e) {
      debugPrint('Error playPlaylist: $e');
    }
    notifyListeners();
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
    if (_playlist.isEmpty) return;
    if (_queueCount > 0) _queueCount--;

    if (_repeatMode == PlayerRepeatMode.one) {
      await player.seek(Duration.zero);
      await player.play();
      notifyListeners();
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

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      await HistoryService.addSong(_playlist[_currentIndex]);
      await _recordHistory(_playlist[_currentIndex].id);
    } catch (e) {
      debugPrint('Error next: $e');
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

    try {
      await player.setUrl(_playlist[_currentIndex].audioUrl);
      await player.play();
      await HistoryService.addSong(_playlist[_currentIndex]);
      await _recordHistory(_playlist[_currentIndex].id);
    } catch (e) {
      debugPrint('Error previous: $e');
    }
    notifyListeners();
    await _playCurrent();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

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
    _sleepTimer?.cancel();
    player.dispose();
    super.dispose();
  }
}
