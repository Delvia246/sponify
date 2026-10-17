import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

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
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DB954),
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        // Kalau di HP asli, tampil full screen
        if (!kIsWeb) return child!;

        // Kalau di Chrome (Web), bungkus jadi bingkai HP
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A), // Warna luar HP
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  width: 390,
                  height: 844,
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: MediaQuery(
                      data: const MediaQueryData(
                        size: Size(390, 844),
                        devicePixelRatio: 1.0,
                      ),
                      child: child!,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      home: const LoginScreen(),
    );
  }
}