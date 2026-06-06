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
  late final TextEditingController _displayNameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text: widget.profile.displayName,
    );
    _gender = widget.profile.gender;
    _weightController = TextEditingController(
      text: _formatPositiveDouble(widget.profile.bodyWeightKg, decimals: 1),
    );
    _heightController = TextEditingController(
      text: _formatPositiveDouble(widget.profile.heightCm, decimals: 0),
    );
    _ageController = TextEditingController(
      text: widget.profile.age > 0 ? '${widget.profile.age}' : '',
    );
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile == widget.profile) return;
    _displayNameController.text = widget.profile.displayName;
    _gender = widget.profile.gender;
    _weightController.text = _formatPositiveDouble(
      widget.profile.bodyWeightKg,
      decimals: 1,
    );
    _heightController.text = _formatPositiveDouble(
      widget.profile.heightCm,
      decimals: 0,
    );
    _ageController.text = widget.profile.age > 0 ? '${widget.profile.age}' : '';
  }

  String _formatPositiveDouble(double value, {required int decimals}) {
    if (value <= 0) return '';
    return value.toStringAsFixed(decimals);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      displayName: _displayNameController.text.trim(),
      gender: _gender,
      bodyWeightKg: _optionalDouble(_weightController.text),
      heightCm: _optionalDouble(_heightController.text),
      age: _optionalInt(_ageController.text),
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
      displayName: _displayNameController.text.trim(),
      gender: _gender,
      bodyWeightKg:
          double.tryParse(_weightController.text.replaceAll(',', '.')) ??
          widget.profile.bodyWeightKg,
      heightCm:
          double.tryParse(_heightController.text.replaceAll(',', '.')) ??
          widget.profile.heightCm,
      age: int.tryParse(_ageController.text) ?? widget.profile.age,
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
                  'de passos. Esses dados sao opcionais.',
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
                controller: _displayNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Como gostaria de ser chamado',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender.isEmpty ? null : _gender,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: Icon(Icons.wc_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'masculino',
                    child: Text('Masculino'),
                  ),
                  DropdownMenuItem(value: 'feminino', child: Text('Feminino')),
                  DropdownMenuItem(value: 'outros', child: Text('Outros')),
                ],
                onChanged: (value) => setState(() => _gender = value ?? ''),
              ),
              const SizedBox(height: 12),
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
                  if ((value ?? '').trim().isEmpty) return null;
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
                  if ((value ?? '').trim().isEmpty) return null;
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
                  if ((value ?? '').trim().isEmpty) return null;
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
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Como calculamos suas estatisticas?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const _CalculationNote(
                  icon: Icons.local_fire_department_outlined,
                  text:
                      'Calorias sao estimadas usando peso, tempo, distancia e intensidade do treino.',
                ),
                const _CalculationNote(
                  icon: Icons.directions_walk,
                  text:
                      'Passos usam o sensor quando disponivel. Sem sensor, estimamos pela altura e distancia.',
                ),
                const _CalculationNote(
                  icon: Icons.terrain,
                  text:
                      'Altimetria vem do GPS e pode variar conforme sinal, cidade e aparelho.',
                ),
                const _CalculationNote(
                  icon: Icons.badge_outlined,
                  text:
                      'Nome e sexo sao opcionais. Peso, altura e idade melhoram as estimativas.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _optionalDouble(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;
  }

  int _optionalInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }
}

class _CalculationNote extends StatelessWidget {
  const _CalculationNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
