# 🎬 Fluxo de Vídeos/Animações do Bolt

**Criado**: 06/06/2026  
**Atualizado**: Implementação com fundo `#0D1B2A`

---

## 📋 Mudanças Implementadas

### ✅ O que mudou:

1. **Fundo dos vídeos**: Todos os prompts agora geram vídeos com fundo `#0D1B2A` (azul escuro padrão)
2. **Formato**: MP4 em vez de GIF/transparente
3. **Player fullscreen**: Novo widget com botão "Pular"
4. **Fluxo**: Vídeo → botão pular → volta ao sistema

### ❌ O que foi removido:

- Tentativas de criar vídeos com fundo transparente
- Necessidade de usar GIF
- Complexidade de remover fundo

---

## 🎯 Como Usar as Animações no App

### 1️⃣ Cenário: Ganhar XP após corrida

```dart
// No final da corrida, mostrar animação de XP
await Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => FullscreenVideoPlayer(
      videoPath: 'assets/bolt/expressions/ganhar_xp.mp4',
      onComplete: () {
        Navigator.of(context).pop();
        // Continua o fluxo normal (mostrar resumo, etc)
      },
      onSkip: () {
        Navigator.of(context).pop();
        // Usuário pulou, continua o fluxo
      },
    ),
  ),
);
```

### 2️⃣ Cenário: Missão Concluída

```dart
// Quando missão é completada
void _onMissionCompleted() async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FullscreenVideoPlayer(
        videoPath: 'assets/bolt/expressions/missao_concluida.mp4',
        onComplete: () {
          Navigator.of(context).pop();
          // Mostra diálogo ou toast de parabéns
        },
      ),
    ),
  );
}
```

### 3️⃣ Cenário: Conquista Desbloqueada

```dart
// Quando conquista importante é desbloqueada
void _onAchievementUnlocked() async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FullscreenVideoPlayer(
        videoPath: 'assets/bolt/expressions/conquista_desbloqueada.mp4',
        onComplete: () {
          Navigator.of(context).pop();
          // Mostra detalhes da conquista
        },
      ),
    ),
  );
}
```

### 4️⃣ Cenário: Check Missão (popup overlay, NÃO fullscreen)

```dart
// Para animações rápidas, pode usar um dialog com vídeo menor
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => Dialog(
    backgroundColor: const Color(0xFF0D1B2A),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: VideoPlayer(
              VideoPlayerController.asset(
                'assets/bolt/expressions/check_animado.mp4',
              )..initialize().then((_) {
                  // Auto-play e auto-close após 1.2s
                  controller.play();
                  Future.delayed(
                    const Duration(milliseconds: 1200),
                    () => Navigator.of(context).pop(),
                  );
                }),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Missão concluída! 🎉',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
);
```

---

## 📁 Estrutura de Arquivos

```
assets/bolt/expressions/
├── ganhar_xp.mp4                 # 1.8s - Após cada corrida
├── missao_concluida.mp4          # 2.5s - Missão semanal completa
├── conquista_desbloqueada.mp4    # 3.5s - Conquista importante
├── check_animado.mp4             # 1.2s - Feedback rápido inline
└── idle_loop.mp4                 # 2.5s - Loop para telas de espera
```

---

## 🎨 Características dos Vídeos

### Todos os vídeos têm:
- **Fundo**: `#0D1B2A` (azul escuro - mesma cor do app)
- **Formato**: MP4 (H.264)
- **Resolução**: 1080x1080px (ou 800x800px para check)
- **FPS**: 30
- **Tamanho**: 1-5 MB cada

### Vantagens:
✅ Não precisa fundo transparente  
✅ Mais fácil de gerar com IAs  
✅ Melhor compatibilidade  
✅ Menor tamanho de arquivo  
✅ Visual consistente com o app  

---

## 🔄 Fluxo Completo de Uso

### Exemplo: Completar uma corrida

```
[Usuário finaliza corrida]
         ↓
[Salva dados no Supabase]
         ↓
[Calcula XP ganho]
         ↓
[Abre vídeo fullscreen: ganhar_xp.mp4]
         ↓
  ┌──────┴──────┐
  │             │
[Assiste]  [Pula botão]
  │             │
  └──────┬──────┘
         ↓
[Fecha vídeo automaticamente]
         ↓
[Mostra tela de resumo da corrida]
         ↓
[Verifica se completou missões]
         ↓
  SIM: [Abre vídeo: missao_concluida.mp4]
  NÃO: [Continua no resumo]
         ↓
[Verifica se desbloqueou conquista]
         ↓
  SIM: [Abre vídeo: conquista_desbloqueada.mp4]
  NÃO: [Volta para home]
```

---

## ⚙️ Configuração no pubspec.yaml

```yaml
flutter:
  assets:
    - assets/bolt/expressions/ganhar_xp.mp4
    - assets/bolt/expressions/missao_concluida.mp4
    - assets/bolt/expressions/conquista_desbloqueada.mp4
    - assets/bolt/expressions/check_animado.mp4
    - assets/bolt/expressions/idle_loop.mp4
```

