import 'package:flutter/material.dart';

class PremiumTab extends StatefulWidget {
  const PremiumTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
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
            ),
            const SizedBox(height: 32),
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
            const Text(
              'Paket yang tersedia',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
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
          const SizedBox(height: 20),
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