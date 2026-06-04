import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BoltVideoWidget extends StatefulWidget {
  const BoltVideoWidget({
    super.key,
    this.size = 200,
    this.width,
    this.height,
    this.borderRadius,
    this.assetPath = 'assets/bolt/expressions/boratreinar.mp4',
  });

  final double size;
  final double? width;
  final double? height;
  final double? borderRadius;
  final String assetPath;

  @override
  State<BoltVideoWidget> createState() => _BoltVideoWidgetState();
}

class _BoltVideoWidgetState extends State<BoltVideoWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(widget.assetPath);

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();

      if (mounted) {
        setState(() {
          _controller = controller;
          _initialized = true;
        });
      } else {
        await controller.dispose();
      }
    } catch (e) {
      debugPrint('Erro ao carregar vídeo: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    if (!_initialized) {
      // Placeholder enquanto carrega
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.width ?? widget.size,
      height: widget.height ?? widget.size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? widget.size * 0.1,
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: widget.size,
            height: widget.size / _aspectRatio,
            child: VideoPlayer(controller!),
          ),
        ),
      ),
    );
  }

  double get _aspectRatio {
    final aspectRatio = _controller?.value.aspectRatio ?? 0;
    return aspectRatio > 0 ? aspectRatio : 16 / 9;
  }
}