---

## 🎯 Prioridade de Criação

### Alta Prioridade (criar primeiro):
1. **ganhar_xp.mp4** - Usado TODA corrida
2. **check_animado.mp4** - Feedback visual frequente

### Média Prioridade:
3. **missao_concluida.mp4** - Usado semanalmente
4. **idle_loop.mp4** - Melhora experiência

### Baixa Prioridade:
5. **conquista_desbloqueada.mp4** - Raro mas impactante

---

## 🛠️ Widget Criado: FullscreenVideoPlayer

### Características:
- ✅ Tela cheia automática
- ✅ Botão "Pular" centralizado na parte inferior
- ✅ Barra de progresso no topo
- ✅ Auto-play ao abrir
- ✅ Auto-fecha ao terminar
- ✅ Loading indicator enquanto carrega
- ✅ Tratamento de erros
- ✅ Callback onComplete
- ✅ Callback onSkip (opcional)

### Localização:
`lib/widgets/fullscreen_video_player.dart`

---

## 📝 Exemplo de Integração Completa

```dart
import 'package:cooper_maratonista/widgets/fullscreen_video_player.dart';

// Após salvar corrida com sucesso
Future<void> _onRunSaved(int xpGained) async {
  // 1. Mostrar animação de XP
  await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => FullscreenVideoPlayer(
        videoPath: 'assets/bolt/expressions/ganhar_xp.mp4',
        onComplete: () => Navigator.of(context).pop(),
      ),
    ),
  );

  // 2. Verificar missões completadas
  final completedMissions = _checkCompletedMissions();
  if (completedMissions.isNotEmpty) {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullscreenVideoPlayer(
          videoPath: 'assets/bolt/expressions/missao_concluida.mp4',
          onComplete: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  // 3. Verificar conquistas desbloqueadas
  final newAchievements = _checkNewAchievements();
  if (newAchievements.isNotEmpty) {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullscreenVideoPlayer(
          videoPath: 'assets/bolt/expressions/conquista_desbloqueada.mp4',
          onComplete: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  // 4. Navegar para tela de resumo
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => RunSummaryScreen(xpGained: xpGained),
    ),
  );
}
```

---

## 🎨 Design do Botão "Pular"

```
┌─────────────────────────────────┐
│                                 │
│                                 │
│                                 │
│          [VÍDEO]                │
│                                 │
│                                 │
│                                 │
│                                 │
│         ┌─────────┐             │
│         │  Pular  │ →           │ ← 48px da base
│         └─────────┘             │
│                                 │
└─────────────────────────────────┘

Botão:
- Fundo: Branco 20% opacidade
- Borda: Branca 54% opacidade
- Texto: Branco
- Ícone: skip_next
- Padding: 32px horizontal, 12px vertical
- Border radius: 24px
```

---

## 🐛 Tratamento de Erros

O widget já trata automaticamente:

1. **Vídeo não carrega**: Mostra ícone de erro e fecha após 1s
2. **Vídeo não existe**: Detecta erro e chama onComplete
3. **Widget desmontado**: Verifica `mounted` antes de setState
4. **Dispose correto**: VideoController é liberado automaticamente

---

## ✅ Checklist de Implementação

- [x] Criar widget FullscreenVideoPlayer
- [x] Adicionar botão "Pular" centralizado
- [x] Adicionar barra de progresso
- [x] Auto-play ao abrir
- [x] Auto-close ao terminar
- [x] Tratamento de erros
- [ ] Gerar vídeos com IA (usando prompts atualizados)
- [ ] Adicionar vídeos em assets/bolt/expressions/
- [ ] Atualizar pubspec.yaml
- [ ] Integrar no fluxo de corrida
- [ ] Integrar no fluxo de missões
- [ ] Integrar no fluxo de conquistas
- [ ] Testar no dispositivo real

---

## 💡 Dicas Finais

1. **Ordem de prioridade**: Comece com `ganhar_xp.mp4` pois é usado após toda corrida
2. **Tamanho**: Mantenha vídeos com menos de 3MB cada para carregamento rápido
3. **Duração**: Animações curtas (1-3s) mantêm usuário engajado
4. **Skippable**: Sempre permita pular - usuários repetem ações
5. **Consistência**: Use sempre o fundo `#0D1B2A` em todas as animações
6. **Teste**: Teste em dispositivo real para ver performance

---

## 🚀 Próximos Passos

1. Gerar os vídeos usando os prompts atualizados
2. Salvar em `assets/bolt/expressions/`
3. Atualizar `pubspec.yaml`
4. Integrar no código (exemplo acima)
5. Testar no dispositivo
6. Ajustar timing se necessário

---

**Criado por**: Kiro AI  
**Data**: 06/06/2026  
🏃‍♂️💨 Bora criar essas animações!
