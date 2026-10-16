import 'dart:math';
import 'package:flutter/material.dart';
import '../services/player_service.dart';

class MusicVisualizer extends StatefulWidget {
  final int barCount;
  final double height;
  final Color color;

  const MusicVisualizer({
    super.key,
    this.barCount = 32,
    this.height = 60,
    this.color = const Color(0xFF1DB954),
  });

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _barHeights = List.generate(widget.barCount, (_) => 0.3);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.addListener(_updateBars);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateBars);
    _controller.dispose();
    super.dispose();
  }

  void _updateBars() {
    if (!mounted) return;
    setState(() {
      _barHeights = List.generate(widget.barCount, (i) {
        final centerFactor =
            1.0 - ((i - widget.barCount / 2).abs() / (widget.barCount / 2));
        final base = 0.2 + centerFactor * 0.3;
        final random = _random.nextDouble() * 0.7;
        return (base + random).clamp(0.1, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PlayerService(),
      builder: (context, _) {
        final playing = PlayerService().isPlaying;

        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.barCount, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 3,
                height: playing
                    ? widget.height * _barHeights[i]
                    : widget.height * 0.08,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      widget.color.withValues(alpha: 0.4),
                      widget.color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}