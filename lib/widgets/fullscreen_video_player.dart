import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Widget para exibir vídeo em tela cheia com botão de pular
class FullscreenVideoPlayer extends StatefulWidget {
  final String videoPath;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;

  const FullscreenVideoPlayer({
    super.key,
    required this.videoPath,
    required this.onComplete,
    this.onSkip,
  });

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();

      if (!mounted) return;

      setState(() => _isInitialized = true);

      // Inicia o vídeo automaticamente
      await _controller.play();

      // Listener para quando o vídeo terminar
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _onVideoComplete();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _hasError = true);
      // Se houver erro, chama onComplete depois de 1 segundo
      Future.delayed(const Duration(seconds: 1), _onVideoComplete);
    }
  }

  void _onVideoComplete() {
    if (!mounted) return;
    widget.onComplete();
  }

  void _onSkip() {
    _controller.pause();
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Azul escuro padrão
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Vídeo centralizado
          if (_isInitialized && !_hasError)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

          // Loading indicator
          if (!_isInitialized && !_hasError)
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Mensagem de erro
          if (_hasError)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.white54, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Erro ao carregar vídeo',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

          // Botão "Pular" no centro inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(
              child: TextButton(
                onPressed: _onSkip,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Colors.white54, width: 1),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pular',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.skip_next, size: 20),
                  ],
                ),
              ),
            ),
          ),

          // Indicador de progresso opcional (linha fina no topo)
          if (_isInitialized && !_hasError)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, VideoPlayerValue value, child) {
                  final progress =
                      value.position.inMilliseconds /
                      value.duration.inMilliseconds;
                  return LinearProgressIndicator(
                    value: progress.isNaN ? 0 : progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white54,
                    ),
                    minHeight: 2,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
