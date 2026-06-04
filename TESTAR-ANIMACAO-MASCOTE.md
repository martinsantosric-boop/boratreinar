# 🎬 Testar Animação do Mascote

## 📋 Como Testar

### Passo 1: Acessar o App
```
https://gotreiinar.web.app
```

### Passo 2: Limpar Cache
Pressione: `Ctrl + Shift + R` (ou abra em aba anônima)

### Passo 3: Fazer Login
- Clique em "Entrar com Google"
- Faça login

### Passo 4: Iniciar Corrida
1. Na tela inicial (Home), clique no botão **"Iniciar Corrida"**
2. Você será levado para a tela "Corrida ativa"
3. Clique no botão **"Iniciar"** (botão verde com ícone play)

### Passo 5: Observar Animação
Ao clicar em "Iniciar", deve acontecer:

✅ **Vídeo do mascote aparece** (300x300px no centro)  
✅ **Som de apito toca** (apito.mp3)  
✅ **Duração**: 3 segundos  
✅ **Depois some** e a corrida começa  

---

## 🎯 Comportamento Esperado

### Durante os 3 segundos:
- Vídeo `abertura_mascote.mp4` é exibido
- Áudio `apito.mp3` toca simultaneamente
- Tela fica "congelada" esperando a animação

### Após 3 segundos:
- Vídeo desaparece
- Corrida inicia automaticamente
- Timer começa a contar
- GPS começa a rastrear

---

## 🐛 Se Não Funcionar

### Problema 1: Vídeo não aparece

**Possíveis causas:**
1. Cache do navegador
2. Assets não foram deployed
3. Erro ao inicializar VideoPlayerController

**Solução:**
```
1. Pressione Ctrl + Shift + R (hard refresh)
2. Ou abra em aba anônima
3. Verifique console (F12) por erros
```

### Problema 2: Som não toca

**Possíveis causas:**
1. Navegador bloqueou autoplay de áudio
2. Volume do sistema está mudo
3. Asset não foi carregado

**Solução:**
```
1. Verifique volume do sistema
2. Alguns navegadores bloqueiam autoplay - é normal
3. Som pode não tocar na primeira vez (política de navegadores)
```

### Problema 3: Corrida não inicia após animação

**Possíveis causas:**
1. Permissão de localização negada
2. Erro no GPS
3. Timeout na animação

**Solução:**
```
1. Permita acesso à localização quando solicitado
2. Verifique console (F12) por erros
3. Tente novamente clicando em "Iniciar"
```

---

## 📱 Comportamento por Plataforma

### Web (Desktop):
- ✅ Vídeo funciona
- ✅ Som funciona (pode ser bloqueado na 1ª interação)
- ✅ Animação suave

### Web (Mobile):
- ✅ Vídeo funciona
- ⚠️ Som pode ser bloqueado (política de navegadores móveis)
- ✅ Animação pode ser mais lenta (depende do dispositivo)

### App Nativo (se compilar):
- ✅ Vídeo funciona perfeitamente
- ✅ Som funciona sempre
- ✅ Animação suave

---

## 🔍 Verificar no Console

Abra o console (F12) e procure por:

### Se funcionar:
```
✅ Sem erros relacionados a video_player
✅ Sem erros relacionados a audioplayers
✅ Sem 404 em abertura_mascote.mp4
✅ Sem 404 em apito.mp3
```

### Se não funcionar:
```
❌ Erro ao carregar assets/bolt/abertura_mascote.mp4
❌ Erro ao carregar assets/apito.mp3
❌ VideoPlayerController failed to initialize
❌ AudioPlayer failed to play
```

---

## 📂 Assets Necessários

Verifique se estes arquivos existem no projeto:

```
✅ assets/apito.mp3
✅ assets/bolt/abertura_mascote.mp4
```

Verificar no pubspec.yaml:
```yaml
assets:
  - assets/apito.mp3
  - assets/bolt/abertura_mascote.mp4
```

---

## 🧪 Teste Manual Local

Se quiser testar localmente antes de deploy:

```powershell
# 1. Navegar para projeto
cd D:\Projetos\boratreinar

# 2. Executar em modo debug
flutter run -d chrome

# 3. Testar animação
# (mesmo processo: Home > Iniciar Corrida > Iniciar)
```

---

## 💾 Código Relevante

### Método que executa a animação:
```dart
// lib/screens/active_run_screen.dart

Future<void> _executarAberturaMascote() async {
  if (!_mascoteController.value.isInitialized) return;

  setState(() => _mostrarMascote = true);

  await _mascoteController.seekTo(Duration.zero);
  await _mascoteController.play();
  await _apitoPlayer.play(AssetSource('apito.mp3'));

  await Future.delayed(const Duration(seconds: 3));

  if (!mounted) return;

  await _mascoteController.pause();
  setState(() => _mostrarMascote = false);
}
```

### Widget do vídeo:
```dart
if (_mostrarMascote)
  Positioned.fill(
    child: IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: _mascoteController.value.isInitialized
              ? VideoPlayer(_mascoteController)
              : const SizedBox.shrink(),
        ),
      ),
    ),
  ),
```

---

## ✅ Checklist de Teste

- [ ] App carregado: https://gotreiinar.web.app
- [ ] Cache limpo (Ctrl + Shift + R)
- [ ] Login realizado
- [ ] Botão "Iniciar Corrida" clicado
- [ ] Tela "Corrida ativa" apareceu
- [ ] Botão "Iniciar" (verde com play) clicado
- [ ] **Vídeo do mascote apareceu?**
- [ ] **Som de apito tocou?**
- [ ] Animação durou ~3 segundos?
- [ ] Vídeo sumiu após animação?
- [ ] Corrida iniciou automaticamente?
- [ ] Timer começou a contar?

---

## 🎉 Sucesso!

Se todas as caixas foram marcadas, a animação está funcionando perfeitamente! 🚀

Se algo não funcionou, verifique:
1. Console do navegador (F12)
2. Permissões (localização, áudio)
3. Cache do navegador
4. Versão do navegador (use Chrome/Edge atualizado)

---

**Deploy realizado**: ✅  
**Assets incluídos**: ✅  
**Código correto**: ✅  

Agora é só testar! 🎬
