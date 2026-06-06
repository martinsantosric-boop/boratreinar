import 'package:flutter/material.dart';

import '../models/gamification_state.dart';
import '../models/run_session.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/bolt_welcome_service.dart';
import '../services/gamification_service.dart';
import '../services/run_storage_service.dart';
import '../widgets/bolt_welcome_overlay.dart';
import '../utils/run_formatters.dart';
import '../widgets/bolt_widget.dart';
import '../widgets/metric_tile.dart';
import '../widgets/rewards_dialog.dart';
import '../widgets/run_card.dart';
import 'active_run_screen.dart';
import 'achievements_screen.dart';
import 'goals_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'ranking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.welcomeUserId});

  final String? welcomeUserId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final _boltWelcomeService = BoltWelcomeService();
  final _storage = RunStorageService();
  final _gamification = GamificationService();
  var _selectedIndex = 0;
  var _runs = <RunSession>[];
  var _weeklyGoalKm = 25.0;
  var _profile = const UserProfile();
  var _hasUserProfile = false;
  var _loading = true;
  var _showWelcomeOverlay = false;
  var _gamificationState = const GamificationState();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final runs = await _storage.loadRuns();
    final weeklyGoalKm = await _storage.loadWeeklyGoalKm();
    final localProfile = await _storage.loadUserProfile();
    final remoteProfile = await _loadRemoteProfile();
    final profile = remoteProfile == null
        ? localProfile
        : _mergeProfiles(
            localProfile: localProfile,
            remoteProfile: remoteProfile,
          );
    if (remoteProfile?.hasAnyData == true) {
      await _storage.saveUserProfile(profile);
    }
    final hasUserProfile =
        profile.hasAnyData || await _storage.hasUserProfile();
    final gamificationState = await _gamification.loadState();
    if (!mounted) return;
    setState(() {
      _runs = runs;
      _weeklyGoalKm = weeklyGoalKm;
      _profile = profile;
      _hasUserProfile = hasUserProfile;
      _gamificationState = gamificationState;
      _loading = false;
    });
    await _showWelcomeIfNeeded();
  }

  UserProfile _mergeProfiles({
    required UserProfile localProfile,
    required UserProfile remoteProfile,
  }) {
    return UserProfile(
      displayName: remoteProfile.displayName.trim().isNotEmpty
          ? remoteProfile.displayName
          : localProfile.displayName,
      gender: remoteProfile.gender.trim().isNotEmpty
          ? remoteProfile.gender
          : localProfile.gender,
      bodyWeightKg: remoteProfile.bodyWeightKg > 0
          ? remoteProfile.bodyWeightKg
          : localProfile.bodyWeightKg,
      heightCm: remoteProfile.heightCm > 0
          ? remoteProfile.heightCm
          : localProfile.heightCm,
      age: remoteProfile.age > 0 ? remoteProfile.age : localProfile.age,
    );
  }

  Future<UserProfile?> _loadRemoteProfile() async {
    if (widget.welcomeUserId == null) return null;

    try {
      return await _authService.loadCurrentUserProfile();
    } catch (error) {
      debugPrint('Erro ao carregar perfil remoto: $error');
      return null;
    }
  }

  Future<void> _showWelcomeIfNeeded() async {
    final userId = widget.welcomeUserId;
    final shouldShow = await _boltWelcomeService.shouldShowForUser(userId);
    if (!mounted || !shouldShow) return;

    setState(() => _showWelcomeOverlay = true);
  }

  Future<void> _finishWelcome() async {
    final userId = widget.welcomeUserId;
    if (userId != null) {
      await _boltWelcomeService.markSeenForUser(userId);
    }

    if (!mounted) return;
    setState(() => _showWelcomeOverlay = false);
  }

  Future<void> _startRun() async {
    final run = await Navigator.of(context).push<RunSession>(
      MaterialPageRoute(builder: (_) => ActiveRunScreen(profile: _profile)),
    );

    if (run == null) return;

    await _storage.saveRun(run);

    // Processa gamificação
    final result = await _gamification.processRun(run, [run, ..._runs]);

    await _loadData();

    if (!mounted) return;

    // Mostra dialog de recompensas se houver
    if (result.hasRewards) {
      await RewardsDialog.show(
        context,
        result,
        _gamificationState.currentLeague,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Corrida salva no historico.')),
      );
    }
  }

  Future<void> _saveManualRun(RunSession run) async {
    await _storage.saveRun(run);
    await _loadData();
  }

  Future<void> _deleteRun(String id) async {
    await _storage.deleteRun(id);
    await _loadData();
  }

  Future<void> _saveGoal(double goalKm) async {
    await _storage.saveWeeklyGoalKm(goalKm);
    await _loadData();
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _storage.saveUserProfile(profile);
    await _authService.updateProfileMetrics(profile);
    await _loadData();
  }

  Future<void> _signOut() async {
    await _authService.signOut();
  }

  void _requestProfileData() {
    setState(() => _selectedIndex = 5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Atualize seus dados quando quiser para melhorar as analises.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardTab(
        runs: _runs,
        weeklyGoalKm: _weeklyGoalKm,
        hasUserProfile: _hasUserProfile,
        gamificationState: _gamificationState,
        onStartRun: _startRun,
        onOpenProfile: () => setState(() => _selectedIndex = 4),
        onOpenAchievements: () => setState(() => _selectedIndex = 2),
      ),
      HistoryScreen(
        runs: _runs,
        profile: _profile,
        hasUserProfile: _hasUserProfile,
        onRequestProfile: _requestProfileData,
        onDeleteRun: _deleteRun,
        onSaveManualRun: _saveManualRun,
      ),
      AchievementsScreen(gamificationState: _gamificationState),
      RankingScreen(),
      GoalsScreen(
        runs: _runs,
        weeklyGoalKm: _weeklyGoalKm,
        onSaveGoal: _saveGoal,
      ),
      ProfileScreen(profile: _profile, onSaveProfile: _saveProfile),
    ];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Cooper Maratonista'),
            actions: [
              IconButton(
                tooltip: 'Atualizar',
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: 'Sair',
                onPressed: _signOut,
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: pages[_selectedIndex],
                ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'Historico',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: 'Conquistas',
              ),
              NavigationDestination(
                icon: Icon(Icons.leaderboard_outlined),
                selectedIcon: Icon(Icons.leaderboard),
                label: 'Ranking',
              ),
              NavigationDestination(
                icon: Icon(Icons.flag_outlined),
                selectedIcon: Icon(Icons.flag),
                label: 'Metas',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
        if (_showWelcomeOverlay) BoltWelcomeOverlay(onFinished: _finishWelcome),
      ],
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.runs,
    required this.weeklyGoalKm,
    required this.hasUserProfile,
    required this.gamificationState,
    required this.onStartRun,
    required this.onOpenProfile,
    required this.onOpenAchievements,
  });

  final List<RunSession> runs;
  final double weeklyGoalKm;
  final bool hasUserProfile;
  final GamificationState gamificationState;
  final VoidCallback onStartRun;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenAchievements;

  @override
  Widget build(BuildContext context) {
    final totalDistance = runs.fold<double>(
      0,
      (sum, run) => sum + run.distanceMeters,
    );
    final weekStart = startOfWeek(DateTime.now());
    final weekDistance = runs
        .where((run) => run.startedAt.isAfter(weekStart))
        .fold<double>(0, (sum, run) => sum + run.distanceKm);

    final league = gamificationState.currentLeague;
    final dailyMissions = gamificationState.dailyMissions;
    final completedMissions = dailyMissions.where((m) => m.isCompleted).length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Card principal com Bolt
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    BoltWidget(
                      expression: gamificationState.currentStreak >= 7
                          ? BoltExpression.fire
                          : BoltExpression.ready,
                      league: league,
                      size: 120,
                      showLeagueBadge: true,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getBoltGreeting(),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${league.emoji} Liga ${league.displayName}',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: FilledButton.icon(
                                onPressed: onStartRun,
                                icon: const Icon(Icons.play_arrow, size: 20),
                                label: const Text('Bora treinar!'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(44),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // XP e progresso
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${gamificationState.totalXp} XP',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              if (gamificationState.xpToNextLeague != null)
                                Text(
                                  'Faltam ${gamificationState.xpToNextLeague} XP para ${league.emoji == '👑' ? 'manter' : 'subir de liga'}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: gamificationState.progressInCurrentLeague,
                      backgroundColor: Colors.purple.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.purple.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Streak e Conquistas
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(
                            '${gamificationState.currentStreak}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'dias seguidos',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: onOpenAchievements,
                    child: Card(
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Text(
                              '${gamificationState.unlockedAchievementsCount}/${gamificationState.achievements.length}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'conquistas',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Missões diárias
            if (dailyMissions.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Missões de hoje', style: _sectionTitleStyle(context)),
                  Text(
                    '$completedMissions/${dailyMissions.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...dailyMissions.map(
                (mission) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    color: mission.isCompleted
                        ? Colors.green.shade50
                        : Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mission.isCompleted
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                        child: mission.isCompleted
                            ? const Icon(Icons.check, color: Colors.green)
                            : Text(
                                mission.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                      ),
                      title: Text(
                        mission.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: mission.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${mission.xpReward} XP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Resumo estatístico
            Text('Resumo', style: _sectionTitleStyle(context)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.28,
              children: [
                MetricTile(
                  label: 'Total corrido',
                  value: formatDistance(totalDistance),
                  icon: Icons.route,
                ),
                MetricTile(
                  label: 'Treinos',
                  value: '${runs.length}',
                  icon: Icons.calendar_month,
                ),
                MetricTile(
                  label: 'Na semana',
                  value: '${weekDistance.toStringAsFixed(1)} km',
                  icon: Icons.trending_up,
                ),
                MetricTile(
                  label: 'XP Total',
                  value: '${gamificationState.totalXp}',
                  icon: Icons.star,
                ),
              ],
            ),

            if (!hasUserProfile) ...[
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Complete seu perfil'),
                  subtitle: const Text(
                    'Peso, altura e idade deixam calorias e passos mais precisos.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: onOpenProfile,
                ),
              ),
            ],

            const SizedBox(height: 16),
            Text('Últimas corridas', style: _sectionTitleStyle(context)),
            const SizedBox(height: 12),
            if (runs.isEmpty)
              const _EmptyState()
            else
              ...runs
                  .take(3)
                  .map(
                    (run) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RunCard(run: run),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  TextStyle? _sectionTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: 0.4,
    );
  }

  String _getBoltGreeting() {
    final hour = DateTime.now().hour;
    final streak = gamificationState.currentStreak;

    if (streak >= 7) {
      return 'Você está em chamas! 🔥';
    }

    if (hour < 12) {
      return 'Bom dia! Bora treinar?';
    } else if (hour < 18) {
      return 'Boa tarde! Vamos correr?';
    } else {
      return 'Boa noite! Que tal um treino?';
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.directions_run,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma corrida registrada ainda.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
