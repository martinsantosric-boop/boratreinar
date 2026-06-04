import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../widgets/metric_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onSaveProfile,
  });

  final UserProfile profile;
  final Future<void> Function(UserProfile profile) onSaveProfile;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.profile.bodyWeightKg.toStringAsFixed(1),
    );
    _heightController = TextEditingController(
      text: widget.profile.heightCm.toStringAsFixed(0),
    );
    _ageController = TextEditingController(text: '${widget.profile.age}');
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile == widget.profile) return;
    _weightController.text = widget.profile.bodyWeightKg.toStringAsFixed(1);
    _heightController.text = widget.profile.heightCm.toStringAsFixed(0);
    _ageController.text = '${widget.profile.age}';
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      bodyWeightKg: double.parse(_weightController.text.replaceAll(',', '.')),
      heightCm: double.parse(_heightController.text.replaceAll(',', '.')),
      age: int.parse(_ageController.text),
    );

    await widget.onSaveProfile(profile);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserProfile(
      bodyWeightKg: double.tryParse(
            _weightController.text.replaceAll(',', '.'),
          ) ??
          widget.profile.bodyWeightKg,
      heightCm: double.tryParse(_heightController.text.replaceAll(',', '.')) ??
          widget.profile.heightCm,
      age: int.tryParse(_ageController.text) ?? widget.profile.age,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perfil do corredor',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Peso, altura e idade refinam calorias e estimativas '
                  'de passos.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Peso em kg',
                  prefixIcon: Icon(Icons.monitor_weight_outlined),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed < 25 || parsed > 250) {
                    return 'Informe um peso valido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Altura em cm',
                  prefixIcon: Icon(Icons.height),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = double.tryParse(
                    (value ?? '').replaceAll(',', '.'),
                  );
                  if (parsed == null || parsed < 100 || parsed > 230) {
                    return 'Informe uma altura valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 10 || parsed > 100) {
                    return 'Informe uma idade valida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salvar perfil'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.28,
          children: [
            MetricTile(
              label: 'Passos por km',
              value: '${profile.stepsPerKm}',
              icon: Icons.directions_walk,
            ),
            MetricTile(
              label: 'Passada estimada',
              value: '${profile.strideLengthMeters.toStringAsFixed(2)} m',
              icon: Icons.straighten,
            ),
          ],
        ),
      ],
    );
  }
}
