# 🔧 Habilitar Developer Mode - Windows

## 🚨 Erro
```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

## ✅ Solução

### Opção 1 - Automático (acabei de abrir)

Acabei de abrir as configurações do Windows.

**Na janela que abriu:**
1. Ative o botão: **"Modo de Desenvolvedor"** (Developer Mode)
2. Confirme se aparecer aviso
3. Aguarde instalação (pode demorar 1-2 min)
4. Feche a janela

### Opção 2 - Manual

Se a janela não abriu:

1. Pressione: `Windows + I` (abre Configurações)
2. Vá em: **Privacidade e segurança** (ou **Update & Security**)
3. Clique em: **Para desenvolvedores** (ou **For developers**)
4. Ative: **Modo de desenvolvedor** (Developer Mode)
5. Confirme e aguarde instalação

### Opção 3 - Linha de Comando

Execute este comando no PowerShell como **Administrador**:

```powershell
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
```

## 🚀 Depois de Ativar

**Feche e reabra o PowerShell** e execute:

```powershell
flutter build web --release
```

Se der erro ainda, tente:

```powershell
flutter clean
flutter pub get
flutter build web --release
```

## ⏱️ Tempo Estimado

- Ativar Developer Mode: 1-2 minutos
- Build depois: 1-3 minutos

## 💡 O Que é Developer Mode?

- Permite criar symlinks (links simbólicos)
- Necessário para plugins do Flutter
- Seguro de ativar (é para desenvolvimento)
- Não afeta performance do sistema

## ✅ Verificar se Está Ativo

Execute:

```powershell
whoami /priv | findstr SeCreateSymbolicLinkPrivilege
```

Se retornar algo, está ativo! ✅

---

**Após ativar, volte e execute o build novamente!**
