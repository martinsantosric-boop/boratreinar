import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/bolt_login_media.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService();
  var _loading = false;
  String? _errorMessage;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithGoogle();
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Falha ao entrar com Google: $error');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Fundo azul escuro ocupando topo
          Container(
            height: size.height * 0.6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1B2A), // Azul escuro
                  Color(0xFF1E3A5F), // Azul médio
                ],
              ),
            ),
          ),

          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Topo com Bolt GIGANTE
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Bolt GIGANTE
                        const BoltLoginMedia(
                          assetPath: 'assets/bolt/boratreinargift.mp4',
                          size: 250, // Tamanho fixo grande
                        ),
                        const SizedBox(height: 24),
                        // Logo/Nome
                        Text(
                          '⚡ Bora Treinar',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 42,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Slogan
                        Text(
                          'Um passo de cada vez',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Card inferior branco com login
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Título
                          Text(
                            'Entre e comece sua jornada',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D1B2A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          // Descrição
                          Text(
                            'Ganhe XP, suba de liga, conquiste badges e compete com corredores do mundo todo!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Botão de Login
                          FilledButton.icon(
                            onPressed: _loading ? null : _signInWithGoogle,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0D1B2A),
                              foregroundColor: Colors.white,
                            ),
                            icon: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.login),
                            label: const Text('Entrar com Google'),
                          ),

                          // Erro
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: theme.colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: theme.colorScheme.error,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
