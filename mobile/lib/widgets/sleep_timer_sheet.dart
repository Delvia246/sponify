import 'package:flutter/material.dart';

import '../services/player_service.dart';

class SleepTimerSheet extends StatelessWidget {
  const SleepTimerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const SleepTimerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();
    final options = [
      {'label': '5 menit', 'duration': const Duration(minutes: 5)},
      {'label': '10 menit', 'duration': const Duration(minutes: 10)},
      {'label': '15 menit', 'duration': const Duration(minutes: 15)},
      {'label': '30 menit', 'duration': const Duration(minutes: 30)},
      {'label': '45 menit', 'duration': const Duration(minutes: 45)},
      {'label': '1 jam', 'duration': const Duration(hours: 1)},
      {'label': 'Akhir lagu', 'duration': null}, // Akan kita handle manual
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Pengatur waktu tidur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF3E3E3E), height: 1),
            ...options.map(
              (opt) => ListTile(
                title: Text(
                  opt['label'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                trailing:
                    playerService.isSleepTimerActive &&
                        playerService.sleepTimerDuration == opt['duration']
                    ? const Icon(Icons.check, color: Color(0xFF1DB954))
                    : null,
                onTap: () {
                  if (opt['duration'] == null) {
                    // Handle "Akhir lagu" (simplified for now: pause at end)
                    // Actually, we can just set a flag, but for now let's just
                    // pause immediately or skip this feature if too complex.
                    // Let's just use 1 second as a dummy for "Akhir lagu" or disable it.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Akhir lagu akan hadir'),
                      ),
                    );
                  } else {
                    playerService.setSleepTimer(opt['duration'] as Duration);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Timer diset: ${opt['label']}'),
                        backgroundColor: const Color(0xFF1DB954),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
