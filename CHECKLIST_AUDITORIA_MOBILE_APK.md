# Checklist Auditoria Mobile/APK - GoTreiinar

Este checklist acompanha as orientacoes da auditoria mobile/APK e deve ser atualizado a cada rodada de melhoria.

## Prioridade Alta

### Corrida ativa

- [x] Botao grande e destacado "Iniciar corrida" visivel na primeira dobra mobile.
- [x] Status visivel de GPS/permissao antes de iniciar.
- [x] Mensagem clara quando o GPS esta buscando, pronto ou com erro.
- [x] Aviso quando a localizacao nao esta autorizada ou o GPS esta desligado.
- [x] Estado visual diferente antes, durante e pausado.
- [x] Acoes claras depois de iniciar: pausar, retomar, finalizar e salvar.
- [x] Mascote orientando o usuario antes da primeira acao de corrida.
- [ ] Teste real em APK com permissao aceita.
- [ ] Teste real em APK com permissao negada.
- [ ] Teste real em APK com GPS desligado.

### Estatisticas e GPS

- [x] Distancia calculada entre pontos GPS validos.
- [x] Tempo total calculado pelo cronometro da corrida.
- [x] Pace medio calculado por tempo/distancia.
- [x] Velocidade media calculada por tempo/distancia.
- [x] Velocidade maxima baseada em pontos aceitos, evitando velocidade bruta falsa do sensor.
- [x] Passos coletados por sensor quando disponivel.
- [x] Passos estimados por altura quando nao houver sensor salvo.
- [x] Cadencia calculada por passos/minuto.
- [x] Calorias estimadas por peso, duracao e intensidade.
- [x] Altimetria calculada por ganho positivo de altitude.
- [x] Ignorar pontos com baixa precisao de GPS.
- [x] Ignorar variacoes pequenas provocadas por ruido de GPS.
- [x] Ignorar saltos absurdos de coordenadas/velocidade.
- [x] Registrar timestamp em cada ponto de localizacao.
- [x] Persistir logs de debug por treino.
- [x] Logs incluem latitude, longitude, timestamp, precisao, velocidade instantanea, distancia incremental, distancia acumulada e aceite/rejeicao.
- [ ] Mostrar na UI quais metricas sao estimadas.
- [ ] Criar tela/exportacao simples para visualizar logs de debug de um treino.
- [ ] Comparar corrida de 1 km com app confiavel.
- [ ] Testar com tela bloqueada.
- [ ] Testar caminhada curta.
- [ ] Testar corrida em pista/praca.
- [ ] Testar corrida urbana.
- [ ] Testar pausa durante treino.

## Prioridade Media

### Navegacao inferior mobile

- [x] Reduzir barra inferior para no maximo cinco destinos.
- [x] Mover Metas para dentro de Inicio ou Perfil.
- [ ] Revisar textos e icones em telas pequenas.

### Ranking

- [x] Transformar filtros de liga em chips rolaveis horizontalmente.
- [x] Garantir padding inferior para nao esconder conteudo.
- [x] Destacar melhor o usuario logado.
- [x] Mostrar XP faltante para ultrapassar o proximo colocado.
- [x] Conferir consistencia entre XP, ranking e posicoes.

### Gamificacao estilo Duolingo

- [ ] Animacao ao ganhar XP depois da corrida.
- [ ] Animacao de missao concluida.
- [ ] Animacao de conquista desbloqueada.
- [ ] Feedback do Bolt comemorando progresso.
- [ ] Barra clara de progresso para proxima liga.
- [ ] Mensagem quando a sequencia estiver em risco.
- [ ] Tela de resumo pos-corrida com distancia, tempo, pace, XP, missoes e conquistas.

### Mascote Bolt

- [x] Bolt como tutor na tela de corrida ativa.
- [ ] Bolt celebrando missao concluida.
- [ ] Bolt celebrando conquista desbloqueada.
- [ ] Bolt alertando sequencia em risco.
- [ ] Bolt com mensagens contextuais por progresso.

### Conquistas

- [ ] Tela de detalhe ao tocar em uma conquista.
- [ ] Mostrar recompensa de XP por conquista.
- [ ] Separar conquistas por dificuldade/categoria.
- [ ] Mostrar progresso parcial por conquista.

### Metas

- [x] Adicionar botoes rapidos: 5 km, 10 km, 25 km e 42 km.
- [x] Adicionar botoes + e - para meta semanal.
- [x] Criar botao "Aplicar plano".
- [x] Explicar quantidade sugerida de treinos por semana em cada plano.

### Perfil

- [ ] Informar campos obrigatorios e opcionais.
- [ ] Explicar que calorias sao estimadas.
- [ ] Explicar calculo de passos/passada.
- [ ] Indicar "passos estimados" quando nao vierem do sensor.
- [ ] Indicar altimetria como estimativa quando vier do GPS.
- [ ] Criar area "Como calculamos suas estatisticas?".

### Historico

- [ ] Melhorar estado vazio com orientacao sobre GPS e registro manual.
- [ ] Diferenciar corrida com GPS de registro manual.
- [ ] Mostrar XP ganho em cada treino.
- [ ] Mostrar missoes concluidas em cada treino.
- [ ] Indicar se o treino foi GPS ou manual.

## Ajustes Gerais Mobile/APK

- [x] Safe area aplicada na tela de corrida ativa.
- [x] Botoes principais da corrida com area de toque maior.
- [ ] Revisar padding inferior em todas as telas.
- [ ] Revisar legibilidade em telas pequenas.
- [ ] Revisar scroll das telas longas.
- [ ] Avaliar performance do video inicial no APK.
- [ ] Avaliar tempo de carregamento inicial.
- [ ] Testar comportamento sem internet.
- [ ] Testar comportamento com GPS desligado.
- [ ] Testar comportamento com permissao de localizacao negada.

## Builds e Validacao

- [x] `flutter analyze`.
- [x] `flutter test`.
- [x] `flutter build apk --release`.
- [ ] Teste final manual no APK.
- [ ] Publicacao em teste interno.
