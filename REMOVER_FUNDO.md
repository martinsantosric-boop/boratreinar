# 🎨 Como Remover Fundo das Imagens do Bolt

## 🚀 OPÇÃO 1: Automático com Python (Recomendado)

### 1. Instalar Python (se não tiver)
Baixe: https://www.python.org/downloads/

### 2. Instalar bibliotecas
```bash
pip install rembg pillow
```

### 3. Executar script
```bash
cd d:\Projetos\boratreinar
python remove_background.py
```

**Pronto! Todas as imagens processadas automaticamente! ✅**

---

## 🌐 OPÇÃO 2: Online - Remove.bg (Fácil)

### Site: https://www.remove.bg/

1. Acesse o site
2. Upload de cada imagem
3. Download (grátis até 50 imagens/mês em baixa resolução)
4. Para HD, assine o plano

### Imagens para processar:

**Expressões (7 imagens):**
```
assets/bolt/fotos-boratreinar/ready.png              → ready.png
assets/bolt/fotos-boratreinar/Expressões/feliz.png   → happy.png
assets/bolt/fotos-boratreinar/Expressões/animado.png → excited.png
assets/bolt/fotos-boratreinar/Expressões/Conquista.png → trophy.png
assets/bolt/fotos-boratreinar/Expressões/cansado.png → sleeping.png
assets/bolt/fotos-boratreinar/Expressões/pensando.png → cool.png
assets/bolt/fotos-boratreinar/ações/comemorando.png  → fire.png
```

**Ligas (5 imagens):**
```
assets/bolt/fotos-boratreinar/evolucao/bronze.png    → bronze.png
assets/bolt/fotos-boratreinar/evolucao/prata.png     → silver.png
assets/bolt/fotos-boratreinar/evolucao/ouro.png      → gold.png
assets/bolt/fotos-boratreinar/evolucao/Diamante.png  → diamond.png
assets/bolt/fotos-boratreinar/evolucao/lendario.png  → legendary.png
```

### Onde salvar após remover fundo:

**Expressões:**
```
d:\Projetos\boratreinar\assets\bolt\expressions\
```

**Ligas:**
```
d:\Projetos\boratreinar\assets\bolt\leagues\
```

---

## 🖥️ OPÇÃO 3: PhotoScissors (Online)

Site: https://photoscissors.com/

1. Upload da imagem
2. Remove fundo automaticamente (IA)
3. Download gratuito

---

## 🎨 OPÇÃO 4: Paint 3D (Windows)

1. Abrir imagem no Paint 3D
2. **Magic select** (seleção mágica)
3. Contornar o Bolt
4. **Next**
5. Ajustar seleção
6. **Done**
7. **Ctrl + X** (recortar)
8. **Canvas** → Transparent canvas
9. **Ctrl + V** (colar)
10. **Salvar como PNG**

---

## 📝 Checklist Após Remover Fundo

### Arquivos Finais Esperados:

**Expressões (pasta: assets/bolt/expressions/):**
- [ ] ready.png
- [ ] happy.png
- [ ] cool.png
- [ ] excited.png
- [ ] fire.png
- [ ] trophy.png
- [ ] sleeping.png

**Ligas (pasta: assets/bolt/leagues/):**
- [ ] bronze.png
- [ ] silver.png
- [ ] gold.png
- [ ] diamond.png
- [ ] legendary.png

### Verificar:
- [ ] Todas as imagens são PNG
- [ ] Todas têm fundo transparente
- [ ] Nomes em lowercase (ready.png, não Ready.png)
- [ ] Tamanho adequado (512x512 ou maior)

---

## 🚀 Deploy Após Adicionar

```bash
cd d:\Projetos\boratreinar
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

---

## 🔧 Script Manual (PowerShell)

Se quiser copiar manualmente os arquivos com os nomes corretos:

```powershell
# Criar pastas
New-Item -ItemType Directory -Force -Path "assets\bolt\expressions"
New-Item -ItemType Directory -Force -Path "assets\bolt\leagues"

# Copiar expressões (após remover fundo)
Copy-Item "assets\bolt\fotos-boratreinar\ready.png" "assets\bolt\expressions\ready.png"
Copy-Item "assets\bolt\fotos-boratreinar\Expressões\feliz.png" "assets\bolt\expressions\happy.png"
Copy-Item "assets\bolt\fotos-boratreinar\Expressões\animado.png" "assets\bolt\expressions\excited.png"
Copy-Item "assets\bolt\fotos-boratreinar\Expressões\Conquista.png" "assets\bolt\expressions\trophy.png"
Copy-Item "assets\bolt\fotos-boratreinar\Expressões\cansado.png" "assets\bolt\expressions\sleeping.png"
Copy-Item "assets\bolt\fotos-boratreinar\Expressões\pensando.png" "assets\bolt\expressions\cool.png"
Copy-Item "assets\bolt\fotos-boratreinar\ações\comemorando.png" "assets\bolt\expressions\fire.png"

# Copiar ligas (após remover fundo)
Copy-Item "assets\bolt\fotos-boratreinar\evolucao\bronze.png" "assets\bolt\leagues\bronze.png"
Copy-Item "assets\bolt\fotos-boratreinar\evolucao\prata.png" "assets\bolt\leagues\silver.png"
Copy-Item "assets\bolt\fotos-boratreinar\evolucao\ouro.png" "assets\bolt\leagues\gold.png"
Copy-Item "assets\bolt\fotos-boratreinar\evolucao\Diamante.png" "assets\bolt\leagues\diamond.png"
Copy-Item "assets\bolt\fotos-boratreinar\evolucao\lendario.png" "assets\bolt\leagues\legendary.png"
```

---

## 💡 Dica Rápida

**Comece com APENAS 1 imagem:**

1. Pegue `ready.png`
2. Remova o fundo
3. Salve em `assets/bolt/expressions/ready.png`
4. Deploy!

**O app já vai ficar MUITO melhor com essa 1 imagem!** ⚡

Depois você processa as outras 11 imagens.

---

## 🎯 Mapeamento Completo

| Imagem Original | Nova Imagem | Onde Usa |
|----------------|-------------|----------|
| ready.png | expressions/ready.png | Tela inicial, padrão |
| feliz.png | expressions/happy.png | Após corrida |
| animado.png | expressions/excited.png | Conquista desbloqueada |
| Conquista.png | expressions/trophy.png | Subiu de liga |
| cansado.png | expressions/sleeping.png | Inativo |
| pensando.png | expressions/cool.png | Meta batida |
| comemorando.png | expressions/fire.png | Streak 7+ dias |
| bronze.png | leagues/bronze.png | Liga Bronze |
| prata.png | leagues/silver.png | Liga Prata |
| ouro.png | leagues/gold.png | Liga Ouro |
| Diamante.png | leagues/diamond.png | Liga Diamante |
| lendario.png | leagues/legendary.png | Liga Lendária |

---

**Escolha a opção que preferir e bora remover esses fundos! 🎨**
