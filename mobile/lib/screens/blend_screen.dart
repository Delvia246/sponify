import 'package:flutter/material.dart';

class BlendScreen extends StatelessWidget {
  const BlendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Buat Blend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Avatar + tombol +
                    SizedBox(
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Avatar user (kiri)
                          Transform.translate(
                            offset: const Offset(-50, 0),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1DB954),
                                    Color(0xFF1ED760),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 60,
                              ),
                            ),
                          ),
                          // Tombol + (kanan)
                          Transform.translate(
                            offset: const Offset(50, 0),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2A2A2A),
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Judul
                    const Text(
                      'Undang teman ke Blend',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Deskripsi
                    const Text(
                      'Undang sampai 10 teman ke Blend, playlist bersama yang '
                      'memberimu rekomendasi sosial berdasarkan semua selera musik kalian.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Catatan
                    const Text(
                      'Catatan: Semua orang di Blend ini akan bisa menambahkan '
                      'teman mereka. Kami mungkin juga membuat playlist lain yang berisi '
                      'rekomendasi sosial. Semua orang di playlist rekomendasi sosial akan '
                      'bisa melihat gambar profil dan nama penggunamu.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Tombol Undang
                    SizedBox(
                      width: 200,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur undang teman segera hadir'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Text(
                          'Undang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
