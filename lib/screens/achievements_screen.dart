import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/achievement.dart';
import '../models/gamification_state.dart';
import '../models/run_session.dart';
import '../utils/run_formatters.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    super.key,
    required this.gamificationState,
    required this.runs,
  });

  final GamificationState gamificationState;
  final List<RunSession> runs;

  @override
  Widget build(BuildContext context) {
    final unlocked = gamificationState.achievements
        .where((a) => a.isUnlocked)
        .toList();
    final groupedAchievements = _groupAchievements(
      gamificationState.achievements,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conquistas',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            '${unlocked.length} de ${gamificationState.achievements.length} desbloqueadas',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value:
                      unlocked.length / gamificationState.achievements.length,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...groupedAchievements.entries.expand((entry) {
          return [
            Text(
              entry.key,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...entry.value.map(
              (achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AchievementCard(
                  achievement: achievement,
                  progress: _progressFor(achievement),
                  onTap: () => _showAchievementDetail(context, achievement),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ];
        }),
      ],
    );
  }

  Map<String, List<Achievement>> _groupAchievements(
    List<Achievement> achievements,
  ) {
    final groups = <String, List<Achievement>>{
      'Iniciante': [],
      'Consistencia': [],
      'Distancia': [],
      'Performance': [],
      'Lendarias': [],
    };

    for (final achievement in achievements) {
      groups[_categoryFor(achievement.type)]!.add(achievement);
    }

    return groups..removeWhere((_, value) => value.isEmpty);
  }

  String _categoryFor(AchievementType type) {
    return switch (type) {
      AchievementType.firstRun || AchievementType.totalRuns10 => 'Iniciante',
      AchievementType.streak3 ||
      AchievementType.streak7 ||
      AchievementType.streak30 ||
      AchievementType.consistency => 'Consistencia',
      AchievementType.distance5k ||
      AchievementType.distance10k ||
      AchievementType.distance21k => 'Distancia',
      AchievementType.speedRunner ||
      AchievementType.totalRuns50 => 'Performance',
      AchievementType.distance42k ||
      AchievementType.marathon ||
      AchievementType.centurion ||
      AchievementType.totalRuns100 => 'Lendarias',
    };
  }

  _AchievementProgress _progressFor(Achievement achievement) {
    if (achievement.isUnlocked) {
      return const _AchievementProgress(label: 'Concluida', value: 1);
    }

    final totalKm = runs.fold<double>(0, (sum, run) => sum + run.distanceKm);
    final maxKm = runs.fold<double>(
      0,
      (max, run) => run.distanceKm > max ? run.distanceKm : max,
    );
    final bestPace = runs.where((run) => run.paceSecondsPerKm > 0).fold<int?>(
      null,
      (best, run) {
        if (best == null || run.paceSecondsPerKm < best) {
          return run.paceSecondsPerKm;
        }
        return best;
      },
    );

    switch (achievement.type) {
      case AchievementType.firstRun:
        return _countProgress(runs.length, 1, 'corrida');
      case AchievementType.streak3:
        return _countProgress(gamificationState.currentStreak, 3, 'dias');
      case AchievementType.streak7:
        return _countProgress(gamificationState.currentStreak, 7, 'dias');
      case AchievementType.streak30:
        return _countProgress(gamificationState.currentStreak, 30, 'dias');
      case AchievementType.distance5k:
        return _distanceProgress(maxKm, 5);
      case AchievementType.distance10k:
        return _distanceProgress(maxKm, 10);
      case AchievementType.distance21k:
        return _distanceProgress(maxKm, 21);
      case AchievementType.distance42k:
      case AchievementType.marathon:
        return _distanceProgress(maxKm, 42);
      case AchievementType.totalRuns10:
        return _countProgress(runs.length, 10, 'treinos');
      case AchievementType.totalRuns50:
        return _countProgress(runs.length, 50, 'treinos');
      case AchievementType.totalRuns100:
        return _countProgress(runs.length, 100, 'treinos');
      case AchievementType.speedRunner:
        return _AchievementProgress(
          label: bestPace == null
              ? 'Alvo: pace abaixo de 5:00 /km'
              : 'Melhor pace: ${formatPace(bestPace)}',
          value: bestPace != null && bestPace < 300 ? 1 : 0,
        );
      case AchievementType.centurion:
        return _distanceProgress(totalKm, 100);
      case AchievementType.consistency:
        return const _AchievementProgress(
          label: 'Em desenvolvimento',
          value: 0,
        );
    }
  }

  _AchievementProgress _countProgress(int current, int target, String unit) {
    return _AchievementProgress(
      label: '$current de $target $unit',
      value: (current / target).clamp(0.0, 1.0),
    );
  }

  _AchievementProgress _distanceProgress(double currentKm, double targetKm) {
    return _AchievementProgress(
      label:
          '${currentKm.toStringAsFixed(1)} km de ${targetKm.toStringAsFixed(0)} km',
      value: (currentKm / targetKm).clamp(0.0, 1.0),
    );
  }

  void _showAchievementDetail(BuildContext context, Achievement achievement) {
    final progress = _progressFor(achievement);

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(achievement.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 42),
                ),
              ),
              const SizedBox(height: 12),
              Text(achievement.description),
              const SizedBox(height: 12),
              Text('Recompensa: +${achievement.xpReward} XP'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: progress.value),
              const SizedBox(height: 6),
              Text(progress.label),
              if (achievement.unlockedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Desbloqueada em ${DateFormat('dd/MM/yyyy').format(achievement.unlockedAt!)}',
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.progress,
    required this.onTap,
  });

  final Achievement achievement;
  final _AchievementProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.isUnlocked;

    return Card(
      color: unlocked ? Colors.green.shade50 : Colors.grey.shade100,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: unlocked
                    ? Colors.green.shade100
                    : Colors.grey.shade300,
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 22,
                    color: unlocked ? null : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: unlocked ? null : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        color: unlocked ? Colors.black87 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress.value),
                    const SizedBox(height: 4),
                    Text(
                      progress.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!unlocked)
                    const Icon(Icons.lock_outline, color: Colors.grey)
                  else
                    const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(height: 6),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementProgress {
  const _AchievementProgress({required this.label, required this.value});

  final String label;
  final double value;
}
