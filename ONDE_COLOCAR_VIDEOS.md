# 📁 Onde Colocar os Vídeos das Animações

**Criado**: 06/06/2026  
**Status**: Pronto para testar! ✅

---

## 🎯 Localização dos Vídeos

### 📂 Estrutura de Pastas:

```
d:\projetos\cooper_maratonista\
└── assets\
    └── bolt\
        └── expressions\
            ├── ganhar_xp.mp4                 ← Coloque aqui
            ├── missao_concluida.mp4          ← Coloque aqui
            ├── conquista_desbloqueada.mp4    ← Coloque aqui
            ├── check_animado.mp4             ← Coloque aqui
            └── idle_loop.mp4                 ← Coloque aqui
```

### 📍 Caminho Completo:
```
d:\projetos\cooper_maratonista\assets\bolt\expressions\
```

---

## ✅ O que Já Está Pronto

### 1. Widget de Player ✅
- Arquivo: `lib\widgets\fullscreen_video_player.dart`
- Funciona com vídeo fullscreen + botão "Pular"

### 2. Tela de Testes ✅
- Arquivo: `lib\screens\test_animations_screen.dart`
- Lista todas as animações para testar

### 3. Botão de Acesso ✅
- Local: Tela inicial (HomeScreen)
- Ícone: 📹 (video_library)
- Posição: Barra superior, antes do "Atualizar"

---

## 🚀 Como Testar

### Passo 1: Criar/Obter os Vídeos
1. Use as IAs (Runway, Pika, Leonardo) com os prompts
2. Ou crie vídeos temporários de teste
3. Certifique-se que:
   - Formato: MP4
   - Fundo: `#0D1B2A` (azul escuro)
   - Resolução: 1080x1080px (ou 800x800px)

### Passo 2: Copiar para a Pasta
```bash
# Crie a pasta se não existir
mkdir -p assets\bolt\expressions

# Copie seus vídeos para lá
copy seu_video_xp.mp4 assets\bolt\expressions\ganhar_xp.mp4
copy seu_video_missao.mp4 assets\bolt\expressions\missao_concluida.mp4
# ... etc
```

### Passo 3: Atualizar pubspec.yaml

Abra `pubspec.yaml` e adicione (se ainda não tiver):

```yaml
flutter:
  assets:
    - assets/bolt/expressions/ganhar_xp.mp4
    - assets/bolt/expressions/missao_concluida.mp4
    - assets/bolt/expressions/conquista_desbloqueada.mp4
    - assets/bolt/expressions/check_animado.mp4
    - assets/bolt/expressions/idle_loop.mp4
```

### Passo 4: Atualizar Assets
```bash
flutter pub get
```

### Passo 5: Testar!
1. Execute o app: `flutter run`
2. Na tela inicial, toque no ícone 📹 (video_library) no topo
3. Escolha uma animação para testar
4. Veja em tela cheia com botão "Pular"

---

## 🎬 Criar Vídeo de Teste Rápido

Se quiser testar AGORA sem esperar IA, você pode:

### Opção 1: Usar Vídeo Placeholder
1. Baixe qualquer MP4 de teste
2. Renomeie para `ganhar_xp.mp4`
3. Coloque em `assets\bolt\expressions\`
4. Teste!

### Opção 2: Converter GIF Existente
Se você tem um GIF do Bolt:
```bash
# Use https://cloudconvert.com/gif-to-mp4
1. Upload seu GIF
2. Configure:
   - Background: #0D1B2A
   - Size: 1080x1080
3. Convert
4. Baixe como .mp4
```

### Opção 3: Criar Vídeo Simples com Ferramenta Online
Use **Canva** (grátis):
1. Acesse canva.com
2. Criar → Vídeo → 1080x1080px
3. Adicione fundo azul #0D1B2A
4. Adicione imagem do Bolt
5. Anime (movimento simples)
6. Download como MP4

---

## 🎨 Especificações dos Vídeos

### Obrigatório:
- ✅ Formato: MP4 (H.264)
- ✅ Fundo: `#0D1B2A` (azul escuro)
- ✅ Tamanho: < 5MB por vídeo

