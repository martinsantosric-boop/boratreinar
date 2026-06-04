# 🎬 Prompt Simples para Gerar Bolt Animado

## Para usar em IAs de geração de imagem/vídeo (Midjourney, DALL-E, Runway, etc.)

---

## 📋 PROMPT SIMPLIFICADO

```
Crie uma animação em loop do personagem Bolt (cachorro branco com raio laranja) em estilo cartoon 3D.

Especificações:
- Tamanho: 1200x1200 pixels (quadrado)
- Fundo: azul escuro sólido #0D1B2A
- Animação: Bolt sorrindo, piscando e fazendo gesto de positivo (3-5 segundos em loop)
- Estilo: cartoon 3D amigável, limpo, inspirado em mascotes de apps
- Formato: MP4 ou GIF
- Qualidade: alta definição, sem texto

O personagem deve ocupar 80% do espaço, centralizado, com o fundo completamente preenchido pela cor azul escuro.
```

---

## 🎨 VERSÃO ALTERNATIVA - IMAGEM ESTÁTICA

Se vídeo for complicado, use esta versão para gerar uma **imagem estática**:

```
Personagem Bolt: cachorro branco cartoon 3D sorridente com símbolo de raio laranja, fazendo gesto de positivo com a pata.

Especificações:
- Tamanho: 1200x1200 pixels
- Fundo: azul escuro sólido #0D1B2A
- Estilo: cartoon 3D amigável, mascote de app fitness
- Formato: PNG com fundo opaco azul escuro
- Iluminação: suave, personagem bem visível

Personagem centralizado ocupando 80% do frame.
```

---

## 📝 INSTRUÇÕES DE USO

### Opção 1: Usar Imagem PNG (MAIS SIMPLES)
1. Gere a imagem usando o prompt acima
2. Salve como `ready.png`
3. Substitua o arquivo em `assets/bolt/expressions/ready.png`
4. Pronto! A imagem já vai aparecer na tela de login

### Opção 2: Usar GIF Animado
1. Gere o GIF usando o prompt de animação
2. Salve como `bolt-animado.gif`
3. Coloque em `assets/bolt/expressions/`
4. Será necessário ajustar o código para usar GIF (mais complexo)

### Opção 3: Usar Vídeo MP4
1. Gere o vídeo usando o prompt de animação
2. **IMPORTANTE**: Certifique-se que o fundo é **SÓLIDO #0D1B2A**
3. Salve como `boratreinar.mp4`
4. Substitua o arquivo existente em `assets/bolt/expressions/`
5. O código já está preparado (mas atualmente desabilitado por simplicidade)

---

## 🚨 PROBLEMAS COMUNS

### Vídeo/GIF não aparece?
- **Solução mais simples**: Use imagem PNG estática
- PNG é mais confiável e carrega mais rápido
- Animação pode ser adicionada depois com CSS/Flutter animations

### Fundo transparente no vídeo?
- MP4 **NÃO suporta transparência**
- Por isso o prompt pede fundo **SÓLIDO azul escuro #0D1B2A**
- Se a IA gerar fundo transparente/branco, peça para refazer com fundo azul escuro

### Tamanho errado?
- Sempre especifique **1200x1200 pixels** no prompt
- Quadrado é melhor para evitar distorções
- Se necessário, redimensione depois usando ferramentas online

---

## ✅ RECOMENDAÇÃO FINAL

**Use imagem PNG estática por enquanto.** É mais simples, confiável e carrega instantaneamente. Você pode adicionar animações usando Flutter animations depois, sem precisar de vídeo.

Quando tiver uma boa imagem PNG do Bolt, simplesmente substitua `ready.png` e faça deploy!
