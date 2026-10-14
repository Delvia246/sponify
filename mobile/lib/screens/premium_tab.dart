import 'package:flutter/material.dart';

class PremiumTab extends StatefulWidget {
  const PremiumTab({super.key});

  @override
  State<PremiumTab> createState() => _PremiumTabState();
}

class _PremiumTabState extends State<PremiumTab> {
  int _selectedPlan = 0;

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Individual',
      'price': 'Rp 54.990',
      'period': '/bulan',
      'desc': '1 akun premium',
      'color': const Color(0xFF1DB954),
      'icon': Icons.person,
    },
    {
      'name': 'Student',
      'price': 'Rp 27.490',
      'period': '/bulan',
      'desc': 'Khusus pelajar',
      'color': const Color(0xFF00BCD4),
      'icon': Icons.school,
    },
    {
      'name': 'Family',
      'price': 'Rp 89.990',
      'period': '/bulan',
      'desc': 'Hingga 6 akun',
      'color': const Color(0xFFFF9800),
      'icon': Icons.people,
    },
  ];

  final List<Map<String, dynamic>> _benefits = [
    {
      'icon': Icons.block,
      'title': 'Tanpa Iklan',
      'desc': 'Dengarkan musik tanpa gangguan iklan',
    },
    {
      'icon': Icons.download_for_offline,
      'title': 'Mode Offline',
      'desc': 'Download & putar tanpa koneksi',
    },
    {
      'icon': Icons.high_quality,
      'title': 'Kualitas Tinggi',
      'desc': 'Audio hingga 320 kbps',
    },
    {
      'icon': Icons.skip_next,
      'title': 'Skip Unlimited',
      'desc': 'Lewati lagu sesuka hati',
    },
  ];

  void _showUpgradeDialog() {
    final plan = _plans[_selectedPlan];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text(
          'Konfirmasi Upgrade',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kamu akan upgrade ke:',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 8),
            Text(
              '${plan['name']} - ${plan['price']}${plan['period']}',
              style: const TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur ini hanya demo untuk tugas UTS. Tidak ada transaksi nyata.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selamat! Fitur Premium segera aktif'),
                  backgroundColor: Color(0xFF1DB954),
                ),
              );
            },
            child: const Text('Upgrade Sekarang',
                style: TextStyle(color: Color(0xFF1DB954))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === HERO HEADER ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1DB954),
                      Color(0xFF0D6B32),
                      Color(0xFF121212),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sponify Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dengarkan tanpa batas. Tanpa iklan.\nDengan kualitas tertinggi.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // === BENEFITS SECTION ===
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Kenapa harus Premium?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: _benefits
                      .map((b) => _benefitCard(
                            b['icon'] as IconData,
                            b['title'] as String,
                            b['desc'] as String,
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),

              // === PRICING SECTION ===
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Pilih Paket Kamu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(_plans.length, (i) {
                    final plan = _plans[i];
                    final selected = _selectedPlan == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPlan = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? plan['color'].withValues(alpha: 0.15)
                                : const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? plan['color'] as Color
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                plan['icon'] as IconData,
                                color: selected
                                    ? plan['color'] as Color
                                    : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                plan['name'] as String,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                plan['price'] as String,
                                style: TextStyle(
                                  color: selected
                                      ? plan['color'] as Color
                                      : Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                plan['period'] as String,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                plan['desc'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // === TOMBOL UPGRADE ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _showUpgradeDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor:
                          const Color(0xFF1DB954).withValues(alpha: 0.5),
                    ),
                    child: const Text(
                      'Upgrade ke Premium',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // === CATATAN KECIL ===
              const Center(
                child: Text(
                  'Bisa dibatalkan kapan saja. Syarat & ketentuan berlaku.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitCard(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1DB954).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF1DB954), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}