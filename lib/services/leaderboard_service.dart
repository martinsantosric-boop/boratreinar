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

      return data
          .map<LeaderboardUser>((row) => LeaderboardUser.fromJson(row))
          .toList();
    } catch (e) {
      debugPrint('Erro ao carregar leaderboard: $e');
      rethrow;
    }
  }
}
