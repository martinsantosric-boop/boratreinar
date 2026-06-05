import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_profile.dart';
import 'auth_redirect.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> completePendingSignIn() async {
    final authCode = Uri.base.queryParameters['code'];
    if (authCode == null || authCode.isEmpty) return;

    try {
      await _client.auth.exchangeCodeForSession(authCode);
    } on AuthException {
      if (_client.auth.currentSession == null) rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      final response = await _client.auth.getOAuthSignInUrl(
        provider: OAuthProvider.google,
        redirectTo: SupabaseConfig.authRedirectUrl,
      );
      redirectToUrl(response.url);
      return;
    }

    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: SupabaseConfig.nativeAuthRedirectUrl,
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required UserProfile profile,
  }) async {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {
        if (profile.displayName.trim().isNotEmpty)
          'full_name': profile.displayName.trim(),
        if (profile.gender.trim().isNotEmpty) 'gender': profile.gender.trim(),
      },
    );
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
      'gender': metadata['gender'],
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
      'full_name': profile.displayName.trim().isEmpty
          ? null
          : profile.displayName.trim(),
      'gender': profile.gender.trim().isEmpty ? null : profile.gender.trim(),
      'body_weight_kg': profile.bodyWeightKg,
      'height_cm': profile.heightCm,
      'age': profile.age,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
