import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'widgets/phone_frame.dart';

void main() {
  runApp(const SponifyApp());
}

class SponifyApp extends StatelessWidget {
  const SponifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sponify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1DB954),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          secondary: Color(0xFF1DB954),
          surface: Color(0xFF121212),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      home: phoneWrap(const LoginScreen()),
    );
  }
}