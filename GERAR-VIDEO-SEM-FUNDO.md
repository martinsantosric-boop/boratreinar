# 🎬 Gerar Vídeo do Mascote Sem Fundo Preto

## 🎯 Objetivo

Substituir o vídeo atual (`abertura_mascote.mp4`) que tem fundo preto por um novo sem fundo ou com fundo azul escuro (#0D1B2A).

---

## ✅ Deploy Atual

**Status**: ✅ Vídeo maior (90% da tela)  
**URL**: https://gotreiinar.web.app  
**Problema**: Fundo preto do vídeo  

---

## 🎨 Opções de Solução

### Opção 1: Gerar Novo Vídeo com IA (Recomendado)

Use IA para gerar um vídeo novo com fundo transparente ou azul escuro.

### Opção 2: Editar Vídeo Atual

Use software de edição para remover/trocar o fundo.

### Opção 3: Aceitar Fundo Preto (Mais Rápido)

O fundo preto pode funcionar como "cortina" dramática para a animação.

---

## 📝 Prompt para IA Gerar Novo Vídeo

### Para Runway ML, Pika Labs, ou similar:

```
Crie um vídeo animado 3D de 3-5 segundos do mascote Bolt (personagem azul com raio amarelo) apitando e fazendo gesto de "vamos lá!".

Especificações:
- Duração: 3-5 segundos
- Tamanho: 1080x1080 pixels (quadrado)
- Fundo: azul escuro sólido #0D1B2A OU transparente
- Personagem: Bolt (mascote azul) centralizado
- Ação: Apitando (gesto de apito) e animado
- Estilo: cartoon 3D, energético, motivador
- Loop: Sim (deve poder repetir)
- Formato: MP4 ou WEBM

IMPORTANTE: Fundo deve ser azul escuro #0D1B2A ou transparente (sem preto!)
```

### Versão Simplificada:

```
Vídeo 3D cartoon: mascote azul apitando, 3 segundos, fundo azul escuro #0D1B2A, 1080x1080px, formato MP4
```

---

## 🛠️ Editar Vídeo Atual (Remover Fundo Preto)

### Usando Software de Edição:

**Opção A - DaVinci Resolve (Gratuito)**

1. Abra o vídeo `abertura_mascote.mp4`
2. Use "Color" > "Qualifier" para selecionar preto
3. Use "Matte" para remover fundo preto
4. Aplique fundo azul #0D1B2A
5. Exporte como MP4

**Opção B - Adobe Premiere/After Effects**

1. Importe o vídeo
2. Use efeito "Keying" > "Keylight"
3. Selecione preto como cor chave
4. Adicione camada de fundo azul #0D1B2A
5. Exporte como MP4

**Opção C - Online (Unscreen.com)**

1. Acesse: https://www.unscreen.com
2. Upload `abertura_mascote.mp4`
3. Remove fundo automaticamente
4. Baixe versão sem fundo
5. Use editor para adicionar fundo azul

---

## 📦 Substituir Vídeo

Após gerar/editar o novo vídeo:

### Passo 1: Substituir Arquivo

```powershell
# Backup do atual
Copy-Item assets\bolt\abertura_mascote.mp4 assets\bolt\abertura_mascote_backup.mp4

# Substituir pelo novo
# (Copie seu novo vídeo para assets\bolt\abertura_mascote.mp4)
```

### Passo 2: Build e Deploy

```powershell
flutter clean
flutter build web --release
firebase deploy --only hosting
```

### Passo 3: Testar

```
https://gotreiinar.web.app
Ctrl + Shift + R
Iniciar Corrida > Iniciar
```

---

## 🎨 Alternativa: Mudar Fundo da Interface

Se não conseguir gerar vídeo novo, podemos mudar o fundo da tela para combinar:

### Opção: Fundo Azul em vez de Preto

```dart
// Mudar de preto semi-transparente para azul escuro
Container(
  color: const Color(0xFF0D1B2A).withValues(alpha: 0.95),
  // ...
)
```

Isso faz o fundo preto do vídeo se misturar melhor com o fundo da interface.

---

## 🔍 Verificar Vídeo Atual

### Informações do vídeo:

```powershell
# Ver propriedades
ffmpeg -i assets\bolt\abertura_mascote.mp4
```

Informações úteis:
- Resolução
- Duração
- Codec
- FPS

---

## 💡 Dica: Vídeo com Fundo Transparente

**WEBM suporta transparência, MP4 não!**

Se gerar vídeo com transparência:
1. Use formato WEBM (não MP4)
2. Mude extensão no código para `.webm`
3. VideoPlayer suporta WEBM na web

```dart
// Em vez de:
'assets/bolt/abertura_mascote.mp4'

// Use:
'assets/bolt/abertura_mascote.webm'
```

---

## 🚀 Status Atual

### Implementado:
- ✅ Vídeo aparece (maior, 90% da tela)
- ✅ Som de apito toca
- ✅ Duração de 3 segundos
- ✅ Overlay escuro semi-transparente
- ⚠️ Fundo preto no vídeo (do arquivo original)

### Próximo:
- [ ] Gerar novo vídeo sem fundo preto
- [ ] OU aceitar fundo preto
- [ ] OU mudar fundo da interface

---

## 📋 Checklist para Novo Vídeo

Ao gerar novo vídeo, certifique-se:

- [ ] Duração: 3-5 segundos
- [ ] Tamanho: 1080x1080px ou similar (quadrado)
- [ ] Fundo: azul #0D1B2A ou transparente
- [ ] Personagem: Bolt visível e grande
- [ ] Ação: Apitando/animado
- [ ] Formato: MP4 (ou WEBM se transparente)
- [ ] Tamanho arquivo: < 2MB (para web)
- [ ] Loop: Funciona bem repetindo

---

## 🎯 Resultado Esperado

Após substituir o vídeo:

✅ Mascote aparece grande (90% da tela)  
✅ Fundo azul escuro matching o tema  
✅ Animação suave por 3 segundos  
✅ Som de apito sincronizado  
✅ Visual profissional e polido  

---

**Deploy atual já tem o vídeo maior! Teste agora:** https://gotreiinar.web.app

Se quiser trocar o vídeo, use os prompts acima para gerar um novo! 🎬
