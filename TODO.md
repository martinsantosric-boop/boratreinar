# ✅ TODO - Bora Treinar Gamificado

## 🔧 Ações Imediatas (Você precisa fazer)

### 1. Instalar/Verificar Flutter
```bash
# Verifique se o Flutter está instalado
flutter --version

# Se não estiver, siga: https://docs.flutter.dev/get-started/install
```

### 2. Instalar Dependências
```bash
cd d:\Projetos\boratreinar
flutter pub get
```

### 3. Verificar Compilação
```bash
flutter analyze
```

### 4. Rodar o App
```bash
# Para web
flutter run -d chrome

# Para Android (se tiver emulador)
flutter run

# Para Windows
flutter run -d windows
```

## 🎨 Gerar Assets do Bolt

### Opção 1: IA de Imagens (Recomendado)

Use **Midjourney**, **DALL-E 3**, ou **Leonardo.ai**:

#### Prompt base para o Bolt:
```
A cute 3D character named "Bolt", a vibrant blue (#007AFF) energetic droplet with a lightning bolt ⚡ shape on top of its head. Big expressive eyes, small sporty arms and legs, wearing modern running shoes and a fitness smartwatch on wrist. 3D render, clean white background, friendly smile, motivational vibe, Pixar style, high quality, 4K
```

#### Para cada expressão (7 total):

1. **Happy** (happy.png):
```
[prompt base] + smiling brightly, celebrating with arms up, joyful expression
```

2. **Cool** (cool.png):
```
[prompt base] + wearing cool sunglasses, confident pose, relaxed expression
```

3. **Excited** (excited.png):
```
[prompt base] + jumping with joy, sparkles and stars around, super excited expression
```

4. **Fire** (fire.png):
```
[prompt base] + surrounded by orange and yellow fire effect, determined expression, energy flowing
```

5. **Trophy** (trophy.png):
```
[prompt base] + holding a golden trophy above head, proud expression, confetti around
```

6. **Sleeping** (sleeping.png):
```
[prompt base] + eyes closed, sleepy expression, small "zzz" floating above, relaxed pose
```

7. **Ready** (ready.png):
```
[prompt base] + athletic running stance, energy aura glowing around body, ready to sprint expression
```

#### Para cada liga (5 total):

1. **Bronze** (bronze.png):
```
[prompt base ready stance] + basic design, slight bronze glow
```

2. **Silver** (silver.png):
```
[prompt base ready stance] + silver metallic details on body, shiny effect
```

3. **Gold** (gold.png):
```
[prompt base ready stance] + golden aura surrounding, golden details, warm glow
```

4. **Diamond** (diamond.png):
```
[prompt base ready stance] + diamond sparkles and particles floating around, crystalline shine, blue and white sparkles
```

5. **Legendary** (legendary.png):
```
[prompt base ready stance] + wearing an energy crown on head, giant lightning bolt on back, purple and gold aura, epic pose, legendary glow
```

### Opção 2: Usar Placeholders Temporários

O app já funciona com placeholders! Você pode:
- Deixar os placeholders por enquanto
- Usar emojis maiores
- Usar ícones SVG

### Onde salvar as imagens:
```
d:\Projetos\boratreinar\assets\bolt\expressions\
d:\Projetos\boratreinar\assets\bolt\leagues\
```

### Atualizar pubspec.yaml:
```yaml
flutter:
  assets:
    - assets/bolt/expressions/
    - assets/bolt/leagues/
```

## 🗄️ Configurar Supabase (Opcional - para Ranking Real)

### 1. Criar Tabela de Gamificação

SQL para executar no Supabase:

