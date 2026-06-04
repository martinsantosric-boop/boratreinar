import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/run_session.dart';
import '../models/user_profile.dart';

class RunStorageService {
  static const _runsKey = 'runs';
  static const _weeklyGoalKey = 'weekly_goal_km';
  static const _userProfileKey = 'user_profile';

  Future<List<RunSession>> loadRuns() async {
    final prefs = await SharedPreferences.getInstance();
    final rawRuns = prefs.getStringList(_runsKey) ?? const [];

    final runs =
        rawRuns.map((raw) => RunSession.fromJson(jsonDecode(raw))).toList()
          ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    return runs;
  }

  Future<void> saveRun(RunSession run) async {
    final runs = await loadRuns();
    runs.removeWhere((savedRun) => savedRun.id == run.id);
    runs.insert(0, run);
    await _saveRuns(runs);
  }

  Future<void> deleteRun(String id) async {
    final runs = await loadRuns();
    runs.removeWhere((run) => run.id == id);
    await _saveRuns(runs);
  }

  Future<double> loadWeeklyGoalKm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_weeklyGoalKey) ?? 25;
  }

  Future<void> saveWeeklyGoalKm(double goalKm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_weeklyGoalKey, goalKm);
  }

  Future<UserProfile> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final rawProfile = prefs.getString(_userProfileKey);
    if (rawProfile == null) return const UserProfile();

    return UserProfile.fromJson(jsonDecode(rawProfile));
  }

  Future<bool> hasUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userProfileKey);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
  }

  Future<void> _saveRuns(List<RunSession> runs) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = runs.map((run) => jsonEncode(run.toJson())).toList();
    await prefs.setStringList(_runsKey, payload);
  }
}
