import 'package:flutter/material.dart';

import '../models/run_session.dart';
import '../utils/run_formatters.dart';

class RunCard extends StatelessWidget {
  const RunCard({super.key, required this.run, this.onDelete});

  final RunSession run;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.directions_run),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDistance(run.distanceMeters),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        formatDate(run.startedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _SourceChip(isGpsTracked: run.isGpsTracked),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    tooltip: 'Excluir treino',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Info(label: 'Tempo', value: formatDuration(run.duration)),
                _Info(label: 'Pace', value: formatPace(run.paceSecondsPerKm)),
                _Info(
                  label: run.steps > 0 ? 'Passos' : 'Passos est.',
                  value: '${run.estimatedSteps}',
                ),
                _Info(
                  label: 'Calorias est.',
                  value: '${run.estimatedCalories} kcal',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Info(
                  label: 'Vel. max',
                  value: formatSpeed(run.calculatedMaxSpeedKmh),
                ),
                _Info(
                  label: run.elevationGainMeters != null
                      ? 'Altimetria'
                      : 'Altim. est.',
                  value: formatElevationGain(run.calculatedElevationGainMeters),
                ),
                _Info(
                  label: 'Cadencia',
                  value: formatCadence(run.averageCadenceSpm),
                ),
                _Info(
                  label: 'FC media',
                  value: formatHeartRate(run.averageHeartRateBpm),
                ),
              ],
            ),
            if ((run.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(run.notes!),
            ],
            if (run.xpGained > 0 ||
                run.completedMissionTitles.isNotEmpty ||
                run.unlockedAchievementTitles.isNotEmpty ||
                run.locationDebugLogs.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (run.xpGained > 0)
                    _SmallBadge(text: '+${run.xpGained} XP'),
                  if (run.completedMissionTitles.isNotEmpty)
                    _SmallBadge(
                      text: '${run.completedMissionTitles.length} missoes',
                    ),
                  if (run.unlockedAchievementTitles.isNotEmpty)
                    _SmallBadge(
                      text:
                          '${run.unlockedAchievementTitles.length} conquistas',
                    ),
                  if (run.locationDebugLogs.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => _showGpsDebug(context),
                      icon: const Icon(Icons.bug_report_outlined, size: 18),
                      label: const Text('Debug GPS'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showGpsDebug(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Debug GPS'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: run.locationDebugLogs.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final log = run.locationDebugLogs[index];
              return Text(
                '${log.accepted ? 'Aceito' : 'Ignorado'} | '
                '${log.accuracy.toStringAsFixed(0)} m | '
                '+${log.deltaMeters.toStringAsFixed(1)} m | '
                'total ${log.accumulatedDistanceMeters.toStringAsFixed(1)} m\n'
                '${log.latitude.toStringAsFixed(6)}, ${log.longitude.toStringAsFixed(6)}',
              );
            },
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

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.amber.shade900,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.isGpsTracked});

  final bool isGpsTracked;

  @override
  Widget build(BuildContext context) {
    final color = isGpsTracked ? Colors.green : Colors.blueGrey;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.shade200),
        ),
        child: Text(
          isGpsTracked ? 'GPS' : 'Manual',
          style: TextStyle(
            color: color.shade800,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
