# 🎬 Especificações para Vídeo do Bolt - Tela de Login

## 📐 Dimensões Exatas

### Área Total da Tela de Login:
- **Largura:** 100% da tela
- **Altura:** 60% da tela (parte superior azul escura)

### Área do Bolt (Vídeo):
- **Largura recomendada:** 800px - 1200px
- **Altura recomendada:** 800px - 1200px
- **Formato:** Quadrado (1:1) ou ligeiramente vertical
- **Resolução ideal:** 1080x1080px (Full HD quadrado)

---

## 🎨 Layout da Tela

```
┌─────────────────────────────────┐
│                                 │
│    FUNDO AZUL ESCURO (#0D1B2A)  │
│                                 │
│         ┌──────────┐            │
│         │          │            │ ← 60% da altura
│         │  BOLT    │            │   (parte superior)
│         │  VÍDEO   │            │
│         │          │            │
│         └──────────┘            │
│                                 │
│      ⚡ Bora Treinar            │
│   "Um passo de cada vez"        │
│                                 │
├─────────────────────────────────┤ ← Divisão
│                                 │
│      CARD BRANCO                │ ← 40% da altura
│                                 │   (parte inferior)
│   Botão "Entrar com Google"    │
│                                 │
└─────────────────────────────────┘
```

---

## 🎥 Especificações do Vídeo

### Resolução:
- **1080x1080px** (ideal para qualidade)
- ou **720x720px** (menor, mais leve)

### Duração:
- **2-5 segundos** (loop)

### Formato:
- **MP4** com H.264 codec
- ou **WebM** (melhor para web)

### Fundo:
- ⚠️ **PROBLEMA:** MP4 não suporta transparência!
- ✅ **SOLUÇÃO 1:** Usar **WebM com alpha channel** (transparente)
- ✅ **SOLUÇÃO 2:** Fundo **#0D1B2A** (mesmo azul do fundo)
- ✅ **SOLUÇÃO 3:** Usar **GIF animado** (suporta transparência)

### Taxa de quadros (FPS):
- **30 FPS** (recomendado para web)
- ou **24 FPS** (mais leve)

### Bitrate:
- **5-8 Mbps** para alta qualidade
- **2-4 Mbps** para web leve

---

## 📝 Prompt para IA Gerar Vídeo

### Para RunwayML, Pika, ou ferramentas similares:

```
Create a 3 second looping animation of "Bolt" character:

Character: Blue energetic droplet with lightning bolt on top, 
big expressive eyes, small sporty arms and legs, wearing running 
shoes and fitness smartwatch.

Animation: 
- Bolt jumps slightly up and down (excited pose)
- Lightning bolt on head pulses with energy
- Arms raised in motivational gesture
- Continuous smooth loop
- Clean solid background color: #0D1B2A (dark blue)

Style: 3D render, Pixar style, smooth animation, friendly and 
motivational vibe

Output: 1080x1080px, MP4, 30fps, 3 seconds loop
```

---

## 🎨 Alternativa: GIF Animado (RECOMENDO!)

GIF suporta transparência e é mais fácil!

### Especificações GIF:
- **Resolução:** 800x800px ou 1000x1000px
- **Frames:** 10-20 frames
- **Delay:** 100ms entre frames
- **Formato:** GIF com transparência
- **Tamanho arquivo:** 500KB - 2MB

### Prompt para criar frames (Midjourney/DALL-E):

```
Frame 1: Bolt character standing, arms at sides, happy expression
Frame 2: Bolt slightly jumping, arms moving up
Frame 3: Bolt at peak height, arms up, excited
Frame 4: Bolt going down, arms moving down
Frame 5: Bolt landing, arms at sides

All frames: Blue droplet character, lightning bolt on head, 
transparent background, 3D render, consistent style
```

Depois use https://ezgif.com/maker para juntar em GIF animado!

---

## 🔧 Como Usar GIF em Vez de MP4

### 1. Crie/converta para GIF:
- Use https://cloudconvert.com/mp4-to-gif
- Ou crie direto no https://ezgif.com/maker

### 2. Salve como:
```
assets/bolt/expressions/boratreinar.gif
```

### 3. Código Flutter já suporta:
```dart
Image.asset('assets/bolt/expressions/boratreinar.gif')
```

Não precisa mudar nada no código! Só substituir `.mp4` por `.gif`!

---

## 🎯 Tamanhos de Referência

### Mobile (iPhone):
- Tela: 390x844px
- Bolt: ~234px (60% de 390px)

### Tablet (iPad):
- Tela: 768x1024px  
- Bolt: ~460px (60% de 768px)

### Desktop (1920x1080):
- Tela: 1920x1080px
- Bolt: ~1152px (60% de 1920px)

**Resolução recomendada para cobrir todos:** **1200x1200px**

---

## 🎬 Ferramentas Recomendadas

### Para Criar Vídeo:
1. **RunwayML** - IA para vídeo (pago)
2. **Pika Labs** - IA para animação (grátis limitado)
3. **Adobe After Effects** - Profissional
4. **Blender** - Grátis, 3D

### Para Criar GIF:
1. **EZGif** - Online, grátis
2. **Photoshop** - Timeline animation
3. **GIMP** - Grátis
4. **Canva** - Simples, online

### Para Remover Fundo de Vídeo:
1. **Unscreen.com** - Remove fundo de vídeo (grátis/pago)
2. **Adobe After Effects** - Keying
3. **DaVinci Resolve** - Grátis

---

## ✅ Checklist de Criação

- [ ] Resolução: 1080x1080px ou 1200x1200px
- [ ] Duração: 2-5 segundos (loop perfeito)
- [ ] Fundo: Transparente (GIF/WebM) ou #0D1B2A (MP4)
- [ ] Formato: GIF (recomendado) ou MP4
- [ ] FPS: 24-30
- [ ] Tamanho arquivo: < 5MB
- [ ] Loop suave (começo = fim)
- [ ] Bolt centralizado
- [ ] Animação sutil (não muito rápida)

---

## 🚀 Solução Rápida AGORA

### Opção 1: Converter MP4 atual para GIF

```bash
# Use site: https://cloudconvert.com/mp4-to-gif
1. Upload: boratreinar.mp4
2. Configurações: 
   - Width: 1000px
   - Optimize: Yes
3. Convert
4. Salvar como: boratreinar.gif
```

### Opção 2: Adicionar fundo azul ao vídeo

Use um editor de vídeo para adicionar camada de fundo #0D1B2A

### Opção 3: Usar imagem estática grande

Temporariamente, use o PNG com tamanho maior até fazer o vídeo perfeito.

---

## 💡 Minha Recomendação

**Use GIF animado em vez de MP4!**

Vantagens:
- ✅ Suporta transparência
- ✅ Flutter carrega mais fácil
- ✅ Mais leve que vídeo
- ✅ Loop perfeito
- ✅ Funciona em todos browsers

**Crie um GIF de 1000x1000px com 10-15 frames do Bolt pulando!**

---

## 🔄 Para atualizar o código para GIF:

Renomeie o arquivo:
```
boratreinar.mp4 → boratreinar.gif
```

E use o widget de imagem em vez de vídeo (mais simples):

```dart
Image.asset(
  'assets/bolt/expressions/boratreinar.gif',
  width: size.width * 0.6,
  height: size.width * 0.6,
  fit: BoxFit.contain,
)
```

---

**Quer que eu ajuste o código para usar GIF ou prefere continuar com MP4?** 🎬
