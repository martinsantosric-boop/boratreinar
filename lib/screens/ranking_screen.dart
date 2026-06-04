import 'package:flutter/material.dart';

import '../models/league.dart';
import '../widgets/bolt_widget.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar integração com Supabase para ranking real
    final mockLeaderboard = _generateMockLeaderboard();

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
                Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ranking Global',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Compete com corredores do mundo todo',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.86),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filtros de liga
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: League.values.map((league) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text('${league.emoji} ${league.displayName}'),
                  selected: false, // TODO: implementar filtro
                  onSelected: (_) {
                    // TODO: filtrar por liga
                  },
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Top 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 2º lugar
            _PodiumCard(
              position: 2,
              user: mockLeaderboard[1],
              height: 100,
            ),
            const SizedBox(width: 8),
            // 1º lugar
            _PodiumCard(
              position: 1,
              user: mockLeaderboard[0],
              height: 140,
            ),
            const SizedBox(width: 8),
            // 3º lugar
            _PodiumCard(
              position: 3,
              user: mockLeaderboard[2],
              height: 80,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Demais posições
        Text(
          'Demais Posições',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),

        ...mockLeaderboard.skip(3).toList().asMap().entries.map(
          (entry) {
            final index = entry.key + 4; // Posição começa em 4
            final user = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      '#$index',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${user.league.emoji} ${user.league.displayName}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${user.xp} XP',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${user.totalKm.toStringAsFixed(0)} km',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Info sobre como funciona
        Card(
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Como funciona o ranking?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'O ranking é atualizado em tempo real baseado no XP total de cada corredor. '
                  'Complete corridas, conquistas e missões diárias para ganhar XP e subir no ranking!',
                  style: TextStyle(color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<_LeaderboardUser> _generateMockLeaderboard() {
    return [
      _LeaderboardUser(
        name: 'Você',
        xp: 2450,
        league: League.gold,
        totalKm: 156.8,
        isCurrentUser: true,
      ),
      _LeaderboardUser(
        name: 'Ana Silva',
        xp: 3890,
        league: League.gold,
        totalKm: 245.3,
      ),
      _LeaderboardUser(
        name: 'Carlos Mendes',
        xp: 2201,
        league: League.silver,
        totalKm: 189.2,
      ),
      _LeaderboardUser(
        name: 'Juliana Costa',
        xp: 1876,
        league: League.silver,
        totalKm: 134.5,
      ),
      _LeaderboardUser(
        name: 'Pedro Santos',
        xp: 1654,
        league: League.silver,
        totalKm: 128.9,
      ),
      _LeaderboardUser(
        name: 'Maria Oliveira',
        xp: 1432,
        league: League.bronze,
        totalKm: 98.7,
      ),
      _LeaderboardUser(
        name: 'Lucas Ferreira',
        xp: 1289,
        league: League.bronze,
        totalKm: 87.6,
      ),
      _LeaderboardUser(
        name: 'Beatriz Lima',
        xp: 1145,
        league: League.bronze,
        totalKm: 76.4,
      ),
    ];
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.position,
    required this.user,
    required this.height,
  });

  final int position;
  final _LeaderboardUser user;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = position == 1
        ? Colors.amber.shade100
        : position == 2
            ? Colors.grey.shade200
            : Colors.orange.shade100;

    final medal = position == 1
        ? '🥇'
        : position == 2
            ? '🥈'
            : '🥉';

    return Expanded(
      child: Column(
        children: [
          BoltWidget(
            expression: BoltExpression.trophy,
            league: user.league,
            size: position == 1 ? 80 : 60,
            showLeagueBadge: true,
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: position == 1 ? 14 : 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${user.xp} XP',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border.all(
                color: position == 1
                    ? Colors.amber.shade300
                    : position == 2
                        ? Colors.grey.shade400
                        : Colors.orange.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                medal,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardUser {
  const _LeaderboardUser({
    required this.name,
    required this.xp,
    required this.league,
    required this.totalKm,
    this.isCurrentUser = false,
  });

  final String name;
  final int xp;
  final League league;
  final double totalKm;
  final bool isCurrentUser;
}
