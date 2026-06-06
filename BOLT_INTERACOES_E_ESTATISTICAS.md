# Bolt: Interacoes e Estatisticas

Este documento organiza ideias para transformar o Bolt em um companheiro de treino contextual, com aparicoes em momentos importantes da jornada do corredor.

## Principais interacoes do Bolt

### Dashboard

- Acenando para receber o usuario.
- Apontando para o botao de iniciar treino.
- Alongando quando o usuario esta sem correr ha alguns dias.
- Avisando progresso semanal, metas proximas e liga atual.

Mensagens sugeridas:

- Bora correr hoje?
- Falta pouco para bater sua meta semanal.
- Voce esta perto de subir de liga.

### Antes do treino

- Amarrando o tenis.
- Correndo parado.
- Fazendo aquecimento.
- Segurando cronometro.

Mensagens sugeridas:

- Aquecido? Entao vamos nessa.
- Hoje e dia de manter o ritmo.
- Comece leve e encontre seu pace.

### Durante o treino

- Correndo ao lado do usuario em notificacoes leves.
- Fazendo positivo a cada quilometro completo.
- Apontando para frente quando o usuario passa da metade da meta.
- Comemorando quando o pace melhora.

Gatilhos sugeridos:

- 1 km concluido.
- Metade da meta atingida.
- Pace melhor que o treino anterior.
- Ritmo constante por varios minutos.

### Pos-treino

- Comemorando com os bracos levantados.
- Segurando uma medalha.
- Batendo palma.
- Ofegante, mas feliz.

Mensagens sugeridas:

- Treino finalizado.
- Mais um treino para a conta.
- Seu pace medio foi excelente hoje.
- Voce queimou energia e ganhou consistencia.

### Conquistas

- Pulando com confete.
- Segurando trofeu.
- Fazendo pose de vitoria.
- Mostrando a medalha desbloqueada.

Conquistas importantes:

- Primeiro treino.
- Maior distancia.
- Melhor pace.
- Maior sequencia semanal.
- Mais calorias em um treino.
- Nova liga alcancada.

### Mudanca de liga

A mudanca de liga deve ser uma celebracao especial. O Bolt pode atravessar uma linha de chegada, subir em um podio ou levantar uma placa com a nova liga.

Mensagens sugeridas:

- Voce subiu para a nova liga.
- Seu esforco te levou mais longe.
- Nova liga desbloqueada.

### Tela de estatisticas

O Bolt pode ajudar a explicar as metricas sem ocupar a tela inteira:

- Pace: Bolt com cronometro.
- Distancia: Bolt apontando para um mapa.
- Calorias: Bolt segurando uma chama.
- Passos: Bolt mostrando pegadas.
- Frequencia cardiaca: Bolt com icone de coracao.
- Altimetria: Bolt subindo uma ladeira.
- Cadencia: Bolt marcando ritmo com os pes.
- Velocidade maxima: Bolt em pose de sprint.

### Treino abaixo do esperado

O Bolt deve incentivar sem julgar.

Mensagens sugeridas:

- Tudo bem. O importante e voltar.
- Hoje foi mais curto, mas ainda conta.
- Descanso tambem faz parte do treino.

## Estatisticas priorizadas

### Basicas

- Tempo total.
- Distancia.
- Passos.
- Calorias estimadas.

### Ritmo e velocidade

- Pace medio.
- Velocidade media.
- Velocidade maxima.

### Avancadas

- Frequencia cardiaca media, quando informada manualmente ou futuramente sincronizada.
- Ganho de elevacao, quando o GPS fornecer altitude.
- Cadencia media em passos por minuto.

## Orientacao de implantacao

1. Usar o Bolt nos momentos mais importantes primeiro: inicio, pos-treino, conquistas e mudanca de liga.
2. Mostrar estatisticas avancadas apenas quando houver dados confiaveis.
3. Manter mensagens curtas para nao atrapalhar o treino.
4. Reaproveitar os assets existentes em `assets/bolt`.
5. Evoluir depois para animacoes especificas por contexto.