```sql
-- Tabela para gamificação dos usuários
CREATE TABLE user_gamification (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  total_xp INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_run_date TIMESTAMP WITH TIME ZONE,
  achievements JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Tabela para ranking (view materializada para performance)
CREATE MATERIALIZED VIEW leaderboard AS
SELECT 
  p.id,
  p.full_name,
  p.avatar_url,
  ug.total_xp,
  ug.current_streak,
  CASE 
    WHEN ug.total_xp >= 15000 THEN 'legendary'
    WHEN ug.total_xp >= 7000 THEN 'diamond'
    WHEN ug.total_xp >= 3000 THEN 'gold'
    WHEN ug.total_xp >= 1000 THEN 'silver'
    ELSE 'bronze'
  END as league,
  ROW_NUMBER() OVER (ORDER BY ug.total_xp DESC) as rank
FROM profiles p
JOIN user_gamification ug ON p.id = ug.user_id
ORDER BY ug.total_xp DESC;

-- Índice para performance
CREATE INDEX idx_user_gamification_xp ON user_gamification(total_xp DESC);
CREATE INDEX idx_user_gamification_user_id ON user_gamification(user_id);

-- RLS Policies
ALTER TABLE user_gamification ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view all gamification data"
  ON user_gamification FOR SELECT
  USING (true);

CREATE POLICY "Users can update own gamification data"
  ON user_gamification FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own gamification data"
  ON user_gamification FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Refresh automático do leaderboard a cada hora
CREATE EXTENSION IF NOT EXISTS pg_cron;
SELECT cron.schedule('refresh-leaderboard', '0 * * * *', $$
  REFRESH MATERIALIZED VIEW CONCURRENTLY leaderboard;
$$);
```

### 2. Atualizar GamificationService

Adicione sincronização com Supabase após salvar local:

```dart
Future<void> syncWithSupabase(GamificationState state) async {
  final client = Supabase.instance.client;
  final userId = client.auth.currentUser?.id;
  if (userId == null) return;
  
  await client.from('user_gamification').upsert({
    'user_id': userId,
    'total_xp': state.totalXp,
    'current_streak': state.currentStreak,
    'longest_streak': state.longestStreak,
    'last_run_date': state.lastRunDate?.toIso8601String(),
    'achievements': state.achievements.map((a) => a.toJson()).toList(),
    'updated_at': DateTime.now().toIso8601String(),
  });
}
```

### 3. Atualizar RankingScreen

Substitua mock data por dados reais:

```dart
Future<List<LeaderboardUser>> _loadLeaderboard() async {
  final client = Supabase.instance.client;
  final data = await client
      .from('leaderboard')
      .select()
      .limit(100);
  
  return data.map((row) => LeaderboardUser.fromJson(row)).toList();
}
```

## 🔔 Configurar Notificações (Opcional)

### 1. Firebase Cloud Messaging

Siga: https://firebase.google.com/docs/flutter/setup

### 2. Adicionar ao pubspec.yaml:
```yaml
dependencies:
  firebase_messaging: ^14.0.0
  flutter_local_notifications: ^16.0.0
```

### 3. Implementar NotificationService

Ver exemplo em: `lib/services/notification_service.dart` (criar)

## 🧪 Testes

### Testar XP:
1. Complete uma corrida pequena (1-2km)
2. Veja o dialog de recompensas
3. Confira se o XP aumentou

### Testar Streak:
1. Complete corrida hoje
2. Mude a data do sistema para amanhã
3. Complete outra corrida
4. Streak deve ser 2

### Testar Conquistas:
1. Complete sua primeira corrida → "Primeira Corrida" desbloqueia
2. Complete 3 corridas → "Dedicado" desbloqueia
3. Corra 5km → "5K Master" desbloqueia

### Testar Missões:
1. Veja as 3 missões do dia
2. Complete uma corrida que atenda os critérios
3. Missão deve marcar como completa

### Testar Liga:
1. Acumule 1000 XP
2. Veja o dialog "SUBIU DE LIGA!"
3. Bolt deve ter badge de Prata

## 📱 Build para Produção

### Web:
```bash
flutter build web --release
firebase deploy --only hosting
```

### Android:
```bash
flutter build appbundle --release
# Upload para Play Console
```

### iOS:
```bash
flutter build ipa --release
# Upload para App Store Connect
```

## 🐛 Possíveis Erros e Soluções

### "The method 'withValues' isn't defined for the type 'Color'"
- **Solução**: Atualize Flutter para versão 3.24+
```bash
flutter upgrade
```

### "Missing required dependencies"
- **Solução**: Execute `flutter pub get`

### "Assets not found"
- **Solução**: Adicione assets no `pubspec.yaml` e execute `flutter pub get`

### Erro de compilação no Windows
- **Solução**: Ative desktop support
```bash
flutter config --enable-windows-desktop
```

## 📞 Suporte

- **Flutter Docs**: https://docs.flutter.dev
- **Supabase Docs**: https://supabase.com/docs
- **Firebase Docs**: https://firebase.google.com/docs/flutter

---

**Comece pelos itens 1-4 de "Ações Imediatas"! 🚀**
