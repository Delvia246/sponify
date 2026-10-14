import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class PlayerService extends ChangeNotifier {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final AudioPlayer _player = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;

  // Getter
  AudioPlayer get player => _player;
  List<Song> get playlist => _playlist;
  Song? get currentSong =>
      (_currentIndex >= 0 && _currentIndex < _playlist.length)
          ? _playlist[_currentIndex]
          : null;
  bool get isPlaying => _player.playing;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  // Set seluruh playlist, mulai dari index tertentu
  Future<void> playPlaylist(List<Song> songs, int startIndex) async {
    _playlist = songs;
    _currentIndex = startIndex;
    notifyListeners();
    await _playCurrent();
  }

  // Play satu lagu saja
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
    } catch (e) {
      debugPrint('Error play: $e');
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
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      notifyListeners();
      await _playCurrent();
    }
  }

  Future<void> previous() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
      await _playCurrent();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _playlist = [];
    _currentIndex = -1;
    notifyListeners();
  }
}