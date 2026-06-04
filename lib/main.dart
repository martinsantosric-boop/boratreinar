import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/auth_gate.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.publishableKey,
  );
  runApp(const CooperMaratonistaApp());
}

class CooperMaratonistaApp extends StatelessWidget {
  const CooperMaratonistaApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooper Maratonista',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: home ?? const AuthGate(),
    );
  }
}
