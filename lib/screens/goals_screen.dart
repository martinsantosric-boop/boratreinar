import 'package:flutter/material.dart';

import '../models/run_session.dart';
import '../utils/run_formatters.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
    required this.runs,
    required this.weeklyGoalKm,
    required this.onSaveGoal,
  });

  final List<RunSession> runs;
  final double weeklyGoalKm;
  final Future<void> Function(double goalKm) onSaveGoal;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late double _goalKm;

  @override
  void initState() {
    super.initState();
    _goalKm = widget.weeklyGoalKm;
  }

  @override
  void didUpdateWidget(covariant GoalsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weeklyGoalKm != widget.weeklyGoalKm) {
      _goalKm = widget.weeklyGoalKm;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = startOfWeek(now);
    final monthStart = DateTime(now.year, now.month);
    final weekKm = widget.runs
        .where((run) => run.startedAt.isAfter(weekStart))
        .fold<double>(0, (sum, run) => sum + run.distanceKm);
    final monthKm = widget.runs
        .where((run) => run.startedAt.isAfter(monthStart))
        .fold<double>(0, (sum, run) => sum + run.distanceKm);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meta semanal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_goalKm.toStringAsFixed(0)} km por semana',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Slider(
                  min: 5,
                  max: 120,
                  divisions: 23,
                  value: _goalKm.clamp(5, 120),
                  label: '${_goalKm.toStringAsFixed(0)} km',
                  onChanged: (value) => setState(() => _goalKm = value),
                ),
                FilledButton.icon(
                  onPressed: () => widget.onSaveGoal(_goalKm),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar meta'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ProgressCard(
          title: 'Progresso da semana',
          currentKm: weekKm,
          targetKm: _goalKm,
        ),
        const SizedBox(height: 12),
        _ProgressCard(
          title: 'Volume do mes',
          currentKm: monthKm,
          targetKm: _goalKm * 4,
        ),
        const SizedBox(height: 16),
        Text(
          'Planos sugeridos',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        const _PlanCard(
          title: '5K consistente',
          description: '3 treinos por semana com foco em criar rotina.',
          icon: Icons.looks_5,
        ),
        const SizedBox(height: 12),
        const _PlanCard(
          title: '10K evolutivo',
          description:
              'Alterna rodagens leves, ritmo e longo no fim de semana.',
          icon: Icons.filter_9_plus,
        ),
        const SizedBox(height: 12),
        const _PlanCard(
          title: 'Meia maratona',
          description: 'Prioriza volume semanal e pace controlado.',
          icon: Icons.directions_run,
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.currentKm,
    required this.targetKm,
  });

  final String title;
  final double currentKm;
  final double targetKm;

  @override
  Widget build(BuildContext context) {
    final progress = targetKm <= 0
        ? 0.0
        : (currentKm / targetKm).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              '${currentKm.toStringAsFixed(1)} de ${targetKm.toStringAsFixed(0)} km',
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(description),
      ),
    );
  }
}
