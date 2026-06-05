import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/run_storage_service.dart';

enum _EmailAuthMode { login, signup }

class EmailAuthDialog extends StatefulWidget {
  const EmailAuthDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const EmailAuthDialog(),
    );
  }

  @override
  State<EmailAuthDialog> createState() => _EmailAuthDialogState();
}

class _EmailAuthDialogState extends State<EmailAuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final _storage = RunStorageService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  var _mode = _EmailAuthMode.login;
  var _loading = false;
  var _gender = '';
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _isSignup => _mode == _EmailAuthMode.signup;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      if (_isSignup) {
        final profile = UserProfile(
          displayName: _nameController.text.trim(),
          gender: _gender,
          bodyWeightKg: _optionalDouble(_weightController.text),
          heightCm: _optionalDouble(_heightController.text),
          age: _optionalInt(_ageController.text),
        );
        final response = await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          profile: profile,
        );
        await _storage.saveUserProfile(profile);

        if (!mounted) return;
        Navigator.of(context).pop();
        if (response.session == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro criado. Confirme seu email para entrar.'),
            ),
          );
        }
        return;
      }

      await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _friendlyAuthMessage(error.message));
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Nao foi possivel concluir: $error');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isSignup ? 'Criar cadastro' : 'Login';

    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<_EmailAuthMode>(
                  segments: const [
                    ButtonSegment(
                      value: _EmailAuthMode.login,
                      label: Text('Login'),
                      icon: Icon(Icons.login),
                    ),
                    ButtonSegment(
                      value: _EmailAuthMode.signup,
                      label: Text('Cadastro'),
                      icon: Icon(Icons.person_add_alt_1),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: _loading
                      ? null
                      : (selection) {
                          setState(() {
                            _mode = selection.single;
                            _errorMessage = null;
                          });
                        },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: _validatePassword,
                ),
                if (_isSignup) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Como gostaria de ser chamado',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().length < 2) {
                        return 'Informe como devemos chamar voce.';
                      }
                      return null;
                    },
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
                      DropdownMenuItem(
                        value: 'feminino',
                        child: Text('Feminino'),
                      ),
                      DropdownMenuItem(value: 'outros', child: Text('Outros')),
                    ],
                    onChanged: _loading
                        ? null
                        : (value) => setState(() => _gender = value ?? ''),
                    validator: (value) {
                      if ((value ?? '').isEmpty) return 'Selecione uma opcao.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Peso em kg (opcional)',
                      prefixIcon: Icon(Icons.monitor_weight_outlined),
                    ),
                    validator: (value) => _validateOptionalDouble(
                      value,
                      min: 25,
                      max: 250,
                      message: 'Informe um peso valido.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Altura em cm (opcional)',
                      prefixIcon: Icon(Icons.height),
                    ),
                    validator: (value) => _validateOptionalDouble(
                      value,
                      min: 100,
                      max: 230,
                      message: 'Informe uma altura valida.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Idade (opcional)',
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                    validator: (value) => _validateOptionalInt(
                      value,
                      min: 10,
                      max: 100,
                      message: 'Informe uma idade valida.',
                    ),
                  ),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_isSignup ? Icons.person_add_alt_1 : Icons.login),
          label: Text(_isSignup ? 'Cadastrar' : 'Entrar'),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    final email = (value ?? '').trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Informe um email valido.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 6) return 'Use pelo menos 6 caracteres.';
    return null;
  }

  String? _validateOptionalDouble(
    String? value, {
    required double min,
    required double max,
    required String message,
  }) {
    if ((value ?? '').trim().isEmpty) return null;
    final parsed = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (parsed == null || parsed < min || parsed > max) return message;
    return null;
  }

  String? _validateOptionalInt(
    String? value, {
    required int min,
    required int max,
    required String message,
  }) {
    if ((value ?? '').trim().isEmpty) return null;
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed < min || parsed > max) return message;
    return null;
  }

  double _optionalDouble(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.')) ?? 0;
  }

  int _optionalInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  String _friendlyAuthMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login')) return 'Email ou senha incorretos.';
    if (lower.contains('already registered')) {
      return 'Este email ja possui cadastro.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Confirme seu email antes de entrar.';
    }
    return message;
  }
}
