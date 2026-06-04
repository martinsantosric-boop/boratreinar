# ✅ Checklist - Bora Treinar

## 🎯 O QUE FAZER AGORA

Siga esta lista na ordem. Marque cada item quando concluir.

---

## FASE 1: Setup (5 minutos)

### [ ] 1.1 Adicionar Flutter ao PATH

**Opção A - Automático (Recomendado)**:
```powershell
cd D:\Projetos\boratreinar
.\adicionar_flutter_path.ps1
```

**Opção B - Manual**:
1. Abrir "Variáveis de Ambiente" no Windows
2. Editar variável "Path"
3. Adicionar: `C:\flutter\bin`
4. Salvar

### [ ] 1.2 Fechar e reabrir PowerShell
⚠️ **IMPORTANTE**: O PATH só atualiza após reiniciar o terminal!

### [ ] 1.3 Verificar que Flutter funciona
```powershell
flutter --version
```

**Esperado**: Deve mostrar a versão do Flutter (3.44.1 ou similar)

---

## FASE 2: Build e Deploy (10 minutos)

### [ ] 2.1 Navegar para o projeto
```powershell
cd D:\Projetos\boratreinar
```

### [ ] 2.2 Limpar build anterior (opcional mas recomendado)
```powershell
flutter clean
```

### [ ] 2.3 Atualizar dependências
```powershell
flutter pub get
```

**Esperado**: Mensagem "Got dependencies!"

### [ ] 2.4 Build para produção
```powershell
flutter build web --release
```

**Esperado**: 
- Processo de compilação (pode demorar 1-2 minutos)
- Mensagem "✓ Built build/web"

### [ ] 2.5 Deploy para Firebase
```powershell
firebase deploy --only hosting
```

**Esperado**: 
- Mensagem "+ Deploy complete!"
- URL: https://gotreiinar.web.app

---

## FASE 3: Teste (2 minutos)

### [ ] 3.1 Abrir app no navegador
```
https://gotreiinar.web.app
```

### [ ] 3.2 Limpar cache do navegador
Pressione: `Ctrl + Shift + R`

### [ ] 3.3 Verificar que o Bolt aparece
- [ ] Personagem Bolt visível no topo
- [ ] Tamanho grande (250px)
- [ ] Cores azul escuro (#0D1B2A)

### [ ] 3.4 Verificar funcionalidade
- [ ] Título "⚡ Bora Treinar" aparece
- [ ] Slogan "Um passo de cada vez" aparece
- [ ] Card branco inferior aparece
- [ ] Botão "Entrar com Google" aparece
- [ ] Botão responde ao clique

---

## FASE 4: Melhorias Opcionais (30 minutos)

### [ ] 4.1 Gerar Bolt melhor com IA (opcional)

1. [ ] Abrir arquivo `prompt-ia-simples.txt`
2. [ ] Copiar o prompt
3. [ ] Usar em IA geradora de imagens:
   - [ ] ChatGPT com DALL-E 3, OU
   - [ ] Leonardo.AI (gratuito), OU
   - [ ] Midjourney, OU
   - [ ] Ideogram

4. [ ] Baixar imagem gerada
5. [ ] Salvar como: `assets\bolt\expressions\ready.png`
6. [ ] Rebuild: `flutter build web --release`
7. [ ] Redeploy: `firebase deploy --only hosting`
8. [ ] Testar novamente

### [ ] 4.2 Limpar arquivos não usados (opcional)

```powershell
# Deletar vídeo não usado
Remove-Item assets\bolt\expressions\boratreinar.mp4

# Deletar widget não usado
Remove-Item lib\widgets\bolt_video_widget.dart
```

### [ ] 4.3 Remover dependência video_player (opcional)

1. [ ] Abrir `pubspec.yaml`
2. [ ] Comentar ou deletar linha: `video_player: ^2.8.0`
3. [ ] Executar: `flutter pub get`
4. [ ] Rebuild e redeploy

---

## FASE 5: Verificação Final

### [ ] 5.1 App funcionando em produção
- [ ] URL acessível: https://gotreiinar.web.app
- [ ] Tela carregando completamente
- [ ] Sem erros no console (F12 > Console)
- [ ] Bolt aparecendo corretamente

### [ ] 5.2 Cores corretas
- [ ] Fundo do topo: azul escuro (#0D1B2A)
- [ ] Card inferior: branco
- [ ] Sem verde (#58CC02) em lugar nenhum

### [ ] 5.3 Performance
- [ ] Carregamento rápido (< 3 segundos)
- [ ] Sem lentidão
- [ ] Imagens carregando instantaneamente

---

## 🐛 TROUBLESHOOTING

Se algo não funcionar, marque o problema e siga a solução:

### [ ] Problema: "flutter: comando não encontrado"
**Solução**: 
- Execute `.\adicionar_flutter_path.ps1`
- Feche e reabra o PowerShell
- Se ainda não funcionar, adicione manualmente ao PATH

### [ ] Problema: Tela ainda em branco
**Solução**:
- Limpe cache do navegador: `Ctrl + Shift + R`
- Ou abra em aba anônima
- Ou tente outro navegador

### [ ] Problema: Erro no build
**Solução**:
```powershell
flutter clean
flutter pub get
flutter build web --release --verbose
```

### [ ] Problema: Bolt não aparece
**Solução**:
- Verifique se arquivo existe: `assets\bolt\expressions\ready.png`
- Se não existir, gere um com IA usando `prompt-ia-simples.txt`

### [ ] Problema: Cores erradas
**Solução**:
- Verifique `web/manifest.json` tem `#0D1B2A`
- Rebuild e redeploy
- Limpe cache do navegador

---

## 📊 PROGRESSO GERAL

**Marque quando concluir cada fase:**

- [ ] **FASE 1**: Setup (Flutter no PATH)
- [ ] **FASE 2**: Build e Deploy
- [ ] **FASE 3**: Teste
- [ ] **FASE 4**: Melhorias Opcionais
- [ ] **FASE 5**: Verificação Final

---

## 🎉 CONCLUSÃO

Quando todos os checkboxes estiverem marcados:

✅ Seu app **Bora Treinar** está no ar!  
✅ Bolt aparecendo perfeitamente  
✅ Sistema de gamificação funcionando  
✅ Pronto para usar e mostrar!  

---

## 📚 DOCUMENTAÇÃO DE REFERÊNCIA

Durante o processo, consulte:

- **Setup**: `LEIA-ME-PRIMEIRO.md`
- **Comandos**: `COMANDOS-RAPIDOS.md`
- **Problemas**: `INSTRUCOES_BUILD_DEPLOY.md`
- **Gerar Bolt**: `prompt-ia-simples.txt`
- **Entender mudanças**: `ANTES-E-DEPOIS.md`

---

## 💡 DICA FINAL

Imprima ou salve este checklist para seguir passo a passo. Não pule etapas!

**Tempo estimado total**: 15-20 minutos (sem melhorias opcionais)

---

**Boa sorte! 🚀**
