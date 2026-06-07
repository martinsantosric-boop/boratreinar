# 🤖 Personal Trainer IA - Bolt

> **Status:** ✅ Implementado | **Modelo:** Gemini 1.5 Flash | **Tier:** Gratuito

---

## 🎯 Visão Geral

O **Bolt Personal Trainer** é uma IA integrada ao app que funciona como um coach virtual, oferecendo:

- 💪 **Planos de treino personalizados** baseados no seu histórico
- 📊 **Análise de desempenho** das suas corridas
- 🎯 **Metas realistas** adaptadas ao seu nível
- 💡 **Dicas profissionais** sobre corrida, pace e prevenção de lesões
- ⚡️ **Motivação constante** com a personalidade única do Bolt

---

## 🚀 Como Usar

### No App:

1. **Abra o Cooper Maratonista**
2. **Toque no ícone 🧠** no canto superior direito
3. **Converse com o Bolt!**

### Exemplos de Perguntas:

```
🎯 "Como começar a correr?"
📈 "Monte um plano de treino pra mim"
⚡️ "Como melhorar meu pace?"
🏃‍♂️ "Devo treinar todo dia?"
📊 "Análise minhas últimas corridas"
💪 "Como evitar lesões?"
```

---

## ⚙️ Configuração (Developer)

### Quick Start (5 minutos):

1. **Obter API Key:** https://aistudio.google.com/app/apikey
2. **Colar no código:** `lib/services/ai_personal_trainer_service.dart` linha 10
3. **Buildar:** `flutter build apk --release`
4. **Testar!** 🎉

### Documentação Completa:
- 📘 **CONFIGURAR_IA_PERSONAL_TRAINER.md** - Guia detalhado
- 📗 **QUICK_START_IA.md** - 3 passos rápidos
- 📙 **INTEGRACAO_IA_RESUMO.md** - Resumo técnico

---

## 💰 Custos

### Tier Gratuito (Suficiente para o app):
- ✅ **15 mensagens/minuto**
- ✅ **1.500 mensagens/dia**
- ✅ **1 milhão tokens/dia**

**Para 100 usuários ativos:** Totalmente gratuito! 🎉

---

## 🧠 Inteligência do Bolt

### Contexto Personalizado:
O Bolt tem acesso a:
- ✅ Seu nome e nível atual
- ✅ Total de XP conquistado
- ✅ Últimas 3 corridas (distância, pace, duração)
- ✅ Histórico da conversa

### Personalidade:
- ⚡️ Motivador e enérgico
- 💬 Linguagem casual mas profissional
- 🎯 Respostas curtas e práticas (<150 palavras)
- 🚫 Nunca dá diagnósticos médicos

---

## 🎨 Interface

```
╔════════════════════════════════════╗
║  ⚡️ Bolt - Personal Trainer    🔄 ║
║  Online                            ║
╠════════════════════════════════════╣
║                                    ║
║  ⚡️ [Bolt]                         ║
║  ┌──────────────────────────────┐  ║
║  │ Olá! Eu sou o Bolt, seu     │  ║
║  │ personal trainer virtual! ⚡️ │  ║
║  │                              │  ║
║  │ Como posso te ajudar hoje?  │  ║
║  └──────────────────────────────┘  ║
║                                    ║
║  [🎯 Como começar a correr?    ]  ║
║  [⏱️ O que é o Teste de Cooper?]  ║
║                                    ║
║                     [Você] 👤      ║
║              ┌──────────────────┐  ║
║              │ Como melhorar    │  ║
║              │ meu pace?        │  ║
║              └──────────────────┘  ║
║                                    ║
║  ⚡️ [Bolt]                         ║
║  ┌──────────────────────────────┐  ║
║  │ Para melhorar o pace:       │  ║
║  │                              │  ║
║  │ 1. Treinos intervalados     │  ║
║  │ 2. Corridas longas e leves  │  ║
║  │ 3. Descanso adequado 💪     │  ║
║  └──────────────────────────────┘  ║
║                                    ║
╠════════════════════════════════════╣
║ [Digite sua pergunta...]      [📤]║
╚════════════════════════════════════╝
```

---

## 📊 Tecnologia

- **Modelo:** Gemini 1.5 Flash (Google AI)
- **API:** Google AI Generative Language API
- **Framework:** Flutter/Dart
- **HTTP Client:** package `http` ^1.2.2
- **Safety:** Filtros habilitados (assédio, ódio, sexual, perigo)

---

## 🔒 Segurança

### Para Developers:
⚠️ **NUNCA comite a API Key no Git!**

Use variáveis de ambiente:
```bash
flutter build apk --release --dart-define=GEMINI_API_KEY=sua_key
```

### Para Usuários:
✅ Todas as conversas são processadas pela API do Google
✅ Filtros de segurança habilitados
✅ Bolt nunca dá diagnósticos médicos

---

## 📈 Roadmap Futuro

### Fase 2 (Opcional):
- [ ] Cache de respostas comuns
- [ ] Modo offline com respostas pré-definidas
- [ ] Análise de sentimento
- [ ] Push notifications proativas

### Fase 3 (Avançado):
- [ ] Voice input/output (falar com o Bolt)
- [ ] Exportar planos de treino (PDF)
- [ ] Análise de imagem (postura)
- [ ] Integração com smartwatches

---

## 📚 Links Úteis

- 🔑 **API Key:** https://aistudio.google.com/app/apikey
- 📖 **Docs Gemini:** https://ai.google.dev/docs
- 🔥 **Firebase:** https://console.firebase.google.com/
- 💵 **Pricing:** https://ai.google.dev/pricing

---

## 🎉 Pronto!

Seu Personal Trainer IA está implementado e pronto para uso!

**Próximo passo:** Configurar a API Key e fazer o primeiro treino com o Bolt! 💪⚡️

---

**Made with ❤️ using Gemini 1.5 Flash**
