# 🎮 Implementação do Sistema de Gamificação - Bora Treinar

## ✅ FASE 1 COMPLETA - Fundação da Gamificação

### 📦 Novos Models Criados

#### `lib/models/league.dart`
- **5 Ligas**: Bronze 🥉, Prata 🥈, Ouro 🥇, Diamante 💎, Lendária 👑
- Sistema de progressão por XP:
  - Bronze: 0 - 1.000 XP
  - Prata: 1.000 - 3.000 XP
  - Ouro: 3.000 - 7.000 XP
  - Diamante: 7.000 - 15.000 XP
  - Lendária: 15.000+ XP

#### `lib/models/achievement.dart`
- **15 tipos de conquistas** diferentes:
  - Primeira corrida
  - Streaks (3, 7, 30 dias)
  - Distâncias (5K, 10K, 21K, 42K)
  - Total de corridas (10, 50, 100)
  - Velocista, Maratonista, Centurião, Consistência
- Cada conquista dá XP bonus ao desbloquear

#### `lib/models/daily_mission.dart`
- **8 tipos de missões diárias**:
  - Corra qualquer distância
  - Corra 3km / 5km
  - Corra por 20 / 30 minutos
  - Mantenha pace < 6:00 /km
  - Dê 5.000 / 10.000 passos
- Geração automática de 3 missões por dia
- Recompensa em XP ao completar

#### `lib/models/gamification_state.dart`
- Estado global da gamificação
- Rastreia: XP total, streak atual/mais longo, conquistas, missões
- Cálculo automático de liga e progresso

### 🎯 Novo Service

#### `lib/services/gamification_service.dart`
- **Cálculo de XP por corrida**:
  - 30 XP base
  - 10 XP por km
  - 1 XP por minuto
  - Bônus por pace rápido
  - Bônus por distância longa
- **Detecção de streak**:
  - Dias consecutivos de treino
  - Quebra de streak automática
- **Desbloqueio automático de conquistas**
- **Checagem de missões diárias completadas**
- **Persistência em SharedPreferences**

### 🎨 Novos Widgets

#### `lib/widgets/bolt_widget.dart`
- Widget do personagem Bolt animado (placeholder até ter assets)
- **7 expressões**: happy, cool, excited, fire, trophy, sleeping, ready
- Badge de liga opcional
- Aura de energia para expressões especiais
- Cores adaptam por liga

#### `lib/widgets/rewards_dialog.dart`
- Dialog de recompensas pós-corrida
- Mostra:
  - XP ganho total
  - Nova liga (se subiu)
  - Streak (se aumentou)
  - Conquistas desbloqueadas
  - Missões completadas
- Bolt comemorando

### 📱 Telas Atualizadas

#### `lib/screens/home_screen.dart`
- **6 abas agora** (era 4):
  1. Home (Dashboard gamificada)
  2. Histórico
  3. **🆕 Conquistas**
  4. **🆕 Ranking**
  5. Metas
  6. Perfil
- Dashboard completamente redesenhada:
  - Card principal com Bolt
  - XP e barra de progresso da liga
  - Streak de dias consecutivos
  - Contagem de conquistas
  - Missões diárias com checkboxes
  - Resumo estatístico
- Integração completa com gamificação

#### `lib/screens/achievements_screen.dart` 🆕
- Lista todas as conquistas
- Separadas em Desbloqueadas / Bloqueadas
- Mostra data de desbloqueio
- Barra de progresso geral
- XP reward de cada conquista

#### `lib/screens/ranking_screen.dart` 🆕
- Ranking global (mock data por enquanto)
- Pódio top 3 com Bolt e medalhas
- Lista dos demais competidores
- Filtros por liga
- Mostra XP e km total de cada corredor
- Card informativo sobre como funciona

#### `lib/screens/auth_screen.dart`
- Redesenhada estilo Duolingo
- Bolt em destaque
- Tela verde vibrante
- Card branco arredondado na base
- Mensagem motivacional

### 🎨 Tema Atualizado

