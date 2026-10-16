import 'package:flutter/material.dart';

class PremiumTab extends StatelessWidget {
  const PremiumTab({super.key});

  @override
<<<<<<< HEAD
=======
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
      useRootNavigator: false,
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
>>>>>>> 094ffd4caf5ec8463c97c4b3ac48c7775484fdb2
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            // === HEADER ===
            const Row(
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 28),
                SizedBox(width: 8),
                Text(
                  'Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // === HERO IMAGE SECTION ===
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1DB954),
                    Color(0xFF0D7A35),
                    Color(0xFF121212),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 80,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Icon(
                      Icons.headphones,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === TITLE & SUBTITLE ===
            const Text(
              'Nikmati musikmu sepuasnya dengan Premium Standard.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),

            // === CTA BUTTON ===
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur premium segera hadir'),
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
                  'Dapatkan Premium Standard',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Persyaratan berlaku.\nLihat paket lainnya di bawah ini.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 32),

            // === WHY PREMIUM ===
            const Text(
              'Kenapa harus pilih Premium Standard?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _featureRow(Icons.block, 'Mendengarkan musik bebas iklan'),
            _featureRow(Icons.shuffle, 'Putar lagu dalam urutan apa pun'),
            _featureRow(Icons.headphones, 'Kualitas audio sangat tinggi'),
            _featureRow(
              Icons.groups,
              'Mendengarkan bersama teman secara real-time',
            ),
            const SizedBox(height: 32),

            // === PAKET TERSEDIA ===
            const Text(
              'Paket yang tersedia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // STUDENT
            _planCard(
              context,
              badge: 'Diskon tersedia',
              badgeColor: const Color(0xFF4CAF50),
              title: 'Student',
              titleColor: const Color(0xFF4CAF50),
              price: 'Rp 29.900/bulan',
              features: const [
                '1 akun Standard terverifikasi',
                'Download untuk mendengarkan offline',
                'Kualitas audio sangat tinggi (hingga ~320 kbps)',
                'Pembatalan kapan saja',
              ],
              buttonColor: const Color(0xFF4CAF50),
              buttonTextColor: Colors.black,
              buttonText: 'Dapatkan Premium Student',
              footer: 'Tawaran Sponify Premium Student tersedia untuk siswa institusi pendidikan tingkat lanjut terakreditasi yang belum pernah mencoba Premium.',
            ),
            const SizedBox(height: 16),

            // STANDARD
            _planCard(
              context,
              title: 'Standard',
              titleColor: const Color(0xFF1DB954),
              price: 'Rp 59.900/bulan',
              features: const [
                '1 akun Standard',
                'Download untuk mendengarkan offline',
                'Kualitas audio sangat tinggi (hingga ~320 kbps)',
                'Pembatalan kapan saja',
              ],
              buttonColor: const Color(0xFF1DB954),
              buttonTextColor: Colors.black,
              buttonText: 'Dapatkan Premium Standard',
            ),
            const SizedBox(height: 16),

            // PLATINUM
            _planCard(
              context,
              title: 'Platinum',
              titleColor: const Color(0xFFE8E337),
              price: 'Rp 119.900/bulan',
              features: const [
                'Hingga 3 akun Platinum',
                'Download untuk mendengarkan offline',
                'Kualitas audio lossless (hingga ~24-bit/44,1 kHz)',
                'Mix playlist-mu',
                'AI DJ pribadi',
                'Pembuatan playlist AI',
                'Hubungkan perangkat lunak DJ-mu',
              ],
              buttonColor: const Color(0xFFE8E337),
              buttonTextColor: Colors.black,
              buttonText: 'Dapatkan Premium Platinum',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    String? badge,
    Color? badgeColor,
    required String title,
    required Color titleColor,
    required String price,
    required List<String> features,
    required Color buttonColor,
    required Color buttonTextColor,
    required String buttonText,
    String? footer,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Logo premium kecil
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.black,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Price
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 12),

          // Features
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Pilih paket $title'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Footer
          if (footer != null) ...[
            const SizedBox(height: 12),
            Text(
              footer,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
