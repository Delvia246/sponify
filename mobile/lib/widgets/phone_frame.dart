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
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double targetWidth = 390;
          const double targetHeight = 844;
          const double aspectRatio = targetWidth / targetHeight;

          // Hitung tinggi frame maksimal (dikurangi margin 32px atas-bawah)
          double frameHeight = targetHeight;
          if (constraints.maxHeight < 880) {
            frameHeight = constraints.maxHeight - 32;
          }
          
          double frameWidth = frameHeight * aspectRatio;

          // Kalau layarnya sempit, batasi lebarnya juga
          if (constraints.maxWidth < frameWidth + 32) {
            frameWidth = constraints.maxWidth - 32;
            frameHeight = frameWidth / aspectRatio;
          }

          return Center(
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
          );
        },
      ),
    );
  }
}