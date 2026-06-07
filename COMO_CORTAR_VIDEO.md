# ✂️ Como Cortar 0.5 Segundos do Início do Vídeo

**Criado**: 06/06/2026  
**Objetivo**: Remover 0.5s do início de `ganhar_xp.mp4`

---

## 🚀 Método 1: Online (MAIS FÁCIL) ⭐

### Site: https://online-video-cutter.com/

1. **Acesse** o site
2. **Click** em "Open file"
3. **Selecione** seu vídeo `ganhar_xp.mp4`
4. **Arraste** o marcador inicial para 0.5 segundos
   - Ou digite "0.5" no campo de início
5. **Click** em "Save"
6. **Download** o vídeo cortado
7. **Renomeie** para `ganhar_xp.mp4`
8. **Substitua** o arquivo em `assets\bolt\expressions\`

**Vantagens**:
- ✅ Não precisa instalar nada
- ✅ Interface visual simples
- ✅ Funciona em qualquer navegador

---

## 🎨 Método 2: Kapwing (Alternativa Online)

### Site: https://www.kapwing.com/tools/trim-video

1. **Click** em "Choose video"
2. **Upload** seu `ganhar_xp.mp4`
3. **Arraste** o marcador esquerdo para 0.5s
4. **Click** em "Export video"
5. **Aguarde** o processamento
6. **Download**
7. **Substitua** o arquivo original

---

## 💻 Método 3: FFmpeg (Linha de Comando)

### Se você tem FFmpeg instalado:

```powershell
# Navegar para a pasta do projeto
cd d:\projetos\cooper_maratonista

# Cortar 0.5s do início
ffmpeg -ss 0.5 -i assets\bolt\expressions\ganhar_xp.mp4 -c copy assets\bolt\expressions\ganhar_xp_cortado.mp4

# Substituir o original
Move-Item -Force assets\bolt\expressions\ganhar_xp_cortado.mp4 assets\bolt\expressions\ganhar_xp.mp4
```

### Para instalar FFmpeg:

**Opção A: Chocolatey** (se tiver instalado):
```powershell
choco install ffmpeg
```

**Opção B: Download Manual**:
1. Acesse: https://ffmpeg.org/download.html
2. Baixe para Windows
3. Extraia e adicione ao PATH

---

## 🔧 Método 4: Script PowerShell Automático

Criamos um script que faz tudo automaticamente!

### Como usar:

```powershell
# Executar o script
.\cortar_video.ps1

# Ou especificar arquivo diferente
.\cortar_video.ps1 -VideoPath "assets\bolt\expressions\outro_video.mp4" -CortarInicio 0.5
```

### O script vai:
1. Verificar se FFmpeg está instalado
2. Cortar 0.5s do início
3. Salvar como `ganhar_xp_cortado.mp4`
4. Mostrar comando para substituir o original

---

## 📱 Método 5: VLC Media Player

Se você tem VLC instalado:

1. **Abra** VLC
2. **Media** → **Open File**
3. **Selecione** seu vídeo
4. **View** → **Advanced Controls** (mostra botões extras)
5. **Playback** → **Record** (botão vermelho)
6. **Play** o vídeo a partir de 0.5s
7. **Pause** no final
8. **Stop Record**
9. Vídeo salvo em `C:\Users\[seu_usuario]\Videos\`

**OU** (Método de conversão):

1. **Media** → **Convert/Save**
2. **Add** seu vídeo
3. **Convert/Save** (botão)
4. **Tools** → **Preferences** → **Show settings: All**
5. **Stream output** → **Transcode** → **Filters**
6. Configure para começar em 0.5s

*(Método mais complicado, recomendo usar online)*

---

## 🎯 Recomendação

**Use o Método 1 (Online Video Cutter)** porque:
- ✅ Não precisa instalar nada
- ✅ Interface visual intuitiva
- ✅ Rápido e fácil
- ✅ Mantém qualidade do vídeo
- ✅ Funciona em 2 minutos

---

## 📋 Passo a Passo Detalhado (Método Online)

### 1. Acesse o site
```
https://online-video-cutter.com/
```

### 2. Upload do vídeo
- Click no botão azul "Open file"
- Navegue até: `d:\projetos\cooper_maratonista\assets\bolt\expressions\`
- Selecione `ganhar_xp.mp4`
- Aguarde o upload

### 3. Ajustar o corte
- Você verá uma linha do tempo do vídeo
- No **início** (lado esquerdo), há um marcador
- Arraste esse marcador para a direita até marcar **0.5s**
- OU: Digite "0.5" no campo de tempo inicial

### 4. Salvar
- Click no botão "Save" (canto inferior direito)
- Aguarde o processamento (alguns segundos)
- Download automático iniciará

### 5. Substituir
- Vá para: `d:\projetos\cooper_maratonista\assets\bolt\expressions\`
- **Backup**: Renomeie o original para `ganhar_xp_original.mp4`
- Copie o vídeo baixado para a pasta
- Renomeie para `ganhar_xp.mp4`

### 6. Testar
- Execute: `flutter pub get` (se ainda não rodou)
- Execute o app
- Toque no ícone 📹 e teste o vídeo

---

## ⚠️ Cuidados

### Qualidade:
- Sites online podem comprimir o vídeo
- Se perder qualidade, use FFmpeg em vez disso
- Mantenha sempre um backup do original

### Formato:
- Certifique-se que o output continua sendo MP4
- Codec: H.264 (padrão da maioria dos sites)

### Tamanho:
- Vídeo cortado deve ficar menor
- Ideal: < 3MB

---

## 🐛 Solução de Problemas

### "Vídeo não carrega no site"
**Solução**: Use outro site (Kapwing) ou converta para MP4 primeiro

### "Vídeo ficou com qualidade ruim"
**Solução**: 
1. Use FFmpeg em vez de site online
2. Configure qualidade no site (se tiver opção)

### "Não consigo substituir o arquivo"
**Solução**:
1. Feche o Flutter app
2. Feche qualquer player de vídeo
3. Tente novamente

### "Arquivo muito grande após corte"
**Solução**: Comprima o vídeo:
- Site: https://www.videosmaller.com/
- Ou use FFmpeg com recodificação

---

## 🔄 Depois de Cortar

1. ✅ Substituir arquivo em `assets\bolt\expressions\ganhar_xp.mp4`
2. ✅ **NÃO** precisa rodar `flutter pub get` de novo
3. ✅ Só reiniciar o app (hot reload não funciona para assets)
4. ✅ Testar no app

---

## 💡 Dica Extra

Se você vai gerar vários vídeos, considere:
1. Gerar todos os vídeos com a duração correta desde o início
2. Ajustar os prompts para IAs começarem na ação imediatamente
3. Ou cortar em lote usando FFmpeg script

---

## ✅ Checklist

- [ ] Fazer backup do vídeo original
- [ ] Escolher método de corte (recomendo: online)
- [ ] Cortar 0.5s do início
- [ ] Verificar que ficou correto (assistir antes)
- [ ] Substituir arquivo em `assets\bolt\expressions\`
- [ ] Reiniciar o app Flutter
- [ ] Testar a animação
- [ ] Se ficou bom, deletar backup

---

**Tempo estimado**: 2-5 minutos  
**Dificuldade**: ⭐ Fácil (método online)  
**Recomendação**: Use https://online-video-cutter.com/

🎬 Boa sorte com o corte!
