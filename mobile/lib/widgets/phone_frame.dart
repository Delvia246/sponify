import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

Widget phoneWrap(Widget screen) {
  if (!kIsWeb) return screen;
  return PhoneFrame(child: screen);
}

class PhoneFrame extends StatelessWidget {
  final Widget child;
  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar Chrome saat ini
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Target ukuran HP
    const double targetHeight = 844;
    const double targetWidth = 390;
    final double ratio = targetWidth / targetHeight;

    // Hitung tinggi frame, dikurangi margin
    double frameHeight = targetHeight;
    if (screenHeight < 920) {
      frameHeight = screenHeight - 40; // Sisakan margin 20 atas bawah
    }
    double frameWidth = frameHeight * ratio;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Container(
          width: frameWidth,
          height: frameHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: MediaQuery(
              // Palsukan ukuran layar HP ke dalam widget
              data: MediaQueryData(
                size: Size(frameWidth, frameHeight),
                devicePixelRatio: 1.0,
              ),
              child: Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute(
                  builder: (_) => child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}