### Recomendado:
- 📐 Resolução: 1080x1080px
- 🎞️ FPS: 30
- ⏱️ Duração: 1-3.5 segundos
- 🔊 Áudio: Opcional (pode ter ou não)

---

## 📱 Como Acessar no App

### Fluxo de Navegação:

```
[Tela Inicial]
      ↓
[Toque no ícone 📹 no topo direito]
      ↓
[Tela "Testar Animações do Bolt"]
      ↓
[Lista com 5 opções:]
  • 💫 Ganhar XP
  • ⭐ Missão Concluída
  • 🏆 Conquista Desbloqueada
  • ✅ Check Missão
  • 🔄 Loop Idle
      ↓
[Toque em qualquer uma]
      ↓
[Vídeo abre em TELA CHEIA]
      ↓
[Opções:]
  - Assistir até o fim (auto-fecha)
  - Tocar botão "Pular" embaixo
```

---

## 🐛 Solução de Problemas

### Erro: "Vídeo não encontrado"
**Solução**:
1. Verifique se o arquivo está em `assets\bolt\expressions\`
2. Verifique se o nome está correto (ex: `ganhar_xp.mp4`)
3. Rode `flutter pub get`
4. Reinicie o app

### Erro: "Vídeo não carrega"
**Solução**:
1. Verifique se é MP4 válido
2. Teste em https://www.freeconvert.com/video-compressor
3. Converta para H.264 se necessário
4. Reduza tamanho se > 5MB

### Vídeo aparece distorcido
**Solução**:
1. Use resolução 1:1 (quadrado)
2. Recomendado: 1080x1080px
3. Evite resoluções muito diferentes

### Vídeo muito lento para carregar
**Solução**:
1. Comprima o vídeo
2. Reduza bitrate para 2-4 Mbps
3. Use ferramenta online: https://www.videosmaller.com/

---

## 📋 Checklist de Configuração

- [x] Widget `FullscreenVideoPlayer` criado
- [x] Tela de testes `TestAnimationsScreen` criada
- [x] Botão adicionado na HomeScreen
- [ ] Criar pasta `assets\bolt\expressions\`
- [ ] Gerar/copiar vídeos para a pasta
- [ ] Atualizar `pubspec.yaml` com assets
- [ ] Executar `flutter pub get`
- [ ] Testar no app

---

## 🎯 Próximos Passos

### Agora (Teste):
1. ✅ Crie a pasta `assets\bolt\expressions\`
2. ✅ Coloque pelo menos 1 vídeo de teste
3. ✅ Atualize `pubspec.yaml`
4. ✅ Rode `flutter pub get`
5. ✅ Teste no app (ícone 📹)

### Depois (Produção):
1. Gere todos os 5 vídeos com qualidade
2. Otimize tamanhos (< 3MB cada)
3. Teste todos no app
4. Integre no fluxo real (após corrida, missões, etc)

---

## 💡 Dica Importante

**Comece com 1 vídeo de teste primeiro!**

Não precisa criar todos os 5 vídeos de uma vez. Faça:
1. Crie/baixe 1 vídeo de teste
2. Coloque como `ganhar_xp.mp4`
3. Teste no app
4. Se funcionar, crie os outros 4

Isso economiza tempo e garante que tudo está funcionando! ✅

---

## 📞 Suporte

Se algo não funcionar:
1. Verifique os caminhos dos arquivos
2. Confira se `pubspec.yaml` está correto
3. Execute `flutter clean` e `flutter pub get`
4. Reinicie o app completamente

---

**Criado por**: Kiro AI  
**Arquivo**: `ONDE_COLOCAR_VIDEOS.md`  
🎬 Bora testar essas animações!
