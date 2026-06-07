# 🎬 Prompts para Animações do Bolt (9:16 Vertical)

**Formato:** 1080 x 1920 pixels (9:16 vertical)  
**Background:** #0D1B2A (azul escuro sólido)  
**FPS:** 30  
**Método:** Upload da imagem do Bolt + prompt de movimento

---

## 📤 Como Usar

1. **Faça upload da imagem do Bolt** (a que você tem com fundo transparente)
2. **Cole o prompt** de movimento abaixo
3. **Configure:** 9:16 (1080x1920), 30fps
4. **Gere o vídeo!**

---

## 1. 💫 Ganhar XP (1.8 segundos)

**FORMATO: 9:16 vertical (1080x1920)**

O personagem vibra com energia, partículas douradas brilhantes sobem ao redor dele, seu corpo pulsa com luz amarela, expressão de empolgação crescente, pequenos raios elétricos aparecem brevemente. Fundo azul escuro sólido #0D1B2A. Movimento de celebração energética e rápida. 30fps.

---

## 2. ⭐ Missão Concluída (2.5 segundos)

**FORMATO: 9:16 vertical (1080x1920)**

O personagem levanta os braços em V de vitória, dá um pulo de alegria, confetes dourados e coloridos caem de cima, seu rosto mostra sorriso radiante, pequenos brilhos aparecem ao redor. Fundo azul escuro sólido #0D1B2A. Celebração alegre e positiva. 30fps.

---

## 3. 🏆 Ganhar Troféu (3.5 segundos)

**FORMATO: 9:16 vertical (1080x1920)**

O personagem levanta um troféu dourado brilhante acima da cabeça com as duas mãos, explosão de partículas douradas ao redor, raios de luz amarelos circulam, pose heroica e triunfante, aura dourada pulsa do corpo. Fundo azul escuro sólido #0D1B2A. Celebração épica e gloriosa. O troféu deve ser proporcional ao tamanho do personagem (não gigante). 30fps.

---

## 4. ✅ Check Animado (1.2 segundos)

**FORMATO: 9:16 vertical (1080x1920)**

O personagem pisca um olho e levanta o polegar (thumbs up), flash verde suave ilumina a cena rapidamente, pequenas partículas verdes aparecem ao redor do gesto, expressão confiante e aprovadora. Fundo azul escuro sólido #0D1B2A. Movimento rápido e assertivo. 30fps.

---

## 5. 🔄 Loop Idle (2.5 segundos - LOOP)

**FORMATO: 9:16 vertical (1080x1920)**

O personagem respira suavemente (corpo sobe e desce levemente), levita sutilmente para cima e para baixo, pequena energia amarela pulsa ao redor dele de forma sutil, expressão serena e atenta, movimento cíclico perfeito que pode repetir infinitamente. Fundo azul escuro sólido #0D1B2A. Loop contínuo suave. 30fps.

---

## 📋 Especificações Técnicas

### Para Runway ML:
```
- Upload: Imagem do Bolt (PNG com fundo transparente ou JPG)
- Aspect Ratio: 9:16
- Resolution: 1080x1920
- Duration: [conforme cada animação]
- Frame Rate: 30 FPS
- Background: Adicionar camada azul #0D1B2A antes de exportar
```

### Para Pika Labs:
```
- Upload da imagem do Bolt
- Adicionar ao final do prompt: "--ar 9:16 --fps 30"
- Background: #0D1B2A
```

### Para Leonardo.ai Motion:
```
- Upload: Imagem do Bolt
- Dimensions: 1080 x 1920 (Portrait)
- Motion Strength: Medium-High
- Background: Solid color #0D1B2A
```

---

## 🎨 Configuração de Background

### Se a IA não aceitar fundo colorido:

**Opção 1:** Adicionar depois no editor
- Gere o vídeo com fundo transparente/preto
- Use editor de vídeo (CapCut, DaVinci) para adicionar camada azul #0D1B2A

**Opção 2:** Adicionar no prompt
```
"...solid dark blue background color #0D1B2A, no patterns, no gradients..."
```

---

## 📊 Tabela Resumida

| Animação | Duração | Movimento Principal | Efeitos |
|----------|---------|---------------------|---------|
| Ganhar XP | 1.8s | Vibração energética | Partículas douradas subindo |
| Missão Concluída | 2.5s | Braços em V + pulo | Confetes caindo |
| Ganhar Troféu | 3.5s | Levanta troféu | Explosão dourada + raios |
| Check Animado | 1.2s | Pisca + thumbs up | Flash verde |
| Idle Loop | 2.5s | Respiração + levitação | Pulso amarelo sutil |

---

## ✅ Checklist de Geração

Para cada vídeo:

- [ ] Upload da imagem do Bolt
- [ ] Configurado 9:16 (1080x1920)
- [ ] 30 FPS selecionado
- [ ] Prompt colado corretamente
- [ ] Fundo #0D1B2A configurado
- [ ] Duração correta definida
- [ ] Vídeo gerado
- [ ] Download concluído
- [ ] Verificado no player (sem distorções)

---

## 🎯 Resultado Esperado

**Dimensões:** 1080 x 1920 pixels  
**Formato:** Vertical (9:16)  
**Background:** Azul escuro (#0D1B2A)  
**Visual:** Bolt se movendo, mantendo seu design original  
**Sem barras pretas:** Preenche toda a tela do celular  

---

## 💡 Dicas Importantes

1. **Troféu na animação 3:** Deve ser proporcional, não gigante
2. **Loop do idle:** Início e fim devem ser idênticos para repetir suavemente
3. **Qualidade:** Exportar em máxima qualidade (sem compressão excessiva)
4. **Tamanho arquivo:** Cada vídeo deve ficar entre 500KB - 2MB

---

## 🔄 Após Gerar Todos os 5 Vídeos

1. Salvar com os nomes corretos:
   - `ganhar_xp.mp4`
   - `missao_concluida.mp4`
   - `ganhar_trofeu.mp4`
   - `check_animado.mp4`
   - `idle_loop.mp4`

2. Substituir em: `assets/bolt/expressions/`

3. Verificar dimensões:
   ```bash
   # Windows (PowerShell com FFmpeg)
   ffprobe ganhar_xp.mp4
   # Deve mostrar: 1080x1920
   ```

4. Build APK:
   ```bash
   flutter build apk --release
   ```

5. Testar no celular - deve preencher toda a tela! 📱✨

---

**Tamanho correto:** **1080 x 1920 pixels (9:16 vertical)**  
**Método:** Upload imagem do Bolt + prompt de movimento  
**Background:** #0D1B2A (azul escuro sólido)
