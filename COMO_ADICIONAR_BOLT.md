# 🎨 Como Adicionar Imagens do Bolt

## 📁 Estrutura de Pastas

```
assets/bolt/
├── expressions/          # 7 expressões
│   ├── ready.png        ⭐ PRINCIPAL (use esta primeiro!)
│   ├── happy.png
│   ├── cool.png
│   ├── excited.png
│   ├── fire.png
│   ├── trophy.png
│   └── sleeping.png
└── leagues/             # 5 ligas (opcional)
    ├── bronze.png
    ├── silver.png
    ├── gold.png
    ├── diamond.png
    └── legendary.png
```

## 🚀 INÍCIO RÁPIDO - Use 1 Imagem Só!

**Você só precisa de 1 imagem para começar:**

1. Recorte o Bolt de `personagem.png`
2. Salve como: `d:\Projetos\boratreinar\assets\bolt\expressions\ready.png`
3. Execute:
```bash
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

**Pronto! O Bolt vai aparecer em todas as telas! ⚡**

---

## 📸 Como Recortar a Imagem

### Opção 1: Paint / Paint 3D (Windows)

1. Abra `personagem.png` no Paint
2. Use a ferramenta **Selecionar → Seleção de forma livre**
3. Contorne o Bolt
4. **Ctrl + X** (recortar)
5. **Ctrl + N** (nova imagem)
6. **Ctrl + V** (colar)
7. Salvar como PNG em: `assets\bolt\expressions\ready.png`

### Opção 2: Online - Remove.bg

1. Acesse: https://www.remove.bg/
2. Upload de `personagem.png`
3. Remove background automaticamente
4. Download e salve como `ready.png`

### Opção 3: Photoshop / GIMP

1. Abra `personagem.png`
2. Use ferramenta de seleção mágica/lasso
3. Recorte o Bolt
4. Export como PNG com transparência

---

## 📏 Especificações Recomendadas

### Tamanho:
- **512x512 px** (ideal)
- ou **1024x1024 px** (alta qualidade)
- Mínimo: 256x256 px

### Formato:
- **PNG com fundo transparente**
- Qualidade: Alta
- Sem compression

### Margens:
- Deixe ~10% de margem ao redor do personagem
- Centralize o Bolt na imagem

---

## 🎯 Prioridade de Imagens

### Fase 1 - Essencial (1 imagem)
```
✅ ready.png  → Bolt padrão, aparece em TUDO
```

### Fase 2 - Melhorias (mais 6 imagens)
```
⭐ happy.png    → Após completar corrida
⭐ excited.png  → Conquistas desbloqueadas
⭐ fire.png     → Streak de 7+ dias
⭐ trophy.png   → Subiu de liga
   cool.png     → Quando bater meta
   sleeping.png → Usuário inativo
```

### Fase 3 - Ligas (5 imagens - opcional)
```
   bronze.png
   silver.png
   gold.png
   diamond.png
   legendary.png
```

---

## ✅ Checklist

### Antes de adicionar:
- [ ] Imagem recortada (fundo transparente)
- [ ] Tamanho: 512x512 ou maior
- [ ] Formato: PNG
- [ ] Nome correto: `ready.png`, `happy.png`, etc.

### Adicionar a imagem:
- [ ] Salvar em `assets/bolt/expressions/`
- [ ] Nome EXATO (sem espaços, lowercase)

### Testar:
```bash
cd d:\Projetos\boratreinar
flutter pub get
flutter run -d chrome
```

### Deploy:
```bash
flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

---

## 🔧 Problemas Comuns

### Imagem não aparece?

**1. Verifique o caminho:**
```
d:\Projetos\boratreinar\assets\bolt\expressions\ready.png
```
Path COMPLETO deve existir!

**2. Nome EXATO:**
- ✅ `ready.png` 
- ❌ `Ready.png`
- ❌ `ready.PNG`
- ❌ `ready (1).png`

**3. Execute novamente:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

### Imagem aparece cortada?

Adicione margem ao redor do Bolt antes de salvar.

### Imagem com qualidade ruim?

Use tamanho maior (1024x1024) e PNG sem compression.

---

## 🎨 Criando Variações (Opcional)

Se quiser criar expressões diferentes do mesmo Bolt:

### Ferramentas de Edição:
1. **Photoshop** - Profissional
2. **GIMP** - Grátis, completo
3. **Photopea** - Online, grátis (https://photopea.com)
4. **Canva** - Simples, online

### O que mudar:
- **happy.png**: Boca maior, olhos mais abertos
- **cool.png**: Adicione óculos escuros
- **excited.png**: Braços pra cima, sparkles ao redor
- **fire.png**: Efeito de fogo ao redor
- **trophy.png**: Bolt segurando troféu
- **sleeping.png**: Olhos fechados, "zzz"

---

## 🚀 Deploy Rápido (Após Adicionar Imagens)

```bash
cd d:\Projetos\boratreinar; flutter clean; flutter pub get; flutter build web --release; firebase deploy --only hosting
```

**E pronto! Bolt atualizado no ar! ⚡**

---

## 💡 Dica Pro

Comece com **apenas `ready.png`**!

Depois, aos poucos, adicione as outras expressões.

O app funciona perfeitamente com 1 imagem só! 🎯
