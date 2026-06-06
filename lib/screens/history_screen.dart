import 'package:flutter/material.dart';

import '../models/run_session.dart';
import '../models/user_profile.dart';
import '../widgets/run_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.runs,
    required this.profile,
    required this.hasUserProfile,
    required this.onRequestProfile,
    required this.onDeleteRun,
    required this.onSaveManualRun,
  });

  final List<RunSession> runs;
  final UserProfile profile;
  final bool hasUserProfile;
  final VoidCallback onRequestProfile;
  final Future<void> Function(String id) onDeleteRun;
  final Future<void> Function(RunSession run) onSaveManualRun;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!hasUserProfile) {
            onRequestProfile();
            return;
          }

          _openManualRunDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: runs.isEmpty
          ? const _HistoryEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: runs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final run = runs[index];
                return RunCard(
                  run: run,
                  onDelete: () => _confirmDelete(context, run),
                );
              },
            ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, RunSession run) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir corrida?'),
          content: const Text('Essa acao remove o treino do historico local.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await onDeleteRun(run.id);
    }
  }

  Future<void> _openManualRunDialog(BuildContext context) async {
    final run = await showDialog<RunSession>(
      context: context,
      builder: (_) => _ManualRunDialog(profile: profile),
    );

    if (run != null) {
      await onSaveManualRun(run);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Treino manual salvo.')));
    }
  }
}

class _ManualRunDialog extends StatefulWidget {
  const _ManualRunDialog({required this.profile});

  final UserProfile profile;

  @override
  State<_ManualRunDialog> createState() => _ManualRunDialogState();
}

class _ManualRunDialogState extends State<_ManualRunDialog> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _minutesController = TextEditingController();
  final _stepsController = TextEditingController();
  final _maxSpeedController = TextEditingController();
  final _elevationController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _distanceController.dispose();
    _minutesController.dispose();
    _stepsController.dispose();
    _maxSpeedController.dispose();
    _elevationController.dispose();
    _heartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final distanceKm = double.parse(
      _distanceController.text.replaceAll(',', '.'),
    );
    final minutes = int.parse(_minutesController.text);
    final steps = int.tryParse(_stepsController.text) ?? 0;
    final maxSpeedKmh = double.tryParse(
      _maxSpeedController.text.replaceAll(',', '.'),
    );
    final elevationGainMeters = double.tryParse(
      _elevationController.text.replaceAll(',', '.'),
    );
    final averageHeartRateBpm = int.tryParse(_heartRateController.text);
    final endedAt = DateTime.now();
    final duration = Duration(minutes: minutes);

    final run = RunSession(
      id: endedAt.microsecondsSinceEpoch.toString(),
      startedAt: endedAt.subtract(duration),
      endedAt: endedAt,
      duration: duration,
      distanceMeters: distanceKm * 1000,
      route: const [],
      steps: steps,
      bodyWeightKg: widget.profile.bodyWeightKg,
      heightCm: widget.profile.heightCm,
      age: widget.profile.age,
      maxSpeedKmh: maxSpeedKmh,
      elevationGainMeters: elevationGainMeters,
      averageHeartRateBpm: averageHeartRateBpm,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    Navigator.of(context).pop(run);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar treino'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Distancia em km',
                  prefixIcon: Icon(Icons.route),
                ),
                validator: (value) {
                  final parsed = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed <= 0) {
                    return 'Informe uma distancia valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tempo em minutos',
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Informe o tempo total.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stepsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Passos',
                  prefixIcon: Icon(Icons.directions_walk),
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) return null;
                  final parsed = int.tryParse(value!);
                  if (parsed == null || parsed < 0) {
                    return 'Informe um total de passos valido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _maxSpeedController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Velocidade maxima em km/h',
                  prefixIcon: Icon(Icons.flash_on),
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) return null;
                  final parsed = double.tryParse(value!.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Informe uma velocidade valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _elevationController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Ganho de elevacao em metros',
                  prefixIcon: Icon(Icons.terrain),
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) return null;
                  final parsed = double.tryParse(value!.replaceAll(',', '.'));
                  if (parsed == null || parsed < 0) {
                    return 'Informe uma altimetria valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _heartRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Frequencia cardiaca media',
                  prefixIcon: Icon(Icons.favorite),
                ),
                validator: (value) {
                  if ((value ?? '').isEmpty) return null;
                  final parsed = int.tryParse(value!);
                  if (parsed == null || parsed < 30 || parsed > 230) {
                    return 'Informe batimentos entre 30 e 230.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observacoes',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Seu historico de corrida vai aparecer aqui.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
