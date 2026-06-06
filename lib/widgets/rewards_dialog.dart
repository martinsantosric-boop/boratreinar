import 'package:flutter/material.dart';

import '../models/league.dart';
import '../models/run_session.dart';
import '../services/gamification_service.dart';
import '../utils/run_formatters.dart';
import 'bolt_widget.dart';

class RewardsDialog extends StatelessWidget {
  const RewardsDialog({
    super.key,
    required this.result,
    required this.currentLeague,
    required this.run,
  });

  final GamificationResult result;
  final League currentLeague;
  final RunSession run;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bolt comemorando
              BoltWidget(
                expression: result.leveledUp
                    ? BoltExpression.trophy
                    : BoltExpression.excited,
                league: result.leveledUp ? result.newLeague : currentLeague,
                size: 120,
                showLeagueBadge: true,
              ),
              const SizedBox(height: 20),

              // Título
              Text(
                _getTitle(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                _getMessage(),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              _RunSummaryGrid(run: run),

              const SizedBox(height: 16),

              // XP ganho
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('⭐', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+${result.totalXpGained} XP',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.amber.shade900,
                              ),
                        ),
                        Text(
                          'Experiência ganha',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Nova liga
              if (result.leveledUp && result.newLeague != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade100, Colors.blue.shade100],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🎉 SUBIU DE LIGA! 🎉',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            result.newLeague!.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            result.newLeague!.displayName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Streak
              if (result.streakIncreased) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Text(
                        '${result.newStreak} dias seguidos!',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],

              // Conquistas
              if (result.newlyUnlockedAchievements.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  '🏆 Conquistas Desbloqueadas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...result.newlyUnlockedAchievements.map(
                  (achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Text(
                            achievement.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  achievement.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+${achievement.xpReward} XP',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Missões completadas
              if (result.completedMissions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  '✅ Missões Completadas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...result.completedMissions.map(
                  (mission) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Text(
                            mission.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mission.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+${mission.xpReward} XP',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Botão fechar
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (!result.hasRewards) {
      return 'Treino registrado!';
    }
    if (result.leveledUp) {
      return 'Incrível! Você subiu de liga!';
    }
    if (result.newlyUnlockedAchievements.isNotEmpty) {
      return 'Nova conquista desbloqueada!';
    }
    if (result.streakIncreased && result.newStreak >= 7) {
      return 'Você está em chamas! 🔥';
    }
    return 'Mais uma vitória!';
  }

  String _getMessage() {
    if (!result.hasRewards) {
      return 'Esse treino ficou salvo no historico. Treinos com 30 minutos ou mais liberam XP e recompensas.';
    }
    if (result.leveledUp) {
      return 'Continue assim e logo você estará no topo!';
    }
    if (result.streakIncreased && result.newStreak >= 7) {
      return 'Sua dedicação está construindo uma lenda!';
    }
    return 'Cada passo é um passo mais perto do seu objetivo!';
  }

  static Future<void> show(
    BuildContext context,
    GamificationResult result,
    League currentLeague,
    RunSession run,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          RewardsDialog(result: result, currentLeague: currentLeague, run: run),
    );
  }
}

class _RunSummaryGrid extends StatelessWidget {
  const _RunSummaryGrid({required this.run});

  final RunSession run;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.55,
      children: [
        _SummaryTile(
          label: 'Distancia',
          value: formatDistance(run.distanceMeters),
          icon: Icons.route,
        ),
        _SummaryTile(
          label: 'Tempo',
          value: formatDuration(run.duration),
          icon: Icons.timer_outlined,
        ),
        _SummaryTile(
          label: 'Pace',
          value: formatPace(run.paceSecondsPerKm),
          icon: Icons.speed,
        ),
        _SummaryTile(
          label: 'Passos',
          value: '${run.estimatedSteps}',
          icon: Icons.directions_walk,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
