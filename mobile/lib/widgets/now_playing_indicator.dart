import 'package:flutter/material.dart';

class NowPlayingIndicator extends StatelessWidget {
  const NowPlayingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: _Bar(delay: i * 200),
        );
      }),
    );
  }
}

class _Bar extends StatefulWidget {
  final int delay;
  const _Bar({required this.delay});

  @override
  State<_Bar> createState() => _BarState();
}

class _BarState extends State<_Bar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final height = 6 + (_controller.value * 10);
        return Container(
          width: 3,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      },
    );
  }
}
