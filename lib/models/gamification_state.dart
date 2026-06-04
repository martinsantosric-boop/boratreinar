import 'achievement.dart';
import 'daily_mission.dart';
import 'league.dart';

class GamificationState {
  const GamificationState({
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastRunDate,
    this.achievements = const [],
    this.dailyMissions = const [],
  });

  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastRunDate;
  final List<Achievement> achievements;
  final List<DailyMission> dailyMissions;

  League get currentLeague => League.fromXp(totalXp);

  int get xpInCurrentLeague => totalXp - currentLeague.minXp;

  int? get xpToNextLeague {
    final next = currentLeague.nextLevelXp;
    if (next == null) return null;
    return next - totalXp;
  }

  double get progressInCurrentLeague {
    final next = currentLeague.nextLevelXp;
    if (next == null) return 1.0;
    final levelXp = next - currentLeague.minXp;
    return (xpInCurrentLeague / levelXp).clamp(0.0, 1.0);
  }

  int get unlockedAchievementsCount {
    return achievements.where((a) => a.isUnlocked).length;
  }

  int get completedDailyMissionsCount {
    return dailyMissions.where((m) => m.isCompleted).length;
  }

  GamificationState copyWith({
    int? totalXp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastRunDate,
    List<Achievement>? achievements,
    List<DailyMission>? dailyMissions,
  }) {
    return GamificationState(
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastRunDate: lastRunDate ?? this.lastRunDate,
      achievements: achievements ?? this.achievements,
      dailyMissions: dailyMissions ?? this.dailyMissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastRunDate': lastRunDate?.toIso8601String(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'dailyMissions': dailyMissions.map((m) => m.toJson()).toList(),
    };
  }

  factory GamificationState.fromJson(Map<String, dynamic> json) {
    return GamificationState(
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastRunDate: json['lastRunDate'] != null
          ? DateTime.parse(json['lastRunDate'] as String)
          : null,
      achievements: ((json['achievements'] as List<dynamic>?) ?? [])
          .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
          .toList(),
      dailyMissions: ((json['dailyMissions'] as List<dynamic>?) ?? [])
          .map((m) => DailyMission.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
