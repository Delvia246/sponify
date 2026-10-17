import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3D2E), Color(0xFF121212)],
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                // Top Bar (Close button - opsional, untuk simulasi)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed:
                        () {}, // Bisa diarahkan ke Home jika user sudah login
                  ),
                ),

                const Spacer(),

                // Logo Sponify
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Color(0xFF1DB954),
                    size: 50,
                  ),
                ),

                const SizedBox(height: 24),

                // Text
                const Text(
                  'Jutaan lagu.\nGratis di Sponify.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const Spacer(),

                // Button Daftar Gratis
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Daftar gratis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Button Masuk
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer Text
                const Text(
                  'Saat kamu masuk, siapa pun yang memakai perangkat ini akan bisa mengakses akunmu, kecuali kamu memiliki PIN.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
