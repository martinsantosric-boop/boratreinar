import 'league.dart';

class LeaderboardUser {
  const LeaderboardUser({
    required this.id,
    required this.position,
    required this.name,
    required this.xp,
    required this.league,
    required this.totalKm,
    required this.currentStreak,
    this.avatarUrl,
  });

  final String id;
  final int position;
  final String name;
  final int xp;
  final League league;
  final double totalKm;
  final int currentStreak;
  final String? avatarUrl;

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    final xp = (json['total_xp'] as num?)?.toInt() ?? 0;

    return LeaderboardUser(
      id: json['id'] as String,
      position: (json['rank'] as num?)?.toInt() ?? 0,
      name: _displayName(json),
      xp: xp,
      league: _leagueFromJson(json['league'], xp),
      totalKm: (json['total_km'] as num?)?.toDouble() ?? 0,
      currentStreak: (json['current_streak'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  static String _displayName(Map<String, dynamic> json) {
    final fullName = (json['full_name'] as String?)?.trim();
    if (fullName != null && fullName.isNotEmpty) return fullName;

    final email = (json['email'] as String?)?.trim();
    if (email != null && email.isNotEmpty) return email.split('@').first;

    return 'Corredor';
  }

  static League _leagueFromJson(Object? value, int xp) {
    final leagueName = value as String?;
    if (leagueName == null) return League.fromXp(xp);

    return League.values.firstWhere(
      (league) => league.name == leagueName,
      orElse: () => League.fromXp(xp),
    );
  }
}
