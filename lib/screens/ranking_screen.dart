import 'package:flutter/material.dart';

import '../models/leaderboard_user.dart';
import '../models/league.dart';
import '../services/leaderboard_service.dart';
import '../widgets/bolt_widget.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final _leaderboardService = LeaderboardService();
  late Future<List<LeaderboardUser>> _leaderboard;
  League? _selectedLeague;

  @override
  void initState() {
    super.initState();
    _leaderboard = _leaderboardService.loadLeaderboard();
  }

  void _reload() {
    setState(() {
      _leaderboard = _leaderboardService.loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _leaderboardService.currentUserId;

    return FutureBuilder<List<LeaderboardUser>>(
      future: _leaderboard,
      builder: (context, snapshot) {
        final users = _sortedUsers(snapshot.data ?? const []);
        final filteredUsers = _filterUsers(users);
        final currentUser = _findCurrentUser(users, currentUserId);
        final xpToOvertake = _xpToOvertake(users, currentUser);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            _RankingHeader(onRefresh: _reload),
            const SizedBox(height: 16),
            _LeagueFilterBar(
              selectedLeague: _selectedLeague,
              onChanged: (league) => setState(() => _selectedLeague = league),
            ),
            const SizedBox(height: 16),
            if (currentUser != null) ...[
              _CurrentUserCard(user: currentUser, xpToOvertake: xpToOvertake),
              const SizedBox(height: 16),
            ],
            if (snapshot.connectionState == ConnectionState.waiting)
              const _RankingLoading()
            else if (snapshot.hasError)
              _RankingError(onRetry: _reload)
            else
              _RankingContent(
                users: filteredUsers,
                currentUserId: currentUserId,
              ),
            const SizedBox(height: 16),
            const _RankingInfo(),
          ],
        );
      },
    );
  }

  List<LeaderboardUser> _sortedUsers(List<LeaderboardUser> users) {
    final sortedUsers = [...users]
      ..sort((a, b) {
        final positionCompare = a.position.compareTo(b.position);
        if (positionCompare != 0) return positionCompare;
        final xpCompare = b.xp.compareTo(a.xp);
        if (xpCompare != 0) return xpCompare;
        return b.totalKm.compareTo(a.totalKm);
      });
    return sortedUsers;
  }

  List<LeaderboardUser> _filterUsers(List<LeaderboardUser> users) {
    final selectedLeague = _selectedLeague;
    if (selectedLeague == null) return users;
    return users.where((user) => user.league == selectedLeague).toList();
  }

  LeaderboardUser? _findCurrentUser(
    List<LeaderboardUser> users,
    String? currentUserId,
  ) {
    if (currentUserId == null) return null;
    for (final user in users) {
      if (user.id == currentUserId) return user;
    }
    return null;
  }

  int? _xpToOvertake(
    List<LeaderboardUser> users,
    LeaderboardUser? currentUser,
  ) {
    if (currentUser == null) return null;

    final currentIndex = users.indexWhere((user) => user.id == currentUser.id);
    if (currentIndex <= 0) return null;

    final nextUser = users[currentIndex - 1];
    return (nextUser.xp - currentUser.xp + 1).clamp(1, 999999);
  }
}

class _LeagueFilterBar extends StatelessWidget {
  const _LeagueFilterBar({
    required this.selectedLeague,
    required this.onChanged,
  });

  final League? selectedLeague;
  final ValueChanged<League?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Todas'),
              selected: selectedLeague == null,
              visualDensity: VisualDensity.compact,
              onSelected: (_) => onChanged(null),
            ),
          ),
          ...League.values.map((league) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text('${league.emoji} ${league.displayName}'),
                selected: selectedLeague == league,
                visualDensity: VisualDensity.compact,
                onSelected: (_) => onChanged(league),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CurrentUserCard extends StatelessWidget {
  const _CurrentUserCard({required this.user, required this.xpToOvertake});

  final LeaderboardUser user;
  final int? xpToOvertake;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              foregroundColor: Colors.green.shade900,
              child: Text('#${user.position}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sua posicao',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    xpToOvertake == null
                        ? 'Voce esta no topo desta disputa.'
                        : 'Faltam $xpToOvertake XP para ultrapassar o proximo corredor.',
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

class _RankingHeader extends StatelessWidget {
  const _RankingHeader({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ranking Global',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Dados reais dos corredores em produção',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Atualizar ranking',
              onPressed: onRefresh,
              color: Colors.white,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingContent extends StatelessWidget {
  const _RankingContent({required this.users, required this.currentUserId});

  final List<LeaderboardUser> users;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const _EmptyRanking();
    }

    final podiumUsers = users.take(3).toList();
    final remainingUsers = users.skip(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (podiumUsers.length == 3) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PodiumCard(position: 2, user: podiumUsers[1], height: 100),
              const SizedBox(width: 8),
              _PodiumCard(position: 1, user: podiumUsers[0], height: 140),
              const SizedBox(width: 8),
              _PodiumCard(position: 3, user: podiumUsers[2], height: 80),
            ],
          ),
          const SizedBox(height: 24),
        ],
        Text(
          podiumUsers.length == 3 ? 'Demais posições' : 'Corredores',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        ...(podiumUsers.length == 3 ? remainingUsers : users).map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LeaderboardTile(
              user: user,
              isCurrentUser: user.id == currentUserId,
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.user, required this.isCurrentUser});

  final LeaderboardUser user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrentUser ? Colors.green.shade50 : null,
      shape: isCurrentUser
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.green.shade400, width: 1.4),
            )
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '#${user.position}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          isCurrentUser ? '${user.name} (voce)' : user.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${user.league.emoji} ${user.league.displayName}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user.xp} XP',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${user.totalKm.toStringAsFixed(0)} km',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.position,
    required this.user,
    required this.height,
  });

  final int position;
  final LeaderboardUser user;
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
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
              child: Text(medal, style: const TextStyle(fontSize: 40)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingLoading extends StatelessWidget {
  const _RankingLoading();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _RankingError extends StatelessWidget {
  const _RankingError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Ranking indisponível',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar os dados reais agora.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRanking extends StatelessWidget {
  const _EmptyRanking();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhum corredor no ranking ainda',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'O ranking será preenchido quando corredores reais completarem corridas e sincronizarem XP.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingInfo extends StatelessWidget {
  const _RankingInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
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
              'O ranking usa dados reais sincronizados com Supabase. Complete corridas, conquistas e missões diárias para ganhar XP e subir de posição.',
              style: TextStyle(color: Colors.blue.shade900),
            ),
          ],
        ),
      ),
    );
  }
}
