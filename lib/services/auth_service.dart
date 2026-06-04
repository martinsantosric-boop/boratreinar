import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import 'auth_redirect.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      final response = await _client.auth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );
      redirectToUrl(response.url);
      return;
    }

    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> syncCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final metadata = user.userMetadata ?? const <String, dynamic>{};
    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'full_name': metadata['full_name'] ?? metadata['name'],
      'avatar_url': metadata['avatar_url'] ?? metadata['picture'],
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateProfileMetrics(UserProfile profile) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'body_weight_kg': profile.bodyWeightKg,
      'height_cm': profile.heightCm,
      'age': profile.age,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
