import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BoltWelcomeOverlay extends StatefulWidget {
  const BoltWelcomeOverlay({
    super.key,
    required this.onFinished,
    this.assetPath = 'assets/bolt/boasvindas.mp4',
  });

  final VoidCallback onFinished;
  final String assetPath;

  @override
  State<BoltWelcomeOverlay> createState() => _BoltWelcomeOverlayState();
}

class _BoltWelcomeOverlayState extends State<BoltWelcomeOverlay> {
  VideoPlayerController? _controller;
  var _initialized = false;
  var _visible = true;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(widget.assetPath);
      _controller = controller;

      await controller.initialize();
      await controller.setLooping(false);
      await controller.setVolume(1);
      controller.addListener(_handleVideoProgress);
      await controller.play();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _initialized = true);
    } catch (error) {
      debugPrint('Erro ao carregar boas-vindas do Bolt: $error');
      _finish();
    }
  }

  void _handleVideoProgress() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final position = controller.value.position;
    final duration = controller.value.duration;
    if (duration > Duration.zero && position >= duration) {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_finished) return;
    _finished = true;

    if (mounted) {
      setState(() => _visible = false);
      await Future<void>.delayed(const Duration(milliseconds: 420));
    }

    widget.onFinished();
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleVideoProgress);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_initialized && controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 12,
              child: IconButton.filledTonal(
                tooltip: 'Pular',
                onPressed: _finish,
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
