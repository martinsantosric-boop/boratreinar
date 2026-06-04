import 'package:flutter/material.dart';

import '../models/league.dart';

enum BoltExpression {
  happy,
  cool,
  excited,
  fire,
  trophy,
  sleeping,
  ready,
}

class BoltWidget extends StatelessWidget {
  const BoltWidget({
    super.key,
    this.expression = BoltExpression.ready,
    this.league,
    this.size = 120,
    this.showLeagueBadge = false,
  });

  final BoltExpression expression;
  final League? league;
  final double size;
  final bool showLeagueBadge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Aura de energia (efeito visual)
        if (expression == BoltExpression.fire ||
            expression == BoltExpression.excited)
          Container(
            width: size + 20,
            height: size + 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.yellow.withValues(alpha: 0.3),
                  Colors.orange.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),

        // Imagem do Bolt
        _buildBoltImage(),

        // Badge da liga
        if (showLeagueBadge && league != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getLeagueBorderColor(),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                league!.emoji,
                style: TextStyle(fontSize: size * 0.2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBoltImage() {
    // Tenta carregar imagem por liga primeiro, se não encontrar usa por expressão
    if (league != null && _leagueImageExists()) {
      return Image.asset(
        'assets/bolt/leagues/${league!.name}.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    // Tenta carregar por expressão
    return Image.asset(
      'assets/bolt/expressions/${expression.name}.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  bool _leagueImageExists() {
    // Imagens de liga têm prioridade quando showLeagueBadge = true
    return showLeagueBadge;
  }

  // Placeholder caso a imagem não exista
  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getBoltColor(),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.6),
          bottomLeft: Radius.circular(size * 0.3),
          bottomRight: Radius.circular(size * 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Raio no topo
          Positioned(
            top: size * 0.05,
            left: size * 0.35,
            child: Text(
              '⚡',
              style: TextStyle(fontSize: size * 0.3),
            ),
          ),
          // Rosto
          Positioned(
            top: size * 0.35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Olhos
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEye(),
                    SizedBox(width: size * 0.1),
                    _buildEye(),
                  ],
                ),
                SizedBox(height: size * 0.05),
                // Boca
                _buildMouth(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: size * 0.12,
      height: size * 0.15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.1),
      ),
      child: Center(
        child: Container(
          width: size * 0.06,
          height: size * 0.08,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildMouth() {
    if (expression == BoltExpression.sleeping) {
      return Text('😴', style: TextStyle(fontSize: size * 0.15));
    }

    return Container(
      width: size * 0.25,
      height: size * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(size * 0.15),
          bottomRight: Radius.circular(size * 0.15),
        ),
      ),
    );
  }

  Color _getBoltColor() {
    if (league != null) {
      switch (league!) {
        case League.bronze:
          return const Color(0xFF4A90E2);
        case League.silver:
          return const Color(0xFF5BA3F5);
        case League.gold:
          return const Color(0xFF3D7DD8);
        case League.diamond:
          return const Color(0xFF2E6BC7);
        case League.legendary:
          return const Color(0xFF1E5AB6);
      }
    }
    return const Color(0xFF007AFF); // Azul vibrante padrão
  }

  Color _getLeagueBorderColor() {
    switch (league!) {
      case League.bronze:
        return const Color(0xFFCD7F32);
      case League.silver:
        return const Color(0xFFC0C0C0);
      case League.gold:
        return const Color(0xFFFFD700);
      case League.diamond:
        return const Color(0xFFB9F2FF);
      case League.legendary:
        return const Color(0xFFFFD700);
    }
  }
}

class BoltMessage extends StatelessWidget {
  const BoltMessage({
    super.key,
    required this.message,
    this.expression = BoltExpression.ready,
    this.league,
  });

  final String message;
  final BoltExpression expression;
  final League? league;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            BoltWidget(
              expression: expression,
              league: league,
              size: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bolt diz:',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
