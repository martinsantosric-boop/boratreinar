# 🛠️ Guia de Instalação do Flutter no Windows

## ✅ Pré-requisitos

Antes de instalar o Flutter, você precisa:
- Windows 10 ou superior (64-bit)
- ~2.5 GB de espaço em disco
- Git instalado
- PowerShell 5.0 ou superior

---

## 📥 MÉTODO 1: Instalação Rápida (Recomendado)

### Passo 1: Baixar o Flutter

1. Acesse: https://docs.flutter.dev/get-started/install/windows
2. Clique em **"Download Flutter SDK"**
3. Ou baixe direto: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip

### Passo 2: Extrair

1. Extraia o arquivo ZIP para um local permanente
2. **Recomendado:** `C:\src\flutter` (NÃO use pastas com espaços ou caracteres especiais)
3. **NÃO extraia para:** Arquivos de Programas, User, Desktop

```powershell
# Criar diretório (se não existir)
mkdir C:\src

# Extrair manualmente o ZIP para C:\src\flutter
```

### Passo 3: Adicionar ao PATH

#### Opção A: Via Interface Gráfica

1. Pressione `Win + R`
2. Digite: `sysdm.cpl` e pressione Enter
3. Vá para aba **"Avançado"**
4. Clique em **"Variáveis de Ambiente"**
5. Em **"Variáveis do usuário"**, selecione **Path** e clique **"Editar"**
6. Clique **"Novo"** e adicione: `C:\src\flutter\bin`
7. Clique **OK** em todas as janelas

#### Opção B: Via PowerShell (como Admin)

```powershell
# Abra PowerShell como Administrador
# Adicione Flutter ao PATH permanentemente
[System.Environment]::SetEnvironmentVariable(
    'Path',
    [System.Environment]::GetEnvironmentVariable('Path', 'User') + ";C:\src\flutter\bin",
    'User'
)
```

### Passo 4: Verificar Instalação

**Abra um NOVO PowerShell/CMD** (feche o anterior) e execute:

```bash
flutter --version
```

Deve mostrar algo como:
```
Flutter 3.24.5 • channel stable • https://github.com/flutter/flutter.git
Framework • revision xxx
Engine • revision xxx
Tools • Dart 3.5.4 • DevTools 2.37.3
```

---

## 🔧 Passo 5: Executar Flutter Doctor

```bash
flutter doctor
```

Vai mostrar o que está faltando. Exemplo:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.5, on Microsoft Windows)
[✗] Android toolchain - develop for Android devices
    ✗ Android SDK not found
[✗] Chrome - develop for the web
    ✗ Chrome not found
[✓] Visual Studio - develop Windows apps
[!] Android Studio (not installed)
[✓] VS Code (version 1.95.0)
[✓] Connected device (1 available)
[✓] Network resources
```

---

## 🌐 Para Rodar na WEB (Mais Fácil)

### Instalar Chrome (se não tiver)

1. Baixe: https://www.google.com/chrome/
2. Instale normalmente

### Testar

```bash
flutter doctor
# Deve mostrar [✓] Chrome

cd d:\Projetos\boratreinar
flutter pub get
flutter run -d chrome
```

**PRONTO! O app abre no navegador! 🎉**

---

## 📱 Para Rodar no ANDROID (Opcional)

### 1. Instalar Android Studio

1. Baixe: https://developer.android.com/studio
2. Execute o instalador
3. Na primeira execução, marque:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device
4. Clique **Next → Finish**

### 2. Aceitar Licenças

```bash
flutter doctor --android-licenses
# Aperte 'y' para todas
```

### 3. Criar Emulador

No Android Studio:
1. **Tools → Device Manager**
2. **Create Device**
3. Escolha **Pixel 5** ou qualquer device
4. Download **System Image** (recomendo Android 13/API 33)
5. **Finish**

### 4. Rodar no Emulador

```bash
flutter devices  # Listar devices
flutter run  # Roda no device disponível
```

---

## 🪟 Para Rodar no WINDOWS (Desktop)

### 1. Instalar Visual Studio 2022

Você já deve ter, mas precisa dos componentes C++:

1. Baixe: https://visualstudio.microsoft.com/downloads/
2. Instale **Visual Studio 2022 Community** (grátis)
3. No instalador, marque:
   - ✅ Desktop development with C++
   - ✅ Windows 10/11 SDK

### 2. Ativar Desktop

```bash
flutter config --enable-windows-desktop
```

### 3. Rodar

```bash
flutter run -d windows
```

---

## 🚀 INÍCIO RÁPIDO - Bora Treinar

### Opção 1: WEB (Mais Rápido)

```bash
# 1. Navegar até o projeto
cd d:\Projetos\boratreinar

