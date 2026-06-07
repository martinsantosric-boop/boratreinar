# 🚀 Quick Start - Personal Trainer IA

## ⚡️ 3 Passos Rápidos

### 1️⃣ Obter API Key (2 minutos)

Acesse: **https://aistudio.google.com/app/apikey**

Clique em **"Get API Key"** → Copie a chave (formato: `AIzaSy...`)

---

### 2️⃣ Configurar no Código (1 minuto)

Abra: `lib/services/ai_personal_trainer_service.dart`

**Linha 7-11**, substitua:
```dart
static const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: 'YOUR_GEMINI_API_KEY_HERE', // ← COLE SUA API KEY AQUI
);
```

Por:
```dart
static const String _apiKey = 'AIzaSyABC123...'; // ← SUA API KEY
```

---

### 3️⃣ Buildar e Testar (10 minutos)

```bash
flutter clean
flutter pub get
flutter build apk --release
adb install build\app\outputs\flutter-apk\app-release.apk
```

**No app:**
1. Toque no ícone **🧠** no canto superior direito
2. Digite: "Como começar a correr?"
3. Pronto! O Bolt vai responder ⚡️

---

## 📊 Limites (Gratuito)

- ✅ **15 mensagens por minuto**
- ✅ **1.500 mensagens por dia**
- ✅ **1 milhão de tokens por dia**

**Perfeito para o app!** 🎉

---

## 🛡️ Segurança (IMPORTANTE)

⚠️ **NUNCA** comite a API Key no Git!

Adicione ao `.gitignore`:
```
# API Keys
lib/services/ai_personal_trainer_service.dart
```

Ou use variável de ambiente:
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=SUA_API_KEY
```

---

## 📚 Documentação Completa

Leia: **`CONFIGURAR_IA_PERSONAL_TRAINER.md`** para:
- Firebase App Check (segurança avançada)
- Troubleshooting
- Melhorias futuras
- Links úteis

---

**Pronto! Seu Personal Trainer IA está funcionando! 💪⚡️**
