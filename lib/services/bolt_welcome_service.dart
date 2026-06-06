import 'package:shared_preferences/shared_preferences.dart';

class BoltWelcomeService {
  static const _keyPrefix = 'bolt_welcome_seen_user_';

  Future<bool> shouldShowForUser(String? userId) async {
    if (userId == null || userId.isEmpty) return false;

    final preferences = await SharedPreferences.getInstance();
    return !(preferences.getBool(_keyFor(userId)) ?? false);
  }

  Future<void> markSeenForUser(String userId) async {
    if (userId.isEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_keyFor(userId), true);
  }

  static String _keyFor(String userId) => '$_keyPrefix$userId';
}