# 2. Instalar dependências
flutter pub get

# 3. Rodar
flutter run -d chrome
```

### Opção 2: Windows Desktop

```bash
cd d:\Projetos\boratreinar
flutter pub get
flutter run -d windows
```

### Opção 3: Android Emulator

```bash
cd d:\Projetos\boratreinar
flutter pub get
flutter emulators --launch <emulator_id>  # Se tiver criado
flutter run
```

---

## 🛠️ Comandos Úteis

```bash
# Verificar instalação
flutter doctor -v

# Listar devices disponíveis
flutter devices

# Atualizar Flutter
flutter upgrade

# Limpar cache se der problema
flutter clean
flutter pub get

# Ver versão
flutter --version

# Analisar código (ver erros)
flutter analyze

# Formatar código
flutter format .

# Rodar em modo debug
flutter run --debug

# Rodar em modo release (mais rápido)
flutter run --release

# Hot reload durante desenvolvimento
# (com app rodando, pressione 'r' no terminal)

# Hot restart
# (com app rodando, pressione 'R' no terminal)
```

---

## 🐛 Problemas Comuns

### "flutter: The term 'flutter' is not recognized"

**Solução:**
1. Verifique se adicionou ao PATH corretamente
2. **Feche e abra um NOVO terminal**
3. Execute: `flutter --version`

### "Android licenses not accepted"

**Solução:**
```bash
flutter doctor --android-licenses
```

### "Chrome not found"

**Solução:**
1. Instale Google Chrome
2. Execute: `flutter doctor`

### "Git not found"

**Solução:**
1. Baixe: https://git-scm.com/download/win
2. Instale
3. Reinicie o terminal

### "Visual Studio not found" (para Windows desktop)

**Solução:**
1. Instale Visual Studio 2022 Community
2. Marque "Desktop development with C++"

### Erro "Waiting for another flutter command to release the startup lock"

**Solução:**
```bash
# Deleta o lock
del C:\src\flutter\bin\cache\lockfile
# ou
rm C:\src\flutter\bin\cache\lockfile
```

---

## 📊 Checklist de Instalação

```
[ ] Flutter SDK baixado e extraído
[ ] Flutter adicionado ao PATH
[ ] Terminal reiniciado
[ ] flutter --version funciona
[ ] flutter doctor executado
[ ] Chrome instalado (para web)
[ ] Android Studio instalado (para mobile - opcional)
[ ] Visual Studio 2022 instalado (para desktop - opcional)
[ ] Todas as licenças aceitas
[ ] flutter pub get executado no projeto
[ ] flutter run funcionou
```

---

## 🎯 Próximo Passo

Depois de instalar:

```bash
cd d:\Projetos\boratreinar
flutter pub get
flutter run -d chrome
```

**E veja o Bolt em ação! ⚡**

---

## 📚 Recursos

- **Documentação Oficial:** https://docs.flutter.dev
- **Flutter YouTube:** https://www.youtube.com/c/flutterdev
- **Flutter Cookbook:** https://docs.flutter.dev/cookbook
- **Pub.dev (Packages):** https://pub.dev
- **Flutter Community:** https://flutter.dev/community

---

## 💡 Dicas Pro

1. **Use VS Code com extensões:**
   - Flutter
   - Dart
   - Error Lens

2. **Atalhos úteis:**
   - `Ctrl + S` → Hot reload automático
   - `r` no terminal → Hot reload manual
   - `R` no terminal → Hot restart
   - `q` no terminal → Quit

3. **Ordem recomendada:**
   - Teste primeiro na WEB (mais rápido)
   - Depois tente Windows Desktop
   - Por último Android (mais pesado)

---

**Bora instalar e rodar! 🚀**
