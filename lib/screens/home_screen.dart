import 'package:flutter/material.dart';

import '../models/run_session.dart';
import '../models/user_profile.dart';
import '../services/run_storage_service.dart';
import '../utils/run_formatters.dart';
import '../widgets/metric_tile.dart';
import '../widgets/run_card.dart';
import 'active_run_screen.dart';
import 'goals_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = RunStorageService();
  var _selectedIndex = 0;
  var _runs = <RunSession>[];
  var _weeklyGoalKm = 25.0;
  var _profile = const UserProfile();
  var _hasUserProfile = false;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final runs = await _storage.loadRuns();
    final weeklyGoalKm = await _storage.loadWeeklyGoalKm();
    final profile = await _storage.loadUserProfile();
    final hasUserProfile = await _storage.hasUserProfile();
    if (!mounted) return;
    setState(() {
      _runs = runs;
      _weeklyGoalKm = weeklyGoalKm;
      _profile = profile;
      _hasUserProfile = hasUserProfile;
      _loading = false;
    });
  }

  Future<void> _startRun() async {
    if (!_hasUserProfile) {
      _requestProfileData();
      return;
    }

    final run = await Navigator.of(context).push<RunSession>(
      MaterialPageRoute(builder: (_) => ActiveRunScreen(profile: _profile)),
    );

    if (run == null) return;
    await _storage.saveRun(run);
    await _loadData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Corrida salva no historico.')),
    );
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
    await _loadData();
  }

  void _requestProfileData() {
    setState(() => _selectedIndex = 3);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Informe peso, altura e idade para melhorar as analises.',
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
        onStartRun: _startRun,
        onOpenProfile: () => setState(() => _selectedIndex = 3),
      ),
      HistoryScreen(
        runs: _runs,
        profile: _profile,
        hasUserProfile: _hasUserProfile,
        onRequestProfile: _requestProfileData,
        onDeleteRun: _deleteRun,
        onSaveManualRun: _saveManualRun,
      ),
      GoalsScreen(
        runs: _runs,
        weeklyGoalKm: _weeklyGoalKm,
        onSaveGoal: _saveGoal,
      ),
      ProfileScreen(profile: _profile, onSaveProfile: _saveProfile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooper Maratonista'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
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
            icon: Icon(Icons.speed_outlined),
            selectedIcon: Icon(Icons.speed),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historico',
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
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.runs,
    required this.weeklyGoalKm,
    required this.hasUserProfile,
    required this.onStartRun,
    required this.onOpenProfile,
  });

  final List<RunSession> runs;
  final double weeklyGoalKm;
  final bool hasUserProfile;
  final VoidCallback onStartRun;
  final VoidCallback onOpenProfile;

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
    final bestPace = runs
        .where((run) => run.paceSecondsPerKm > 0)
        .map((run) => run.paceSecondsPerKm)
        .fold<int?>(
          null,
          (best, pace) => best == null || pace < best ? pace : best,
        );
    final progress = weeklyGoalKm == 0
        ? 0.0
        : (weekDistance / weeklyGoalKm).clamp(0.0, 1.0);

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
                  'Pronto para correr?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Acompanhe km, tempo, pace e progresso semanal.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: onStartRun,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar corrida'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!hasUserProfile) ...[
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
          const SizedBox(height: 16),
        ],
        Text(
          'Resumo',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
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
              label: 'Melhor pace',
              value: formatPace(bestPace ?? 0),
              icon: Icons.timer,
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
                  'Meta semanal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text(
                  '${weekDistance.toStringAsFixed(1)} de ${weeklyGoalKm.toStringAsFixed(0)} km',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ultimas corridas',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
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
    );
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
