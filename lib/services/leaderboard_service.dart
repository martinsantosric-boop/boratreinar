import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/leaderboard_user.dart';

class LeaderboardService {
  SupabaseClient get _client => Supabase.instance.client;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<List<LeaderboardUser>> loadLeaderboard({int limit = 100}) async {
    try {
      final data = await _client
          .from('leaderboard')
          .select()
          .order('rank')
          .limit(limit);

      final users = data
          .map<LeaderboardUser>((row) => LeaderboardUser.fromJson(row))
          .toList();

      return _deduplicateByUser(users);
    } catch (e) {
      debugPrint('Erro ao carregar leaderboard: $e');
      rethrow;
    }
  }

  List<LeaderboardUser> _deduplicateByUser(List<LeaderboardUser> users) {
    final byId = <String, LeaderboardUser>{};

    for (final user in users) {
      final savedUser = byId[user.id];
      if (savedUser == null || _isBetterRankingRow(user, savedUser)) {
        byId[user.id] = user;
      }
    }

    final sortedUsers = byId.values.toList()
      ..sort((a, b) {
        final xpCompare = b.xp.compareTo(a.xp);
        if (xpCompare != 0) return xpCompare;
        final distanceCompare = b.totalKm.compareTo(a.totalKm);
        if (distanceCompare != 0) return distanceCompare;
        return a.position.compareTo(b.position);
      });

    return [
      for (var index = 0; index < sortedUsers.length; index++)
        sortedUsers[index].copyWith(position: index + 1),
    ];
  }

  bool _isBetterRankingRow(LeaderboardUser candidate, LeaderboardUser saved) {
    if (candidate.xp != saved.xp) return candidate.xp > saved.xp;
    if (candidate.totalKm != saved.totalKm) {
      return candidate.totalKm > saved.totalKm;
    }
    return candidate.position < saved.position;
  }
}
