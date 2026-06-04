import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/achievement.dart';
import '../models/daily_mission.dart';
import '../models/gamification_state.dart';
import '../models/league.dart';
import '../models/run_session.dart';

class GamificationService {
  static const _stateKey = 'gamification_state';

  Future<GamificationState> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final rawState = prefs.getString(_stateKey);
    if (rawState == null) {
      return _initializeState();
    }

    return GamificationState.fromJson(jsonDecode(rawState));
  }

  Future<void> saveState(GamificationState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateKey, jsonEncode(state.toJson()));
  }

  GamificationState _initializeState() {
    return GamificationState(
      achievements: AchievementType.values
          .map((type) => Achievement(type: type, isUnlocked: false))
          .toList(),
      dailyMissions: DailyMission.generateForDate(DateTime.now()),
    );
  }

  /// Calcula XP ganho em uma corrida
  int calculateRunXp(RunSession run) {
    int xp = 0;

    // XP base por completar a corrida
    xp += 30;

    // XP por distância (10 XP por km)
    xp += (run.distanceKm * 10).round();

    // XP por duração (1 XP por minuto)
    xp += run.duration.inMinutes;

    // Bônus por pace rápido
    if (run.paceSecondsPerKm > 0 && run.paceSecondsPerKm < 300) {
      // < 5 min/km
      xp += 50;
    } else if (run.paceSecondsPerKm > 0 && run.paceSecondsPerKm < 360) {
      // < 6 min/km
      xp += 25;
    }

    // Bônus por distância longa
    if (run.distanceKm >= 21) {
      xp += 100; // Meia maratona+
    } else if (run.distanceKm >= 10) {
      xp += 50; // 10K+
    } else if (run.distanceKm >= 5) {
      xp += 20; // 5K+
    }

    return xp;
  }

  /// Processa uma nova corrida e atualiza o estado de gamificação
  Future<GamificationResult> processRun(
    RunSession run,
    List<RunSession> allRuns,
  ) async {
    final state = await loadState();
    var newState = state;

    // Adiciona XP da corrida
    final runXp = calculateRunXp(run);
    newState = newState.copyWith(totalXp: state.totalXp + runXp);

    // Atualiza streak
    final streakResult = _updateStreak(state, run);
    newState = newState.copyWith(
      currentStreak: streakResult.currentStreak,
      longestStreak: streakResult.longestStreak,
      lastRunDate: run.startedAt,
    );

    // Verifica conquistas desbloqueadas
    final achievementResults = _checkAchievements(newState, allRuns, run);
    newState = newState.copyWith(achievements: achievementResults.achievements);

    // Adiciona XP das conquistas
    final achievementXp = achievementResults.newlyUnlocked
        .fold<int>(0, (sum, a) => sum + a.xpReward);
    newState = newState.copyWith(totalXp: newState.totalXp + achievementXp);

    // Atualiza missões diárias
    final missionResults = _updateDailyMissions(newState, run);
    newState = newState.copyWith(dailyMissions: missionResults.missions);

    // Adiciona XP das missões
    final missionXp =
        missionResults.completed.fold<int>(0, (sum, m) => sum + m.xpReward);
    newState = newState.copyWith(totalXp: newState.totalXp + missionXp);

    // Verifica mudança de liga
    final oldLeague = state.currentLeague;
    final newLeague = newState.currentLeague;
    final leveledUp = newLeague != oldLeague;

    await saveState(newState);

    return GamificationResult(
      totalXpGained: runXp + achievementXp + missionXp,
      runXp: runXp,
      newlyUnlockedAchievements: achievementResults.newlyUnlocked,
      completedMissions: missionResults.completed,
      leveledUp: leveledUp,
      newLeague: leveledUp ? newLeague : null,
      streakIncreased: streakResult.increased,
      newStreak: streakResult.currentStreak,
    );
  }

  _StreakResult _updateStreak(GamificationState state, RunSession run) {
    final lastRun = state.lastRunDate;
    if (lastRun == null) {
      return _StreakResult(currentStreak: 1, longestStreak: 1, increased: true);
    }

    final lastRunDay = DateTime(lastRun.year, lastRun.month, lastRun.day);
    final currentRunDay =
        DateTime(run.startedAt.year, run.startedAt.month, run.startedAt.day);
    final daysDiff = currentRunDay.difference(lastRunDay).inDays;

    if (daysDiff == 0) {
      // Mesma data, não altera streak
      return _StreakResult(
        currentStreak: state.currentStreak,
        longestStreak: state.longestStreak,
        increased: false,
      );
    } else if (daysDiff == 1) {
      // Dia consecutivo
      final newStreak = state.currentStreak + 1;
      return _StreakResult(
        currentStreak: newStreak,
        longestStreak: newStreak > state.longestStreak
            ? newStreak
            : state.longestStreak,
        increased: true,
      );
    } else {
      // Quebrou o streak
      return _StreakResult(
        currentStreak: 1,
        longestStreak: state.longestStreak,
        increased: false,
      );
    }
  }

  _AchievementResult _checkAchievements(
    GamificationState state,
    List<RunSession> allRuns,
    RunSession newRun,
  ) {
    final achievements = List<Achievement>.from(state.achievements);
    final newlyUnlocked = <Achievement>[];

    for (var i = 0; i < achievements.length; i++) {
      if (achievements[i].isUnlocked) continue;

      final shouldUnlock = _shouldUnlockAchievement(
        achievements[i].type,
        state,
        allRuns,
        newRun,
      );

      if (shouldUnlock) {
        achievements[i] = achievements[i].copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        newlyUnlocked.add(achievements[i]);
      }
    }

    return _AchievementResult(
      achievements: achievements,
      newlyUnlocked: newlyUnlocked,
    );
  }

  bool _shouldUnlockAchievement(
    AchievementType type,
    GamificationState state,
    List<RunSession> allRuns,
    RunSession newRun,
  ) {
    switch (type) {
      case AchievementType.firstRun:
        return allRuns.length >= 1;
      case AchievementType.streak3:
        return state.currentStreak >= 3;
      case AchievementType.streak7:
        return state.currentStreak >= 7;
      case AchievementType.streak30:
        return state.currentStreak >= 30;
      case AchievementType.distance5k:
        return allRuns.any((r) => r.distanceKm >= 5);
      case AchievementType.distance10k:
        return allRuns.any((r) => r.distanceKm >= 10);
      case AchievementType.distance21k:
        return allRuns.any((r) => r.distanceKm >= 21);
      case AchievementType.distance42k:
        return allRuns.any((r) => r.distanceKm >= 42);
      case AchievementType.totalRuns10:
        return allRuns.length >= 10;
      case AchievementType.totalRuns50:
        return allRuns.length >= 50;
      case AchievementType.totalRuns100:
        return allRuns.length >= 100;
      case AchievementType.speedRunner:
        return allRuns.any((r) => r.paceSecondsPerKm > 0 && r.paceSecondsPerKm < 300);
      case AchievementType.marathon:
        return allRuns.any((r) => r.distanceKm >= 42);
      case AchievementType.centurion:
        final totalKm = allRuns.fold<double>(0, (sum, r) => sum + r.distanceKm);
        return totalKm >= 100;
      case AchievementType.consistency:
        // TODO: implementar lógica de 4 semanas seguidas batendo meta
        return false;
    }
  }

  _MissionResult _updateDailyMissions(
    GamificationState state,
    RunSession run,
  ) {
    final today = DateTime.now();
    var missions = List<DailyMission>.from(state.dailyMissions);

    // Verifica se precisa gerar novas missões (novo dia)
    if (missions.isEmpty ||
        !_isSameDay(missions.first.date, today)) {
      missions = DailyMission.generateForDate(today);
    }

    final completed = <DailyMission>[];

    for (var i = 0; i < missions.length; i++) {
      if (missions[i].isCompleted) continue;

      final shouldComplete = _shouldCompleteMission(missions[i].type, run);
      if (shouldComplete) {
        missions[i] = missions[i].copyWith(isCompleted: true);
        completed.add(missions[i]);
      }
    }

    return _MissionResult(missions: missions, completed: completed);
  }

  bool _shouldCompleteMission(MissionType type, RunSession run) {
    switch (type) {
      case MissionType.runAnyDistance:
        return run.distanceMeters >= 100;
      case MissionType.run3km:
        return run.distanceKm >= 3;
      case MissionType.run5km:
        return run.distanceKm >= 5;
      case MissionType.runFor20Minutes:
        return run.duration.inMinutes >= 20;
      case MissionType.runFor30Minutes:
        return run.duration.inMinutes >= 30;
      case MissionType.maintainPace:
        return run.paceSecondsPerKm > 0 && run.paceSecondsPerKm < 360;
      case MissionType.takeSteps5k:
        return run.estimatedSteps >= 5000;
      case MissionType.takeSteps10k:
        return run.estimatedSteps >= 10000;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class GamificationResult {
  const GamificationResult({
    required this.totalXpGained,
    required this.runXp,
    required this.newlyUnlockedAchievements,
    required this.completedMissions,
    required this.leveledUp,
    required this.newLeague,
    required this.streakIncreased,
    required this.newStreak,
  });

  final int totalXpGained;
  final int runXp;
  final List<Achievement> newlyUnlockedAchievements;
  final List<DailyMission> completedMissions;
  final bool leveledUp;
  final League? newLeague;
  final bool streakIncreased;
  final int newStreak;

  bool get hasRewards =>
      totalXpGained > 0 ||
      newlyUnlockedAchievements.isNotEmpty ||
      completedMissions.isNotEmpty ||
      leveledUp;
}

class _StreakResult {
  const _StreakResult({
    required this.currentStreak,
    required this.longestStreak,
    required this.increased,
  });

  final int currentStreak;
  final int longestStreak;
  final bool increased;
}

class _AchievementResult {
  const _AchievementResult({
    required this.achievements,
    required this.newlyUnlocked,
  });

  final List<Achievement> achievements;
  final List<Achievement> newlyUnlocked;
}

class _MissionResult {
  const _MissionResult({
    required this.missions,
    required this.completed,
  });

  final List<DailyMission> missions;
  final List<DailyMission> completed;
}
