import 'package:flutter/material.dart';

import '../models/run_session.dart';
import '../utils/run_formatters.dart';

class GoalsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        GoalsSection(
          runs: runs,
          weeklyGoalKm: weeklyGoalKm,
          onSaveGoal: onSaveGoal,
          showTitle: false,
        ),
      ],
    );
  }
}

class GoalsSection extends StatefulWidget {
  const GoalsSection({
    super.key,
    required this.runs,
    required this.weeklyGoalKm,
    required this.onSaveGoal,
    this.showTitle = true,
  });

  final List<RunSession> runs;
  final double weeklyGoalKm;
  final Future<void> Function(double goalKm) onSaveGoal;
  final bool showTitle;

  @override
  State<GoalsSection> createState() => _GoalsSectionState();
}

class _GoalsSectionState extends State<GoalsSection> {
  late double _goalKm;

  @override
  void initState() {
    super.initState();
    _goalKm = widget.weeklyGoalKm;
  }

  @override
  void didUpdateWidget(covariant GoalsSection oldWidget) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showTitle) ...[
          Text(
            'Metas',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
        ],
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [5, 10, 25, 42].map((goal) {
                    return ChoiceChip(
                      label: Text('$goal km'),
                      selected: _goalKm.round() == goal,
                      onSelected: (_) =>
                          setState(() => _goalKm = goal.toDouble()),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Diminuir meta',
                      onPressed: () => _adjustGoal(-1),
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Aumentar meta',
                      onPressed: () => _adjustGoal(1),
                      icon: const Icon(Icons.add),
                    ),
                    FilledButton.icon(
                      onPressed: () => widget.onSaveGoal(_goalKm),
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar meta'),
                    ),
                  ],
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
        _PlanCard(
          title: '5K consistente',
          description: '3 treinos por semana com foco em criar rotina.',
          icon: Icons.looks_5,
          targetKm: 5,
          onApply: _applyPlan,
        ),
        const SizedBox(height: 12),
        _PlanCard(
          title: '10K evolutivo',
          description: '4 treinos por semana alternando leve, ritmo e longo.',
          icon: Icons.filter_9_plus,
          targetKm: 10,
          onApply: _applyPlan,
        ),
        const SizedBox(height: 12),
        _PlanCard(
          title: 'Meia maratona',
          description: '4 a 5 treinos por semana com volume progressivo.',
          icon: Icons.directions_run,
          targetKm: 42,
          onApply: _applyPlan,
        ),
      ],
    );
  }

  void _adjustGoal(double delta) {
    setState(() => _goalKm = (_goalKm + delta).clamp(5, 120));
  }

  Future<void> _applyPlan(double targetKm) async {
    setState(() => _goalKm = targetKm);
    await widget.onSaveGoal(targetKm);
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
    required this.targetKm,
    required this.onApply,
  });

  final String title;
  final String description;
  final IconData icon;
  final double targetKm;
  final Future<void> Function(double targetKm) onApply;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  child: Icon(icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => onApply(targetKm),
                child: const Text('Aplicar plano'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
