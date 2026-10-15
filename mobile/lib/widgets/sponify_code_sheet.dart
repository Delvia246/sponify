import 'package:flutter/material.dart';

class SponifyCodeSheet extends StatelessWidget {
  const SponifyCodeSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withValues(alpha: 0.7),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GestureDetector(
                onTap: () {},
                child: const SponifyCodeSheet(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A2F), Color(0xFF1A2E25)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // === ILUSTRASI 3 CARD ===
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Card kiri (pink)
                Transform.translate(
                  offset: const Offset(-70, 0),
                  child: Transform.rotate(
                    angle: -0.15,
                    child: _miniCard(const Color(0xFFE91E63)),
                  ),
                ),
                // Card kanan (orange)
                Transform.translate(
                  offset: const Offset(70, 0),
                  child: Transform.rotate(
                    angle: 0.15,
                    child: _miniCard(const Color(0xFFFF9800)),
                  ),
                ),
                // Card tengah (hijau - utama)
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Container(
                    width: 130,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8E994),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Today's",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Top Hits',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Waveform
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(15, (i) {
                            final heights = [
                              8.0,
                              14.0,
                              20.0,
                              12.0,
                              18.0,
                              24.0,
                              16.0,
                              22.0,
                              14.0,
                              20.0,
                              12.0,
                              18.0,
                              10.0,
                              16.0,
                              8.0,
                            ];
                            return Container(
                              width: 2,
                              height: heights[i],
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // === TITLE ===
          const Text(
            'Kode Sponify',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // === DESKRIPSI ===
          const Text(
            'Semua di Sponify mempunyai kode untuk dibagikan. '
            'Pindai dengan ponselmu, dan kamu akan diarahkan '
            'langsung ke lagu, podcast, artis, atau playlist.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),

          const SizedBox(height: 24),

          // === TOMBOL PINDAI ===
          SizedBox(
            width: 160,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur pindai segera hadir'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Pindai',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // === TOMBOL TUTUP ===
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniCard(Color color) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
