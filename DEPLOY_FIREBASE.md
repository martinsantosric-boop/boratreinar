# 🚀 Deploy Firebase Hosting - Bora Treinar

## ✅ Status Atual

- ✅ Firebase já configurado: **gotreiinar**
- ✅ Hosting apontando para `build/web`
- ✅ Rewrites configurados para SPA

---

## 📋 Pré-requisitos

### 1. Node.js e npm

Verifique se já tem:
```bash
node --version
npm --version
```

Se não tiver, baixe: https://nodejs.org/

### 2. Firebase CLI

Instalar globalmente:
```bash
npm install -g firebase-tools
```

Verificar instalação:
```bash
firebase --version
```

---

## 🔐 Autenticação

Faça login no Firebase:
```bash
firebase login
```

Vai abrir o navegador para você fazer login com sua conta Google.

Verificar login:
```bash
firebase projects:list
```

Deve mostrar o projeto **gotreiinar**.

---

## 🏗️ Build do App Flutter

### Passo 1: Limpar cache

```bash
cd d:\Projetos\boratreinar
flutter clean
```

### Passo 2: Obter dependências

```bash
flutter pub get
```

### Passo 3: Build para Web (Release)

```bash
flutter build web --release
```

Este comando:
- Compila o app Flutter para web
- Otimiza o código (minificação)
- Gera arquivos na pasta `build/web/`
- **Demora ~2-5 minutos**

---

## 🚀 Deploy

### Opção 1: Deploy Simples

```bash
firebase deploy --only hosting
```

### Opção 2: Preview antes do deploy

```bash
# Deploy em canal de preview
firebase hosting:channel:deploy preview

# Se gostar, promove para produção
firebase hosting:clone preview:live
```

---

## 📊 Comandos Completos (Copy-Paste)

Execute estes comandos em ordem:

```bash
# 1. Ir para o projeto
cd d:\Projetos\boratreinar

# 2. Limpar cache
flutter clean

# 3. Instalar dependências
flutter pub get

# 4. Build web release
flutter build web --release

# 5. Deploy Firebase
firebase deploy --only hosting
```

---

## 🌐 Resultado

Após o deploy, você verá:

```
✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/gotreiinar/overview
Hosting URL: https://gotreiinar.web.app
```

Seu app estará disponível em:
- **https://gotreiinar.web.app**
- **https://gotreiinar.firebaseapp.com**

---

## 🔧 Otimizações de Build

### Build com Web Renderer específico

```bash
# HTML renderer (mais compatível)
flutter build web --web-renderer html --release

# CanvasKit renderer (melhor performance)
flutter build web --web-renderer canvaskit --release

# Auto (Flutter decide)
flutter build web --web-renderer auto --release
```

Recomendação: Use `--web-renderer html` para melhor compatibilidade.

### Build com análise de tamanho

```bash
flutter build web --release --analyze-size
```

---

## 📝 Script Automático

Crie um arquivo `deploy.bat` na raiz:

```batch
@echo off
echo ========================================
echo   DEPLOY BORA TREINAR - FIREBASE
echo ========================================
echo.

echo [1/5] Limpando cache...
call flutter clean

echo.
echo [2/5] Instalando dependencias...
call flutter pub get

echo.
echo [3/5] Analisando codigo...
call flutter analyze

echo.
echo [4/5] Compilando para Web (Release)...
call flutter build web --release --web-renderer html

echo.
echo [5/5] Fazendo deploy no Firebase...
call firebase deploy --only hosting

echo.
echo ========================================
echo   DEPLOY CONCLUIDO!
echo ========================================
echo.
echo Acesse: https://gotreiinar.web.app
echo.
pause
```

Depois só execute:
```bash
.\deploy.bat
```

---

## 🐛 Problemas Comuns

### "firebase: command not found"

**Solução:**
```bash
npm install -g firebase-tools
```

### "Error: HTTP Error: 403, The caller does not have permission"

**Solução:**
```bash
firebase logout
firebase login
```

### "Flutter build failed"

**Solução:**
```bash
flutter clean
flutter pub get
flutter doctor
flutter build web --release
```

### Build demora muito

**Normal!** Primeira build pode demorar 5-10 minutos.
Builds subsequentes são mais rápidas (~2 minutos).

### Erro de memória durante build

**Solução:**
```bash
# Build com menos otimizações
flutter build web --release --no-tree-shake-icons
```

---

## 📊 Checklist de Deploy

```
[ ] Node.js instalado
[ ] Firebase CLI instalado
[ ] firebase login executado
[ ] flutter clean
[ ] flutter pub get
[ ] flutter build web --release (sucesso)
[ ] firebase deploy --only hosting
[ ] App acessível em https://gotreiinar.web.app
[ ] Testar login
[ ] Testar funcionalidades principais
```

---

## 🔄 Fluxo de Desenvolvimento

### Para testar localmente:

```bash
flutter run -d chrome
```

### Para deploy:

```bash
flutter build web --release
firebase deploy --only hosting
```

### Para rollback (se der problema):

```bash
# Listar versões anteriores
firebase hosting:releases:list

# Fazer rollback
firebase hosting:rollback
```

---

## 📈 Monitoramento

### Ver logs em tempo real:

1. Acesse: https://console.firebase.google.com/project/gotreiinar/hosting
2. Veja analytics, tráfego, erros

### Analytics

O Firebase já captura automaticamente:
- Pageviews
- Usuários ativos
- Retenção
- Origem do tráfego

---

## 🎯 Próximos Passos Após Deploy

### 1. Configurar Domínio Customizado

No Firebase Console:
1. Hosting → Add custom domain
2. Siga instruções para adicionar DNS records

### 2. Habilitar HTTPS

Automático no Firebase Hosting! 🔒

### 3. Performance

Já está otimizado:
- ✅ CDN global
- ✅ Gzip/Brotli compression
- ✅ Caching automático
- ✅ HTTP/2

### 4. Supabase Config

Atualize `lib/config/supabase_config.dart` se necessário:

```dart
static const authRedirectUrl = String.fromEnvironment(
  'SUPABASE_AUTH_REDIRECT_URL',
  defaultValue: 'https://gotreiinar.web.app',
);
```

---

## 💡 Dicas Pro

### 1. Preview Deploy

Sempre teste em preview antes de produção:
```bash
firebase hosting:channel:deploy preview
# Testa em: https://gotreiinar--preview-xxx.web.app
```

### 2. CI/CD com GitHub Actions

Crie `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.5'
      - run: flutter pub get
      - run: flutter build web --release
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: gotreiinar
```

### 3. Cache de Build

Para acelerar builds subsequentes:
```bash
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=false
```

---

## 📱 PWA (Progressive Web App)

O app já é configurado como PWA! 🎉

Usuários podem:
- Instalar no desktop/mobile
- Usar offline (parcialmente)
- Receber notificações

Configurado em: `web/manifest.json`

---

## 🎨 Customizar Splash Screen Web

Edite `web/index.html`:

```html
<style>
  #loading {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background: #58CC02;
  }
</style>
<div id="loading">
  <h1 style="color: white; font-size: 48px;">⚡ Bora Treinar</h1>
</div>
```

---

## 🚀 COMANDO RÁPIDO (TL;DR)

```bash
cd d:\Projetos\boratreinar && flutter clean && flutter pub get && flutter build web --release && firebase deploy --only hosting
```

**Um comando só! Copy & Paste! 🔥**

---

**Pronto para deploy! Execute os comandos e me avise o resultado! 🚀**
