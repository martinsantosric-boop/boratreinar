# ⚡ Comandos Rápidos - Bora Treinar

## 🚀 Build e Deploy (use sempre estes)

```powershell
# Ir para pasta do projeto
cd D:\Projetos\boratreinar

# Build limpo (recomendado)
flutter clean
flutter pub get
flutter build web --release

# Deploy
firebase deploy --only hosting
```

## 🔧 Adicionar Flutter ao PATH (primeira vez)

```powershell
.\adicionar_flutter_path.ps1
# Depois: feche e reabra o PowerShell
```

## 🧪 Testar localmente (antes de deploy)

```powershell
flutter run -d chrome
```

## 🐛 Resolver problemas

```powershell
# Build não funciona? Limpe tudo:
flutter clean
Remove-Item -Recurse -Force build\web

# Dependências desatualizadas? Atualize:
flutter pub get

# Ver logs detalhados:
flutter build web --release --verbose
```

## 🎨 Trocar imagem do Bolt

```powershell
# 1. Gere nova imagem com IA (use prompt-ia-simples.txt)
# 2. Salve como: assets\bolt\expressions\ready.png
# 3. Rebuild:
flutter build web --release
firebase deploy --only hosting
```

## ✅ Verificar se está tudo OK

```powershell
# Flutter instalado?
flutter --version

# Firebase instalado?
firebase --version

# Python instalado? (para processar imagens)
py --version
```

## 📦 Processar novas imagens do Bolt

```powershell
# Coloque imagens em: assets\bolt\fotos-boratreinar\
# Execute:
py remove_background.py
```

## 🌐 URLs Úteis

- **App publicado**: https://gotreiinar.web.app
- **Firebase Console**: https://console.firebase.google.com/project/gotreiinar
- **Documentação Flutter**: https://flutter.dev/docs

## 💾 Backup antes de mudanças grandes

```powershell
# Git commit
git add .
git commit -m "Backup antes de mudanças"
git push
```

## 🎯 Ordem recomendada de comandos

```powershell
# 1. Navegar para projeto
cd D:\Projetos\boratreinar

# 2. Limpar build anterior
flutter clean

# 3. Atualizar dependências
flutter pub get

# 4. Build para produção
flutter build web --release

# 5. Deploy
firebase deploy --only hosting

# 6. Testar (limpe cache do navegador: Ctrl+Shift+R)
# https://gotreiinar.web.app
```

---

**Dica**: Salve este arquivo nos favoritos para referência rápida! 📌
