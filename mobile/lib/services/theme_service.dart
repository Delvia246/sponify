import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  // Warna default (Hijau Spotify)
  Color _primaryColor = const Color(0xFF1DB954);

  Color get primaryColor => _primaryColor;

  void changeColor(Color newColor) {
    _primaryColor = newColor;
    notifyListeners();
  }
}