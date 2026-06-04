# 🐍 Guia de Instalação do Python no Windows

## 📥 Download e Instalação

### 1. Baixar Python

**Acesse:** https://www.python.org/downloads/

Ou baixe direto a versão mais recente:
**https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe**

### 2. Instalar

1. Execute o instalador baixado
2. **⚠️ IMPORTANTE:** Marque **"Add Python to PATH"** (primeira opção)
3. Clique em **"Install Now"**
4. Aguarde a instalação (~5 minutos)
5. Clique em **"Close"**

---

## ✅ Verificar Instalação

### Feche e abra um NOVO PowerShell, depois execute:

```powershell
python --version
```

Deve mostrar algo como:
```
Python 3.12.0
```

### Verificar pip:

```powershell
pip --version
```

Deve mostrar algo como:
```
pip 23.x.x from ...
```

---

## 🚀 Instalar Bibliotecas para Remover Fundo

```powershell
pip install rembg pillow
```

Vai demorar ~2-3 minutos baixando e instalando.

---

## 🎨 Executar Script de Remoção de Fundo

```powershell
cd d:\Projetos\boratreinar
python remove_background.py
```

**Vai processar automaticamente todas as 12 imagens do Bolt! ⚡**

---

## 🐛 Problemas Comuns

### "python: The term 'python' is not recognized"

**Solução:**
1. Durante a instalação, você NÃO marcou "Add Python to PATH"
2. **Reinstale** o Python e marque a opção
3. OU adicione manualmente ao PATH:
   - Pressione `Win + R`
   - Digite `sysdm.cpl`
   - Aba **Avançado** → **Variáveis de Ambiente**
   - Edite **Path** e adicione: `C:\Users\SEU_USUARIO\AppData\Local\Programs\Python\Python312\`
   - E: `C:\Users\SEU_USUARIO\AppData\Local\Programs\Python\Python312\Scripts\`

### "pip: The term 'pip' is not recognized"

**Solução:**
```powershell
python -m pip install --upgrade pip
```

### Erro durante instalação do rembg

**Solução:**
```powershell
# Atualizar pip primeiro
python -m pip install --upgrade pip

# Instalar novamente
pip install rembg pillow
```

---

## 📋 Checklist de Instalação

```
[ ] Python baixado
[ ] Python instalado com "Add to PATH" marcado
[ ] Terminal FECHADO e reaberto
[ ] python --version funciona
[ ] pip --version funciona
[ ] pip install rembg pillow executado
[ ] python remove_background.py executado
[ ] Imagens processadas em assets/bolt/expressions/ e assets/bolt/leagues/
```

---

## 🔄 Fluxo Completo

```powershell
# 1. Verificar Python
python --version

# 2. Instalar bibliotecas
pip install rembg pillow

# 3. Ir para o projeto
cd d:\Projetos\boratreinar

# 4. Executar script
python remove_background.py

# 5. Verificar imagens geradas
dir assets\bolt\expressions
dir assets\bolt\leagues

# 6. Build e Deploy
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

---

## 💡 Alternativas

Se não conseguir instalar o Python:

### Opção 1: Microsoft Store (Mais Fácil)
1. Abra Microsoft Store
2. Busque "Python 3.12"
3. Clique "Instalar"
4. Pronto! PATH já configurado automaticamente

### Opção 2: Chocolatey
```powershell
# Instalar Chocolatey primeiro (se tiver)
choco install python

# Verificar
python --version
```

### Opção 3: Remove.bg Online
Já explicamos antes - processa manualmente no site.

---

## 🎯 Próximos Passos

Após instalar Python:

1. Feche e abra NOVO terminal
2. Execute: `pip install rembg pillow`
3. Execute: `python remove_background.py`
4. Veja a mágica acontecer! ✨

---

**Baixe o Python agora e me avise quando instalar! 🐍**
