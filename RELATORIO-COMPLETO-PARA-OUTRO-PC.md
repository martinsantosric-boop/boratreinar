# 📦 Relatório Completo - Para Outro Computador

**Data**: 4 de junho de 2026  
**Projeto**: Bora Treinar (App de corrida gamificado)  
**URL**: https://gotreiinar.web.app

---

## 🎯 O QUE FOI FEITO NESTA SESSÃO

### Problema Inicial
- App com **tela em branco** após deploy
- Erro no `manifest.json` (syntax error)
- Vídeo `boratreinar.mp4` não aparecendo
- Cores verdes (#58CC02) em vez de azul (#0D1B2A)

### Soluções Aplicadas

#### 1. **Manifest.json corrigido**
**Arquivo**: `web/manifest.json`

Mudança de cores:
```json
// ANTES:
"background_color": "#58CC02",  // Verde Duolingo
"theme_color": "#58CC02"

// DEPOIS:
"background_color": "#0D1B2A",  // Azul escuro
"theme_color": "#0D1B2A"
```

#### 2. **Revertido para PNG estático**
**Arquivo**: `lib/screens/auth_screen.dart`

Simplificado código do personagem:
```dart
// ANTES: Vídeo complexo que não funcionava
import '../widgets/bolt_video_widget.dart';
BoltVideoWidget(size: size.width * 0.6)

// DEPOIS: PNG simples e confiável
import '../widgets/bolt_widget.dart';
const BoltWidget(
  expression: BoltExpression.ready,
  size: 250,
)
```

#### 3. **Widget funcional preservado**
**Arquivo**: `lib/widgets/bolt_widget.dart`
- ✅ Não modificado (já funcionava perfeitamente)
- Carrega PNGs de `assets/bolt/expressions/`
- Suporta múltiplas expressões e ligas

---

## 📁 ARQUIVOS IMPORTANTES

### Código Modificado (2 arquivos)
1. `web/manifest.json` - cores atualizadas
2. `lib/screens/auth_screen.dart` - usando PNG em vez de vídeo

### Código NÃO Modificado (funciona como está)
- `lib/widgets/bolt_widget.dart` - widget funcional
- `lib/theme/app_theme.dart` - tema azul #0D1B2A
- `pubspec.yaml` - dependências
- Todos os outros arquivos do Flutter

### Arquivos Opcionais (podem ser deletados)
- `lib/widgets/bolt_video_widget.dart` - não usado mais
- `assets/bolt/expressions/boratreinar.mp4` - vídeo não usado

---

## 🖼️ IMAGENS DO BOLT

### Imagens Processadas (COM fundo removido)

**Pasta**: `assets/bolt/expressions/`
- ✅ **ready.png** - USADO na tela de login (principal)
- ✅ happy.png
- ✅ excited.png
- ✅ fire.png
- ✅ trophy.png
- ✅ sleeping.png
- ✅ cool.png

**Pasta**: `assets/bolt/leagues/`
- ✅ bronze.png
- ✅ silver.png
- ✅ gold.png
- ✅ diamond.png
- ✅ legendary.png

### Imagens Originais (SEM processamento)

**Pasta**: `assets/bolt/fotos-boratreinar/`
- Todas as fotos originais do Bolt
- Não processadas (com fundo)
- Use `remove_background.py` se precisar reprocessar

### ⚠️ IMPORTANTE: Copie Estas Pastas Para o Outro PC

```
assets/
└─ bolt/
   ├─ expressions/      ⭐ NECESSÁRIO
   │  ├─ ready.png     ⭐ PRINCIPAL (tela de login)
   │  ├─ happy.png
   │  ├─ excited.png
   │  ├─ fire.png
   │  ├─ trophy.png
   │  ├─ sleeping.png
   │  └─ cool.png
   │
   ├─ leagues/          ⭐ NECESSÁRIO
   │  ├─ bronze.png
   │  ├─ silver.png
   │  ├─ gold.png
   │  ├─ diamond.png
   │  └─ legendary.png
   │
   └─ fotos-boratreinar/  (opcional - backup)
      └─ [imagens originais]
```

---

## 🔧 SETUP NO OUTRO COMPUTADOR

### Pré-requisitos

1. **Git** - para clonar o repositório
2. **Flutter 3.44.1+** - SDK do Flutter
3. **Python 3.14** (opcional - só se quiser processar imagens)
4. **Firebase CLI** - para deploy

### Passo 1: Clonar/Copiar Projeto

**Opção A - Se tiver Git configurado:**
```powershell
git clone [URL_DO_REPOSITORIO]
cd boratreinar
```

**Opção B - Copiar pasta manualmente:**
- Copie toda a pasta `D:\Projetos\boratreinar\` para o novo PC
- Ou use pendrive/OneDrive/Dropbox

### Passo 2: Instalar Flutter

**Windows:**
1. Baixe: https://docs.flutter.dev/get-started/install/windows
2. Extraia para `C:\flutter`
3. Adicione ao PATH: `C:\flutter\bin`
4. Abra PowerShell NOVO
5. Verifique: `flutter --version`

**Script automático** (se precisar):
```powershell
.\adicionar_flutter_path.ps1
```

### Passo 3: Instalar Firebase CLI

```powershell
npm install -g firebase-tools
```

Ou baixe standalone: https://firebase.tools

### Passo 4: Login Firebase

```powershell
firebase login
```

### Passo 5: Copiar Imagens (SE NÃO COPIOU A PASTA TODA)

Se você copiou só o código sem as imagens:

1. Copie do PC atual para pendrive:
   - `assets/bolt/expressions/` (7 PNGs)
   - `assets/bolt/leagues/` (5 PNGs)

2. Cole no novo PC no mesmo local:
   - `D:\Projetos\boratreinar\assets\bolt\expressions\`
   - `D:\Projetos\boratreinar\assets\bolt\leagues\`

### Passo 6: Build e Deploy

```powershell
cd D:\Projetos\boratreinar

# Atualizar dependências
flutter pub get

# Build
flutter build web --release

# Deploy
firebase deploy --only hosting
```

---

## 📋 COMANDOS ESSENCIAIS

### Build e Deploy (use sempre)
```powershell
# Completo
flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting

# Rápido (se já buildou antes)
flutter build web --release
firebase deploy --only hosting
```

### Testar Localmente (antes de deploy)
```powershell
flutter run -d chrome
```

### Ver Versões
```powershell
flutter --version
firebase --version
git --version
```

---

## 🎨 GERAR NOVO BOLT (Opcional)

Se quiser um Bolt melhor no novo PC:

### Prompt para IA (copie e use):
```
Crie um personagem mascote chamado Bolt para app de corrida.

Personagem: Cachorro branco cartoon 3D muito amigável e motivador, 
com símbolo de raio laranja no peito, sorrindo e fazendo gesto de 
positivo com a pata direita levantada.

Especificações técnicas:
- Tamanho: 1200x1200 pixels (quadrado)
- Fundo: azul escuro sólido cor #0D1B2A (muito importante!)
- Estilo: cartoon 3D limpo, moderno, tipo mascote de app
- Iluminação: suave e amigável
- Qualidade: alta definição
- Formato: PNG

O Bolt deve ocupar 80% da imagem, centralizado, com expressão 
super amigável e motivadora. Fundo azul escuro sólido sem gradientes.
```

**Use em**: ChatGPT (DALL-E 3), Leonardo.AI, Midjourney, Ideogram

**Salve como**: `assets/bolt/expressions/ready.png`

---

## 🗂️ ESTRUTURA DO PROJETO

```
boratreinar/
│
├─ assets/
│  └─ bolt/
│     ├─ expressions/     ⭐ COPIE ESTA PASTA
│     └─ leagues/         ⭐ COPIE ESTA PASTA
│
├─ lib/
│  ├─ screens/
│  │  └─ auth_screen.dart        (modificado)
│  ├─ widgets/
│  │  └─ bolt_widget.dart        (não modificado)
│  ├─ services/
│  ├─ models/
│  └─ theme/
│     └─ app_theme.dart          (tema #0D1B2A)
│
├─ web/
│  └─ manifest.json              (modificado)
│
├─ pubspec.yaml
├─ firebase.json
├─ .firebaserc
│
└─ 📚 Documentação/
   ├─ LEIA-ME-PRIMEIRO.md
   ├─ CHECKLIST.md
   ├─ COMANDOS-RAPIDOS.md
   ├─ prompt-ia-simples.txt
   └─ ... outros arquivos .md
```

---

## 🔐 CONFIGURAÇÕES FIREBASE

**Projeto**: gotreiinar  
**URL**: https://gotreiinar.web.app  
**Console**: https://console.firebase.google.com/project/gotreiinar

### Arquivo `.firebaserc`:
```json
{
  "projects": {
    "default": "gotreiinar"
  }
}
```

### Arquivo `firebase.json`:
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|js|css|eot|otf|ttf|ttc|woff|woff2|json)",
        "headers": [{"key": "Cache-Control", "value": "max-age=604800"}]
      },
      {
        "source": "manifest.json",
        "headers": [{"key": "Content-Type", "value": "application/manifest+json"}]
      }
    ]
  }
}
```

---

## 🐛 TROUBLESHOOTING NO NOVO PC

### Problema: "flutter: comando não encontrado"
```powershell
# Adicionar ao PATH
$env:Path += ";C:\flutter\bin"

# Permanente
.\adicionar_flutter_path.ps1

# Ou adicione manualmente em Variáveis de Ambiente
```

### Problema: Erro ao fazer build
```powershell
# Limpar tudo
flutter clean
Remove-Item -Recurse -Force build

# Reinstalar dependências
flutter pub get

# Build novamente
flutter build web --release
```

### Problema: Imagens não aparecem
1. Verifique se copiou as pastas:
   - `assets/bolt/expressions/`
   - `assets/bolt/leagues/`
2. Verifique se `ready.png` existe
3. Execute `flutter pub get`
4. Rebuild

### Problema: Firebase não logado
```powershell
firebase logout
firebase login
```

---

## 📊 CHECKLIST PARA NOVO PC

- [ ] Flutter instalado e no PATH
- [ ] Firebase CLI instalado
- [ ] Firebase login OK
- [ ] Projeto copiado/clonado
- [ ] **Imagens copiadas** (assets/bolt/expressions/ e leagues/)
- [ ] `flutter pub get` executado
- [ ] `flutter build web --release` OK
- [ ] `firebase deploy --only hosting` OK
- [ ] App funcionando em https://gotreiinar.web.app

---

## 📦 ARQUIVOS PARA LEVAR (Mínimo)

Se você quiser levar só o essencial via pendrive:

### Código (obrigatório):
- Toda a pasta `lib/`
- Toda a pasta `web/`
- `pubspec.yaml`
- `firebase.json`
- `.firebaserc`

### Imagens (obrigatório):
- `assets/bolt/expressions/` (7 PNGs) ⭐
- `assets/bolt/leagues/` (5 PNGs) ⭐

### Documentação (opcional mas recomendado):
- `LEIA-ME-PRIMEIRO.md`
- `COMANDOS-RAPIDOS.md`
- `prompt-ia-simples.txt`

**OU** copie a pasta inteira `boratreinar/` (mais fácil)

---

## 🚀 DEPLOY RÁPIDO NO NOVO PC

Depois de copiar tudo e instalar Flutter/Firebase:

```powershell
# 1. Navegar
cd D:\Projetos\boratreinar

# 2. Instalar dependências
flutter pub get

# 3. Build
flutter build web --release

# 4. Deploy
firebase deploy --only hosting

# 5. Abrir
start https://gotreiinar.web.app
```

Pronto! ✅

---

## 💾 BACKUP DAS IMAGENS

### Lista de Imagens Necessárias

#### assets/bolt/expressions/ (7 arquivos)
1. ready.png - ⭐ PRINCIPAL (tela de login)
2. happy.png
3. excited.png
4. fire.png
5. trophy.png
6. sleeping.png
7. cool.png

#### assets/bolt/leagues/ (5 arquivos)
1. bronze.png
2. silver.png
3. gold.png
4. diamond.png
5. legendary.png

**Total**: 12 imagens PNG (todas com fundo removido)

### Como Copiar

**Windows Explorer:**
1. Abra: `D:\Projetos\boratreinar\assets\bolt\`
2. Copie pastas `expressions` e `leagues` para pendrive
3. No novo PC, cole em: `D:\Projetos\boratreinar\assets\bolt\`

**PowerShell:**
```powershell
# Copiar para pendrive
Copy-Item -Recurse assets\bolt\expressions E:\backup\
Copy-Item -Recurse assets\bolt\leagues E:\backup\

# No novo PC, restaurar
Copy-Item -Recurse E:\backup\expressions assets\bolt\
Copy-Item -Recurse E:\backup\leagues assets\bolt\
```

---

## ✅ RESUMO FINAL

### O Que Está Funcionando:
- ✅ App com tema azul escuro (#0D1B2A)
- ✅ Tela de login com Bolt gigante
- ✅ PNG estático (simples e confiável)
- ✅ Sistema de gamificação completo
- ✅ Deploy no Firebase funcionando

### O Que Você Precisa No Outro PC:
1. ✅ Flutter instalado
2. ✅ Firebase CLI instalado
3. ✅ Código do projeto
4. ✅ **Imagens do Bolt** (12 PNGs)
5. ✅ Executar build e deploy

### Tempo Estimado Setup Novo PC:
- Instalar Flutter: 10-15 min
- Copiar projeto: 2-5 min
- Build e deploy: 5 min
- **Total**: ~20-25 minutos

---

## 📞 DÚVIDAS?

Consulte no novo PC:
- **LEIA-ME-PRIMEIRO.md** - início rápido
- **CHECKLIST.md** - lista de tarefas
- **COMANDOS-RAPIDOS.md** - comandos essenciais

**URL do App**: https://gotreiinar.web.app

Boa sorte no outro computador! 🚀
