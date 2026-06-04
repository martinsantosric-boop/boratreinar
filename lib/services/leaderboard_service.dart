import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/leaderboard_user.dart';

class LeaderboardService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<List<LeaderboardUser>> loadLeaderboard({int limit = 100}) async {
    try {
      final data = await _client
          .from('leaderboard')
          .select()
          .order('rank')
          .limit(limit);

      return data
          .map<LeaderboardUser>(
            (row) => LeaderboardUser.fromJson(row),
          )
          .toList();
    } catch (e) {
      // Se der erro 404 (view não existe), retornar lista vazia
      print('Erro ao carregar leaderboard: $e');
      return [];
    }
  }
}
