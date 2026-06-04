import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  StreamSubscription<AuthState>? _subscription;
  Session? _session;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _session = _authService.currentSession;
    _syncProfile();
    _subscription = _authService.authStateChanges.listen((state) {
      setState(() {
        _session = state.session;
        _loading = false;
      });
      _syncProfile();
    });
    _loading = false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _syncProfile() async {
    if (_authService.currentSession == null) return;
    try {
      await _authService.syncCurrentUserProfile();
    } catch (_) {
      // Profile sync is retried on the next auth event or profile save.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _session == null ? const AuthScreen() : const HomeScreen();
  }
}
