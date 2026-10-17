import 'package:flutter/material.dart';

import '../services/liked_service.dart';
import '../services/session_service.dart';

class LikeButton extends StatefulWidget {
  final int songId;
  final double size;
  const LikeButton({super.key, required this.songId, this.size = 30});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLiked();
  }

  Future<void> _checkLiked() async {
    final user = await SessionService.getUser();
    if (user == null) return;
    final liked = await LikedService().isLiked(user.id, widget.songId);
    if (mounted) {
      setState(() {
        _isLiked = liked;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggle() async {
    final user = await SessionService.getUser();
    if (user == null) return;

    final res = await LikedService().toggleLike(user.id, widget.songId);

    // FIX: Hapus 'res != null' karena res sudah pasti bertipe bool
    if (mounted) {
      setState(() => _isLiked = res);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(width: widget.size, height: widget.size);
    }
    return IconButton(
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? const Color(0xFF1DB954) : Colors.white,
        size: widget.size,
      ),
      onPressed: _toggle,
    );
  }
}
