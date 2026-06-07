# 🤖 Configurar IA Personal Trainer (Gemini)

**Data:** 06/06/2026  
**Status:** ✅ Código implementado - Necessita configuração da API Key

---

## 📋 O Que Foi Implementado

### ✅ Arquivos Criados

1. **`lib/services/ai_personal_trainer_service.dart`**
   - Serviço de comunicação com Gemini API
   - Contexto personalizado baseado em dados do usuário
   - Histórico de conversação
   - Fallback quando API não está configurada

2. **`lib/screens/ai_coach_screen.dart`**
   - Interface de chat estilo WhatsApp
   - Avatar do Bolt ⚡️
   - Sugestões rápidas personalizadas
   - Indicador de digitação
   - Scroll automático

3. **Integração no App**
   - Botão 🧠 (psychology) no AppBar da HomeScreen
   - Navegação direta para o chat

---

## 🔑 Passo 1: Obter API Key do Gemini

### Opção A: Google AI Studio (Mais Rápido) ⭐ RECOMENDADO

1. Acesse: **https://aistudio.google.com/app/apikey**

2. Clique em **"Get API Key"** ou **"Create API Key"**

3. Escolha um projeto do Google Cloud ou crie um novo

4. **Copie a chave** (formato: `AIzaSy...`)

5. ⚠️ **IMPORTANTE:** Essa chave é gratuita com limites generosos:
   - **15 requisições por minuto (RPM)**
   - **1 milhão de tokens por dia**
   - **1.500 requisições por dia (RPD)**

### Opção B: Firebase Console (Mais Integrado)

1. Acesse: **https://console.firebase.google.com/**

2. Selecione seu projeto **Cooper Maratonista**

3. No menu lateral, vá em: **Build** → **Vertex AI in Firebase**

4. Clique em **"Get Started"**

5. Ative o **Gemini API**

6. Copie a **API Key** gerada

---

## 🔧 Passo 2: Configurar a API Key no App

### Método 1: Hardcode (Desenvolvimento/Testes)

Abra o arquivo: `lib/services/ai_personal_trainer_service.dart`

Substitua:
```dart
static const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
);
```

Por:
```dart
static const String _apiKey = 'SUA_API_KEY_AQUI'; // Ex: AIzaSyABC123...
```

### Método 2: Variável de Ambiente (Produção) ⭐ RECOMENDADO

**Para Build Local:**
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=SUA_API_KEY_AQUI
```

**Para Desenvolvimento:**
```bash
flutter run --dart-define=GEMINI_API_KEY=SUA_API_KEY_AQUI
```

**Para VS Code/Kiro:**

Crie/edite `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (com IA)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=GEMINI_API_KEY=SUA_API_KEY_AQUI"
      ]
    }
  ]
}
```

### Método 3: Arquivo .env (Alternativa)

1. Adicione ao `pubspec.yaml`:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

2. Crie arquivo `.env` na raiz:
```env
GEMINI_API_KEY=SUA_API_KEY_AQUI
```

3. Adicione `.env` ao `.gitignore`:
```
.env
```

4. Modifique o service para carregar:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
```

---

## 🛡️ Passo 3: Segurança - Firebase App Check (IMPORTANTE)

O Firebase recomenda usar **App Check** para evitar:
- ❌ Acesso não autorizado à API
- ❌ Fraude de faturamento
- ❌ Uso indevido da sua quota

### Ativar App Check:

1. **Firebase Console** → **Build** → **App Check**

2. Clique em **"Get Started"**

3. Registre seu app Android:
   - **Package Name:** `com.tecnicorikardo.cooper_maratonista`
   - **SHA-256:** Execute no terminal:
     ```bash
     cd android
     ./gradlew signingReport
     ```
   - Copie o **SHA-256** da variante `release`

4. Escolha o provedor de atestado:
   - **Play Integrity** (recomendado para produção)
   - **Debug** (para desenvolvimento)

5. Adicione dependência no `pubspec.yaml`:
```yaml
dependencies:
  firebase_app_check: ^0.3.1+3
```

6. Inicialize no `main.dart`:
```dart
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.publishableKey,
  );
  
  runApp(const CooperMaratonistaApp());
}
```

---

## 📊 Limites da API (Tier Gratuito)

| Modelo | RPM (Requisições/min) | TPM (Tokens/min) | RPD (Requisições/dia) |
|--------|----------------------|------------------|---------------------|
| **Gemini 1.5 Flash** | 15 | 1.000.000 | 1.500 |
| **Gemini 1.5 Pro** | 2 | 32.000 | 50 |

**Para este app, Gemini 1.5 Flash é perfeito!**

---

## 🧪 Passo 4: Testar a Integração

### 1. Buildar com a API Key:

**Método Hardcode:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Método Variável:**
```bash
flutter clean
flutter pub get
flutter build apk --release --dart-define=GEMINI_API_KEY=SUA_API_KEY
```

