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
                _Info(label: 'Passos', value: '${run.estimatedSteps}'),
                _Info(
                  label: 'Calorias',
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
                  label: 'Altimetria',
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
          ],
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
