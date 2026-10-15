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
        return Container(
          color: const Color(0xFF0A0A0A),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRect(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                      maxHeight: 880,
                    ),
                    child: child!,
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