### 2. Instalar no dispositivo:
```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

### 3. Testar no app:
1. Abra o app **Cooper Maratonista**
2. Na tela inicial, toque no ícone **🧠** (canto superior direito)
3. Digite uma pergunta, por exemplo:
   - "Como começar a correr?"
   - "Monte um plano de treino pra mim"
   - "Qual meu pace ideal?"

### 4. Verificar resposta:
- ✅ **Sucesso:** Bolt responde com orientações personalizadas
- ❌ **Fallback:** Mostra mensagem genérica (API não configurada)

---

## 🎯 Funcionalidades do Personal Trainer IA

### 🤖 Personalidade do Bolt
- Motivador e enérgico ⚡️
- Usa emojis (🏃‍♂️, 💪, 🎯)
- Linguagem casual mas profissional
- Celebra conquistas

### 📊 Contexto Personalizado
O Bolt tem acesso a:
- ✅ Nome do usuário
- ✅ Nível atual (XP)
- ✅ Últimas 3 corridas (distância, pace, duração)
- ✅ Histórico da conversa (últimas 4 mensagens)

### 💡 Tópicos que o Bolt Domina
- Cooper Test (12 minutos)
- Pace e ritmo
- Zonas de frequência cardíaca
- Periodização de treino
- Prevenção de lesões
- Nutrição básica para corredores
- Análise de desempenho

### 🚫 O Que o Bolt NÃO Faz
- ❌ Diagnósticos médicos
- ❌ Recomendação de medicamentos
- ❌ Ignora histórico de lesões
- ❌ Força além dos limites seguros

---

## 🎨 Interface do Chat

### Elementos Visuais:
- **Avatar do Bolt:** ⚡️ amarelo com borda branca
- **Avatar do Usuário:** 👤 azul
- **Bolhas de mensagem:** 
  - Bolt: fundo cinza claro
  - Usuário: fundo azul escuro
- **Indicador de digitação:** "Bolt está pensando..."

### Sugestões Rápidas:
**Para iniciantes (sem corridas):**
- 🎯 Como começar a correr?
- ⏱️ O que é o Teste de Cooper?
- 🏃‍♂️ Qual o melhor horário para treinar?
- 💡 Dicas para iniciantes

**Para intermediários (nível < 5):**
- 📈 Como melhorar meu pace?
- 🎯 Monte um plano de treino pra mim
- 💪 Como evitar lesões?
- 🏃‍♂️ Devo treinar todo dia?

**Para avançados (nível ≥ 5):**
- 🚀 Como fazer treino intervalado?
- ⚡️ Preparação para 10km
- 📊 Análise das minhas corridas
- 🎯 Próxima meta para mim

---

## ⚙️ Configurações Técnicas

### Parâmetros do Gemini:
```dart
'temperature': 0.7,        // Criatividade moderada
'topK': 40,               // Diversidade de vocabulário
'topP': 0.95,             // Qualidade das respostas
'maxOutputTokens': 300,   // ~150 palavras por resposta
```

### Safety Settings:
- ✅ Bloqueio de assédio
- ✅ Bloqueio de discurso de ódio
- ✅ Bloqueio de conteúdo sexual explícito
- ✅ Bloqueio de conteúdo perigoso

---

## 🐛 Troubleshooting

### Problema: "Erro ao chamar IA"

**Possíveis causas:**
1. API Key inválida ou expirada
2. Quota excedida (15 req/min)
3. Sem conexão com internet
4. Modelo não existe

**Soluções:**
```bash
# Verificar API Key
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=SUA_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":"teste"}]}]}'

# Se retornar 200 OK → API Key válida
# Se retornar 400/401 → API Key inválida
```

### Problema: Resposta genérica (fallback)

**Causa:** API não configurada ou falhou

**Solução:** 
- Verificar se a API Key está definida corretamente
- Verificar logs do console: `flutter logs`

### Problema: "Rate Limit Exceeded"

**Causa:** Mais de 15 requisições por minuto

**Solução:**
- Aguardar 1 minuto
- Implementar rate limiting no app (opcional)

---

## 📈 Próximos Passos (Melhorias Futuras)

### 🎯 Fase 2 (Opcional):
- [ ] Cache de respostas comuns
- [ ] Modo offline com respostas pré-definidas
- [ ] Análise de sentimento do usuário
- [ ] Sugestões proativas (push notifications)
- [ ] Integração com histórico completo de corridas

### 🎯 Fase 3 (Avançado):
- [ ] Planos de treino gerados pela IA (PDF/exportar)
- [ ] Voice input/output (falar com o Bolt)
- [ ] Análise de imagem (postura de corrida)
- [ ] Integração com wearables

---

## 📚 Links Úteis

- **Google AI Studio:** https://aistudio.google.com/
- **Gemini API Docs:** https://ai.google.dev/docs
- **Firebase Console:** https://console.firebase.google.com/
- **App Check Docs:** https://firebase.google.com/docs/app-check
- **Pricing:** https://ai.google.dev/pricing

---

## ✅ Checklist de Configuração

- [ ] Obtive a API Key do Gemini
- [ ] Configurei a API Key no código
- [ ] (Opcional) Configurei Firebase App Check
- [ ] Rodei `flutter pub get` para instalar `http`
- [ ] Testei o chat no app
- [ ] Bolt está respondendo corretamente
- [ ] API Key está segura (não commitada no Git)

---

## 🎉 Pronto!

Depois de seguir esses passos, seu Personal Trainer IA estará 100% funcional!

O Bolt vai ajudar os usuários com:
- 💪 Planos de treino personalizados
- 📊 Análise de desempenho
- 🎯 Metas e objetivos
- 💡 Dicas e orientações
- 🏃‍♂️ Motivação constante

**Importante:** Lembre-se de nunca commitar a API Key no repositório Git!

---

**Gerado em:** 06/06/2026  
**Versão do App:** 1.0.0+1  
**Modelo IA:** Gemini 1.5 Flash
