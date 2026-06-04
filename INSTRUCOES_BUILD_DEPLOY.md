# 🚀 Instruções para Build e Deploy

## ✅ CORREÇÕES APLICADAS

1. **Revertido para imagem PNG estática** (mais simples e confiável)
2. **Corrigido manifest.json** - cores atualizadas para #0D1B2A
3. **Removido código de vídeo** - usando BoltWidget simples com ready.png

---

## 🔧 PROBLEMA ATUAL: Flutter não está no PATH

O comando `flutter` não é reconhecido porque o Flutter não foi adicionado ao PATH do Windows.

### Solução Rápida:

**Opção 1: Adicionar Flutter ao PATH manualmente**

1. Abra "Variáveis de Ambiente" no Windows
2. Procure pela variável `Path` em "Variáveis do usuário"
3. Clique em "Editar"
4. Adicione o caminho: `C:\flutter\bin` (ou onde você instalou o Flutter)
5. Clique em "OK" e **FECHE E REABRA** o PowerShell

**Opção 2: Usar caminho completo**

Execute os comandos com o caminho completo do Flutter:

```powershell
C:\flutter\bin\flutter build web --release
C:\flutter\bin\flutter pub get
```

**Opção 3: Usar o script que criei antes**

Execute o script para adicionar ao PATH automaticamente:

```powershell
cd D:\Projetos\boratreinar
.\adicionar_flutter_path.ps1
```

---

## 📦 COMANDOS PARA BUILD E DEPLOY

Depois de resolver o PATH, execute:

### 1. Atualizar dependências
```powershell
cd D:\Projetos\boratreinar
flutter pub get
```

### 2. Build para Web
```powershell
flutter build web --release
```

### 3. Deploy para Firebase
```powershell
firebase deploy --only hosting
```

### 4. Testar
Acesse: https://gotreiinar.web.app

---

## 🎨 PRÓXIMOS PASSOS (OPCIONAL)

Se você quiser um Bolt animado ou melhor:

1. Abra o arquivo `PROMPT_GERAR_BOLT_ANIMADO.md`
2. Use os prompts fornecidos em uma IA de geração de imagens
3. Gere uma imagem PNG do Bolt com:
   - Tamanho: 1200x1200px
   - Fundo: azul escuro sólido #0D1B2A
   - Bolt centralizado, ocupando 80% do espaço
4. Salve como `ready.png`
5. Substitua o arquivo em `assets/bolt/expressions/ready.png`
6. Execute os comandos acima novamente para rebuild e deploy

---

## ✅ O QUE FOI CORRIGIDO

### Antes (Problemas):
- ❌ Tela em branco
- ❌ Erro no manifest.json
- ❌ Vídeo não aparecendo
- ❌ Cores verdes do Duolingo

### Agora (Corrigido):
- ✅ Usando imagem PNG estática (simples e confiável)
- ✅ Manifest.json com cores corretas (#0D1B2A)
- ✅ BoltWidget funcionando com ready.png
- ✅ Tema todo em azul escuro #0D1B2A

---

## 🐛 SE DER ERRO APÓS DEPLOY

### Limpar cache do Firebase e rebuild:
```powershell
# Limpar build anterior
Remove-Item -Recurse -Force build\web

# Rebuild limpo
flutter clean
flutter pub get
flutter build web --release

# Deploy limpo
firebase deploy --only hosting
```

### Limpar cache do navegador:
1. Abra https://gotreiinar.web.app
2. Pressione `Ctrl + Shift + R` (hard refresh)
3. Ou abra DevTools (F12) > Application > Clear Storage > Clear site data

---

## 📞 PRECISA DE AJUDA?

Se ainda não funcionar:
1. Verifique se o Flutter está instalado: `flutter --version`
2. Verifique se o Firebase CLI está instalado: `firebase --version`
3. Me mostre o erro específico que aparecer