#### `lib/theme/app_theme.dart`
- **Cores vibrantes estilo Duolingo**:
  - Verde principal: #58CC02
  - Azul secundário: #1CB0F6
  - Amarelo/laranja: #FFB703
- Bordas arredondadas (16px)
- Cards com bordas coloridas
- NavigationBar estilizada

### 📁 Assets

#### `assets/bolt/`
- Estrutura criada para imagens do Bolt
- `README.md` com instruções detalhadas
- Pastas: `expressions/` e `leagues/`
- Por enquanto usando placeholder SVG dentro do widget

## 🔄 Fluxo de Gamificação

```
1. Usuário completa corrida
   ↓
2. GamificationService.processRun()
   ↓
3. Calcula XP da corrida
   ↓
4. Atualiza streak
   ↓
5. Verifica conquistas desbloqueadas
   ↓
6. Verifica missões completadas
   ↓
7. Adiciona XP total
   ↓
8. Verifica se subiu de liga
   ↓
9. Salva estado
   ↓
10. Mostra RewardsDialog com tudo
```

## 📊 Sistema de XP

### Por Corrida
- Base: **30 XP**
- Por distância: **10 XP/km**
- Por tempo: **1 XP/min**
- Pace < 5 min/km: **+50 XP**
- Pace < 6 min/km: **+25 XP**
- Distância 21km+: **+100 XP**
- Distância 10km+: **+50 XP**
- Distância 5km+: **+20 XP**

### Por Conquistas
- Varia de **50 a 1.000 XP** dependendo da dificuldade

### Por Missões Diárias
- Varia de **50 a 150 XP** por missão

## 🚀 Próximos Passos (FASE 2-5)

### FASE 2 - Assets do Bolt
- [ ] Gerar imagens do Bolt com IA (Midjourney/DALL-E)
- [ ] Adicionar todas as 7 expressões
- [ ] Adicionar 5 versões de liga
- [ ] Atualizar BoltWidget para usar assets reais
- [ ] Adicionar animações (Lottie)

### FASE 3 - Melhorias de UI
- [ ] Animações de transição
- [ ] Confetti ao subir de liga
- [ ] Sons de feedback
- [ ] Loading states melhores
- [ ] Skeleton loaders

### FASE 4 - Backend (Supabase)
- [ ] Criar tabela `leaderboard`
- [ ] Criar tabela `user_gamification`
- [ ] Sincronizar XP com Supabase
- [ ] Ranking real em tempo real
- [ ] Backup de conquistas na nuvem

### FASE 5 - Notificações
- [ ] Notificações push (Firebase)
- [ ] Lembrete de streak
- [ ] Novas missões diárias
- [ ] Conquistas desbloqueadas
- [ ] Alguém te ultrapassou no ranking

## 🧪 Como Testar

1. Instale as dependências:
```bash
flutter pub get
```

2. Execute o app:
```bash
flutter run
```

3. Faça login com Google

4. Complete uma corrida (pode ser manual)

5. Veja o dialog de recompensas! 🎉

## 📝 Notas de Implementação

- ✅ Todo o código está type-safe
- ✅ Usando SharedPreferences para persistência local
- ✅ Sistema de XP balanceado
- ✅ Streak detecta quebras automaticamente
- ✅ Missões diárias renovam a cada dia
- ✅ Conquistas verificadas a cada corrida
- ⚠️ Assets do Bolt ainda são placeholders
- ⚠️ Ranking ainda é mock data
- ⚠️ Falta sincronização com Supabase

## 🎨 Paleta de Cores

```dart
Primary:   #58CC02 (Verde Duolingo)
Secondary: #1CB0F6 (Azul vibrante)
Accent:    #FFB703 (Amarelo/laranja)
Surface:   #F7F7F7 (Cinza claro)
```

## 📖 Documentação

- `prompt.md` - Identidade do Bolt
- `assets/bolt/README.md` - Como gerar assets
- Este arquivo - Implementação completa

---

**Desenvolvido com ⚡ por Kiro AI**
