# 📱 Gerar APK Android - Bora Treinar

## 🎯 Objetivo

Criar APK para instalar e testar no celular Android.

---

## ✅ Pré-requisitos no Outro PC

### 1. Android Studio Instalado

**Verificar:**
```powershell
flutter doctor
```

**Deve mostrar:**
```
[√] Android toolchain - develop for Android devices
```

**Se NÃO estiver instalado:**
1. Baixe: https://developer.android.com/studio
2. Instale o Android Studio
3. Abra e instale Android SDK (aceite tudo)
4. Instale Android SDK Command-line Tools
5. Execute: `flutter doctor --android-licenses` (aceite tudo)

### 2. Projeto Atualizado

```powershell
cd D:\Projetos\boratreinar
git pull origin main
flutter pub get
```

---

## 🚀 Gerar APK (3 Comandos)

### Opção 1: APK Release (Recomendado)

```powershell
cd D:\Projetos\boratreinar
flutter build apk --release
```

**Resultado**: 
- Arquivo: `build\app\outputs\flutter-apk\app-release.apk`
- Tamanho: ~50-80 MB
- Otimizado para produção
- Pronto para instalar

### Opção 2: APK Split (Menor)

```powershell
flutter build apk --split-per-abi --release
```

**Resultado**: 
- 3 APKs (um para cada arquitetura)
- `app-armeabi-v7a-release.apk` (~30MB) - Android 32-bit
- `app-arm64-v8a-release.apk` (~30MB) - Android 64-bit moderno
- `app-x86_64-release.apk` (~30MB) - Emuladores

**Use**: `app-arm64-v8a-release.apk` (maioria dos celulares modernos)

### Opção 3: APK Debug (Mais Rápido)

```powershell
flutter build apk --debug
```

**Resultado**:
- Arquivo: `build\app\outputs\flutter-apk\app-debug.apk`
- Mais rápido de compilar
- Tamanho maior (~80-120 MB)
- Para testes apenas

---

## 📲 Instalar no Celular

### Método 1: Cabo USB (Mais Rápido)

1. **Ativar modo desenvolvedor no celular:**
   - Configurações > Sobre o telefone
   - Toque 7x em "Número da versão"
   - Voltar > Opções do desenvolvedor
   - Ativar "Depuração USB"

2. **Conectar cabo USB**

3. **Verificar conexão:**
```powershell
flutter devices
```

Deve mostrar seu celular listado.

4. **Instalar direto:**
```powershell
flutter install
```

OU copiar APK manualmente:
```powershell
# Copiar para área de transferência
Copy-Item build\app\outputs\flutter-apk\app-release.apk ~\Desktop\
```

### Método 2: Sem Cabo (Wi-Fi/Cloud)

1. **Copiar APK para pendrive/OneDrive/Google Drive**

2. **No celular:**
   - Abra o arquivo APK
   - Permitir "Instalar de fontes desconhecidas"
   - Instalar

---

## 🔧 Configurações do App (Opcional)

### Mudar Nome do App

**Arquivo**: `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="Bora Treinar"
    ...
```

### Mudar Ícone do App

**Pasta**: `android/app/src/main/res/`

Substitua ícones em:
- `mipmap-hdpi/ic_launcher.png`
- `mipmap-mdpi/ic_launcher.png`
- `mipmap-xhdpi/ic_launcher.png`
- `mipmap-xxhdpi/ic_launcher.png`
- `mipmap-xxxhdpi/ic_launcher.png`

**OU use ferramenta:**
```powershell
flutter pub add flutter_launcher_icons
```

### Mudar ID do Pacote

**Arquivo**: `android/app/build.gradle`

```gradle
defaultConfig {
    applicationId "com.boratreinar.app"
    ...
}
```

---

## 📊 Tamanhos Esperados

| Tipo | Tamanho | Uso |
|------|---------|-----|
| **APK Release** | ~50-80 MB | Produção |
| **APK Split ARM64** | ~30 MB | Produção (melhor) |
| **APK Debug** | ~80-120 MB | Testes apenas |

---

## 🐛 Troubleshooting

### Erro: "Android SDK not found"

```powershell
flutter config --android-sdk "C:\Users\SeuUsuario\AppData\Local\Android\Sdk"
```

### Erro: "License not accepted"

```powershell
flutter doctor --android-licenses
# Aceite todos (digite 'y')
```

### Erro: "Gradle build failed"

```powershell
cd android
.\gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Build muito lento

**Normal na primeira vez!**
- Primeira build: 10-20 minutos
- Próximas builds: 2-5 minutos

**Para acelerar:**
```powershell
# Use mais memória
$env:GRADLE_OPTS="-Xmx4096m"
flutter build apk --release
```

---

## 📋 Checklist

Antes de gerar APK:

- [ ] Android Studio instalado
- [ ] `flutter doctor` sem erros de Android
- [ ] Projeto atualizado (`git pull`)
- [ ] Dependências instaladas (`flutter pub get`)

Gerar APK:

- [ ] `flutter build apk --release` executado
- [ ] APK gerado em `build\app\outputs\flutter-apk\`
- [ ] Arquivo tem ~50-80 MB

Testar:

- [ ] APK copiado para celular
- [ ] App instalado com sucesso
- [ ] App abre sem crash
- [ ] Login funciona
- [ ] GPS funciona (permissões concedidas)
- [ ] Corrida pode ser iniciada

---

## 🎯 Comandos Resumidos

```powershell
# 1. Atualizar projeto
cd D:\Projetos\boratreinar
git pull origin main
flutter pub get

# 2. Gerar APK
flutter build apk --release

# 3. APK está em:
# build\app\outputs\flutter-apk\app-release.apk

# 4. Copiar para Desktop
Copy-Item build\app\outputs\flutter-apk\app-release.apk ~\Desktop\

# 5. Enviar para celular (USB, email, cloud, etc)
```

---

## 📱 Permissões Necessárias

O app vai pedir no celular:

- ✅ **Localização** - Para rastrear corrida via GPS
- ✅ **Atividade física** - Para contar passos
- ✅ **Notificações** - Para lembretes (opcional)

**Permita todas** para funcionamento completo!

---

## 🔐 Assinar APK (Produção)

Para publicar na Play Store, precisa assinar:

```powershell
# Criar keystore (primeira vez apenas)
keytool -genkey -v -keystore boratreinar-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias boratreinar

# Configurar em android/key.properties
# Depois build com:
flutter build appbundle --release
```

**Mas para testar, APK normal funciona!**

---

## 🎉 Resultado Esperado

Após instalar no celular:

✅ App abre normalmente  
✅ Tela de login aparece com Bolt  
✅ Login com Google funciona  
✅ GPS solicita permissão  
✅ Pode iniciar corrida  
✅ Timer, distância e passos funcionam  
✅ Pode finalizar e salvar corrida  
✅ Histórico salva corridas  

---

**Pronto para gerar APK no outro PC!** 📱🚀

**Lembre-se**: Animação do mascote está desativada temporariamente.
