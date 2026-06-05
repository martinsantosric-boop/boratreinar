import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../models/user_profile.dart';
import 'auth_redirect.dart';

class AuthService {
  final _appLinks = AppLinks();

  SupabaseClient get _client => Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Stream<Uri> get authLinkChanges => _appLinks.uriLinkStream;

  Future<void> completePendingSignIn() async {
    if (kIsWeb) {
      await completeAuthCallback(Uri.base);
      return;
    }

    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        await completeAuthCallback(initialLink);
      }
    } catch (error) {
      debugPrint('Falha ao recuperar link inicial de login: $error');
    }
  }

  Future<bool> completeAuthCallback(Uri uri) async {
    if (!_isAuthCallback(uri)) return false;

    try {
      await _client.auth.getSessionFromUrl(uri);
      return _client.auth.currentSession != null;
    } on AuthException catch (error) {
      if (_client.auth.currentSession != null) return true;
      debugPrint('Falha ao concluir login pelo callback: ${error.message}');
      return false;
    } catch (error) {
      if (_client.auth.currentSession != null) return true;
      debugPrint('Falha ao concluir login pelo callback: $error');
      return false;
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

  bool _isAuthCallback(Uri uri) {
    return uri.queryParameters.containsKey('code') ||
        uri.fragment.contains('access_token') ||
        uri.fragment.contains('error_description') ||
        uri.queryParameters.containsKey('error_description');
  }
}
