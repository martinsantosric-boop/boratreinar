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
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewportHeight = constraints.maxHeight;
          final viewportWidth = constraints.maxWidth;
          final compact = viewportHeight < 720 || viewportWidth < 420;
          final logoFontSize = compact ? 34.0 : 42.0;
          final sloganFontSize = compact ? 16.0 : 20.0;
          final topHeight = (viewportHeight * (compact ? 0.56 : 0.6)).clamp(
            compact ? 320.0 : 390.0,
            compact ? 380.0 : 520.0,
          );
          final loginMinHeight = (viewportHeight - topHeight).clamp(
            compact ? 260.0 : 300.0,
            viewportHeight,
          );

          return Stack(
            children: [
              Container(
                height: topHeight + 24,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0D1B2A), Color(0xFF1E3A5F)],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewportHeight),
                  child: Column(
                    children: [
                      SizedBox(
                        height: topHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const BoltLoginMedia(
                              assetPath: 'assets/bolt/boratreinargift.mp4',
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: 0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(
                                      0xFF0D1B2A,
                                    ).withValues(alpha: 0.2),
                                    const Color(
                                      0xFF0D1B2A,
                                    ).withValues(alpha: 0.78),
                                  ],
                                ),
                              ),
                            ),
                            SafeArea(
                              bottom: false,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    24,
                                    24,
                                    24,
                                    compact ? 30 : 40,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '⚡ Bora Treinar',
                                        maxLines: 1,
                                        style: theme.textTheme.displayMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: logoFontSize,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Um passo de cada vez',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: Colors.white.withValues(
                                                alpha: 0.92,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              fontSize: sloganFontSize,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(minHeight: loginMinHeight),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              32,
                              compact ? 32 : 40,
                              32,
                              compact ? 28 : 32,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Entre e comece sua jornada',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0D1B2A),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Ganhe XP, suba de liga, conquiste badges e compete com corredores do mundo todo!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: compact ? 24 : 32),
                                FilledButton.icon(
                                  onPressed: _loading
                                      ? null
                                      : _signInWithGoogle,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D1B2A),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(52),
                                  ),
                                  icon: _loading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Icon(Icons.login),
                                  label: const Text('Entrar com Google'),
                                ),
                                if (_errorMessage != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red.shade200,
                                      ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
