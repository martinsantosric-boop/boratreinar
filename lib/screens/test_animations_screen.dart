import 'package:flutter/material.dart';
import '../widgets/fullscreen_video_player.dart';

/// Tela de teste para visualizar as animações do Bolt
class TestAnimationsScreen extends StatelessWidget {
  const TestAnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testar Animações do Bolt'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🎬 Animações do Bolt',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toque em um botão para testar a animação em tela cheia',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Botão 1: Ganhar XP
          _buildAnimationCard(
            context,
            title: '💫 Ganhar XP',
            description: 'Animação após completar uma corrida (1.8s)',
            videoPath: 'assets/bolt/expressions/ganhar_xp.mp4',
            color: Colors.blue,
            icon: Icons.bolt,
          ),

          const SizedBox(height: 16),

          // Botão 2: Missão Concluída
          _buildAnimationCard(
            context,
            title: '⭐ Missão Concluída',
            description: 'Celebração ao completar missão semanal (2.5s)',
            videoPath: 'assets/bolt/expressions/missao_concluida.mp4',
            color: Colors.orange,
            icon: Icons.emoji_events,
          ),

          const SizedBox(height: 16),

          // Botão 3: Ganhar Troféu
          _buildAnimationCard(
            context,
            title: '🏆 Ganhar Troféu',
            description: 'Épica conquista importante (3.5s)',
            videoPath: 'assets/bolt/expressions/ganhar_trofeu.mp4',
            color: Colors.amber,
            icon: Icons.military_tech,
          ),

          const SizedBox(height: 16),

          // Botão 4: Check Animado
          _buildAnimationCard(
            context,
            title: '✅ Check Missão',
            description: 'Feedback rápido de aprovação (1.2s)',
            videoPath: 'assets/bolt/expressions/check_animado.mp4',
            color: Colors.green,
            icon: Icons.check_circle,
          ),

          const SizedBox(height: 16),

          // Botão 5: Loop Idle
          _buildAnimationCard(
            context,
            title: '🔄 Loop Idle',
            description: 'Respiração natural em loop (2.5s)',
            videoPath: 'assets/bolt/expressions/idle_loop.mp4',
            color: Colors.purple,
            icon: Icons.ac_unit,
          ),

          const SizedBox(height: 32),

          // Informações
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Como usar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Gere os vídeos usando as IAs (Runway, Pika, Leonardo)\n'
                  '2. Salve em: assets/bolt/expressions/\n'
                  '3. Atualize pubspec.yaml com os novos assets\n'
                  '4. Execute: flutter pub get\n'
                  '5. Volte aqui e teste os vídeos!',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Teste sem vídeo (demonstração)
          ElevatedButton.icon(
            onPressed: () {
              _showTestVideo(context);
            },
            icon: const Icon(Icons.play_circle),
            label: const Text('Testar Player sem Vídeo (Demo)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B2A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationCard(
    BuildContext context, {
    required String title,
    required String description,
    required String videoPath,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _playAnimation(context, videoPath);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícone
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Seta
              Icon(Icons.play_arrow, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _playAnimation(BuildContext context, String videoPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullscreenVideoPlayer(
          videoPath: videoPath,
          onComplete: () {
            Navigator.of(context).pop();
            // Mostra mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Animação concluída! ✅'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          onSkip: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Animação pulada'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showTestVideo(BuildContext context) {
    // Mostra um exemplo sem vídeo real (para demonstração)
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D1B2A),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Player de Vídeo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este é um exemplo do player.\nOs vídeos aparecerão em tela cheia quando você adicioná-los.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              // Simula botão "Pular"
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
            ],
          ),
        ),
      ),
    );
  }
}
