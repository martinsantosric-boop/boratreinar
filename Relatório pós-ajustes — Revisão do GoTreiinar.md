# Relatório pós-ajustes — Revisão do GoTreiinar

**Autor:** Manus AI  
**Data:** 07/06/2026  
**Aplicativo analisado:** [GoTreiinar](https://gotreiinar.web.app/)  
**Foco da revisão:** conferência das melhorias implementadas após a primeira auditoria, com ênfase em mobile/APK, fluxo de corrida, gamificação, mascote, menus e confiabilidade das estatísticas.

## 1. Parecer executivo

O **GoTreiinar melhorou claramente em várias áreas visuais e explicativas** depois das alterações. A tela inicial ficou mais forte, o mascote aparece com mais presença, as missões diárias ficaram mais objetivas, a tela de Perfil explica melhor o papel de peso, altura e idade nas estimativas, e o Ranking ganhou uma seção explicativa que ajuda bastante na confiança do usuário. Em termos de identidade visual, proposta de produto e gamificação, o aplicativo está mais maduro do que na primeira revisão.

O ponto que ainda merece atenção antes de considerar o APK pronto é o mesmo fluxo crítico da auditoria anterior: a **tela de Corrida ativa**. Agora a tela abre corretamente com temporizador, cards de métricas e estado **“Aguardando início”**, e o bundle do app contém textos de GPS, permissão e ações como **Pausar** e **Finalizar e salvar**. No entanto, durante a revisão mobile, o usuário ainda não enxerga imediatamente um botão grande e evidente de **“Iniciar corrida”**, nem um estado de GPS/permissão realmente destacado na primeira dobra. Para um app de corrida, esse detalhe é decisivo, porque o primeiro treino precisa ser absolutamente óbvio e confiável.

> **Veredito geral:** o app evoluiu bem e está visualmente mais profissional. Eu diria que as melhorias foram **parcialmente aprovadas**, com destaque positivo para Início, Perfil, Metas, Ranking e gamificação. A principal pendência restante é tornar o fluxo de início da corrida inequívoco no celular.

## 2. Comparação com a auditoria anterior

| Área | Situação anterior | Situação pós-ajustes | Status |
|---|---|---|---|
| Tela inicial | Boa, com mascote e CTA claro. | Ficou mais forte; mascote aparece melhor, missões estão mais concretas e XP mais visível. | **Melhorou** |
| Corrida ativa | Não deixava claro onde iniciar a corrida. | Abre com temporizador e estado “Aguardando início”, mas ainda não mostra botão grande de iniciar na primeira dobra. | **Parcial** |
| GPS/permissão | Não aparecia status claro. | Há evidência no código de mensagens de GPS/permissão, mas elas não ficaram evidentes visualmente no teste mobile. | **Parcial** |
| Histórico | Estado vazio simples. | Continua limpo e com botão Registrar, mas ainda pode explicar melhor GPS versus registro manual. | **Parcial** |
| Conquistas | Badges bons, mas faltava progressão mais rica. | Mantém boa estrutura, nomes claros e progresso; ainda falta detalhe, XP e feedback ao desbloquear. | **Parcial** |
| Ranking | Visual competitivo, mas precisava explicar regras e corrigir densidade. | Ganhou explicação “Como funciona o ranking?”, porém chips continuam apertados e há possível divergência de XP. | **Melhorou com ressalvas** |
| Metas | Boa, mas slider poderia ser mais rápido. | Mais clara, com progresso e planos sugeridos; ainda faltam presets rápidos. | **Melhorou** |
| Perfil | Dados úteis, mas cálculos pouco explicados. | Melhorou bastante; agora explica que dados refinam calorias e passos e mostra passada estimada. | **Aprovado** |
| Mascote | Tinha identidade, mas podia atuar mais como guia. | Ficou mais presente na tela inicial e ranking; ainda pode orientar a primeira corrida. | **Melhorou** |
| Navegação inferior | Seis abas densas. | Continua com seis abas; em 390px está legível, mas ainda é risco em telas menores. | **Pendente leve** |

## 3. Avaliação detalhada por tela

A tela **Início** está mais convincente. O card principal com o mascote, a saudação e o botão **“Bora treinar!”** cria uma entrada motivadora. As missões diárias agora são mais concretas, como **“Corra pelo menos 3km”**, **“Corra por 30 minutos”** e **“Dê 5.000 passos”**, com recompensas de XP bem visíveis. Essa mudança aproxima o aplicativo de um ciclo de hábito mais claro: o usuário entra, entende uma missão e sabe o que precisa fazer para ganhar XP.

| Elemento da tela inicial | Avaliação pós-ajustes | Comentário |
|---|---|---|
| Mascote | Forte | Visualmente mais presente e útil para marca. |
| CTA “Bora treinar!” | Bom | Bem destacado, mas precisa levar a uma tela de corrida ainda mais clara. |
| Missões | Melhoraram | Objetivos agora são mais práticos e mensuráveis. |
| XP e liga | Bons | Reforçam progressão e competição. |
| Navegação inferior | Atenção | Seis abas ainda deixam a navegação mais densa que o ideal em mobile. |

A tela **Corrida ativa** é o ponto principal de atenção. A interface mostra temporizador, estado **“Aguardando início”** e métricas como distância, pace, velocidade e passos. Visualmente, os cards são bons. O problema não é estética; é **clareza de ação**. No teste mobile, após tocar em **“Bora treinar!”**, não ficou evidente se a corrida já estava pronta, se faltava GPS, se faltava permissão ou onde o usuário deveria tocar para iniciar de fato.

> A recomendação central permanece: a primeira dobra da tela de corrida deve conter um botão grande, fixo e inequívoco: **“Iniciar corrida”**. Abaixo ou acima dele, deve aparecer um status de GPS/permissão em linguagem simples, como **“Buscando GPS...”**, **“GPS pronto”** ou **“Permissão de localização necessária”**.

O **Histórico** continua limpo e compreensível. O estado vazio com a mensagem **“Seu histórico de corrida vai aparecer aqui.”** é correto, e o botão **Registrar** aparece como ação principal. Ainda assim, para reduzir dúvidas, sugiro trocar por um texto mais instrutivo: **“Ao finalizar uma corrida com GPS, ela aparecerá aqui. Você também pode registrar manualmente um treino feito fora do app.”** Na captura pós-ajustes, a tentativa automatizada de acionar **Registrar** não mostrou modal ou nova tela, mas isso deve ser conferido manualmente no APK, pois pode ter sido apenas limitação do toque automatizado.

A tela **Conquistas** continua forte. Ela possui nomes claros, progresso e conquistas bloqueadas como **Primeira Corrida**, **Aquecendo**, **Uma Semana**, **Hábito Formado**, **5K Master**, **10K Master** e **Meia Maratona**. O sistema já sustenta bem a proposta gamificada. A melhoria recomendada é adicionar uma tela de detalhe ao tocar em cada conquista, mostrando critério, progresso parcial, recompensa em XP e uma pequena celebração ao desbloquear.

O **Ranking** foi uma das áreas que mais melhorou. A seção **“Como funciona o ranking?”** aumenta a confiança, principalmente ao informar que os dados são reais e sincronizados. O pódio com mascote e medalhas ficou bom. Contudo, os filtros de liga ainda ficam apertados no mobile, com a opção **Diamante** parcialmente cortada na lateral. Além disso, foi observada uma possível inconsistência visual de pontuação: no pódio aparece Ricardo com **0 XP**, enquanto em **Demais posições** aparece Ricardo Martins com **110 XP**. Recomendo revisar a query e a regra de exibição para garantir que o mesmo usuário não apareça com pontuações divergentes.

A tela **Metas** também melhorou. O objetivo semanal de **25 km por semana**, o botão **Salvar meta**, o progresso semanal, o volume do mês e os planos sugeridos deixam a tela útil para planejamento. Ainda recomendo incluir presets rápidos, como **5 km**, **10 km**, **25 km** e **42 km**, ou botões **+ / -**, porque slider pode ser impreciso em celular.

A tela **Perfil** está aprovada como melhoria. Agora o cabeçalho explica que **peso, altura e idade refinam calorias e estimativas de passos** e que os dados são opcionais. Isso aumenta transparência e ajuda o usuário a entender por que preencher esses campos. Os cards de **Passos por km** e **Passada estimada** também são positivos, pois mostram que algumas estatísticas são estimadas e dependem dos dados corporais.

## 4. Gamificação e mascote

A gamificação está mais consistente do que antes. O app já tem os principais pilares de um produto de hábito: **XP**, **missões diárias**, **conquistas**, **ranking**, **ligas**, **sequência de dias** e **metas**. As missões atuais estão melhores porque são objetivas e têm recompensa explícita. Isso é um avanço importante.

| Elemento de gamificação | Situação atual | Próximo refinamento recomendado |
|---|---|---|
| XP | Visível e integrado às missões. | Mostrar animação de ganho após treino. |
| Missões | Mais claras e mensuráveis. | Marcar progresso em tempo real durante a corrida. |
| Conquistas | Boa coleção inicial. | Adicionar detalhe, recompensa e celebração. |
| Ranking | Mais confiável com explicação. | Corrigir possível divergência de XP e melhorar chips. |
| Ligas | Aparecem na tela inicial e ranking. | Explicar regra de subida/queda e prazo da temporada. |
| Mascote | Mais presente visualmente. | Transformar em guia contextual, principalmente no primeiro treino. |

O mascote deve ser usado principalmente na **primeira corrida**. Por exemplo, ao abrir a tela de Corrida ativa pela primeira vez, ele poderia dizer: **“Vou esperar o GPS ficar pronto. Quando aparecer verde, toque em Iniciar corrida.”** Isso resolve duas coisas ao mesmo tempo: aumenta a personalidade do app e reduz a dúvida do usuário no fluxo mais importante.

## 5. Estatísticas, GPS e confiabilidade

A pergunta principal continua válida: para ter certeza de que distância, pace, velocidade, passos e calorias estão corretos, você precisa testar em **celular real**. Não é necessário publicar direto em produção na Play Store. O caminho mais seguro é distribuir por APK local, teste interno ou faixa de teste da Play Console antes de abrir para todos. O Google Play oferece faixas de teste para validar versões antes da publicação ampla.[1]

No bundle atualizado, encontrei evidências de que a lógica de corrida e GPS avançou: há textos como **“GPS calibrado. Pode iniciar o movimento.”**, **“Ative o GPS do aparelho para iniciar a corrida.”**, **“Permissão de localização negada.”**, **“A permissão de localização está bloqueada nas configurações.”**, além das ações **Pausar** e **Finalizar e salvar**. Isso é positivo. O que falta é garantir que esses estados apareçam de forma clara na interface quando o usuário estiver no celular.

Para validar métricas, o app deve registrar pontos de localização com horário, acurácia e coordenadas. No Android, permissões de localização precisam ser tratadas de forma explícita, e a localização pode ser aproximada ou precisa, dependendo da autorização do usuário.[2] A classe `Location` também trabalha com latitude, longitude, tempo, altitude, velocidade e acurácia horizontal, sendo a acurácia expressa em metros.[3]

| Teste recomendado | Como executar | Critério de aprovação |
|---|---|---|
| Caminhada de 1 km | Fazer percurso conhecido com GoTreiinar e app referência. | Diferença ideal até 3% a 5% em área aberta. |
| Pista ou praça | Dar voltas em distância conhecida. | Erro pequeno e repetível por volta. |
| Comparação com Strava/Google Fit | Rodar os dois apps ao mesmo tempo. | Distância e pace próximos. |
| Tela bloqueada | Iniciar corrida e bloquear o celular. | O app deve continuar registrando. |
| Permissão negada | Negar localização no Android. | O app deve orientar claramente o usuário. |
| GPS desligado | Testar com localização do aparelho desligada. | Deve aparecer mensagem clara e não iniciar errado. |
| Pausa e retomada | Parar 2 minutos e continuar. | Deve deixar claro se conta tempo total ou em movimento. |

## 6. Pendências prioritárias para o programador

A melhoria mais importante agora é ajustar a tela **Corrida ativa** para que ela tenha um bloco fixo de controle. Minha sugestão é usar uma área na parte inferior, acima da navegação, com três estados: **Preparando GPS**, **Pronto para iniciar** e **Corrida em andamento**. No estado inicial, mostrar o botão desabilitado ou secundário até o GPS estar pronto. Quando o GPS estiver calibrado, mostrar o botão grande **“Iniciar corrida”**. Durante a corrida, trocar por **“Pausar”** e **“Finalizar”**.

| Prioridade | Ação recomendada | Motivo |
|---:|---|---|
| Alta | Exibir botão grande **Iniciar corrida** na primeira dobra. | Remove a principal dúvida do fluxo. |
| Alta | Exibir status claro de GPS/permissão. | Aumenta confiança nas estatísticas. |
| Alta | Testar APK em celular real com app referência. | Valida distância, pace e tempo. |
| Média | Corrigir possível divergência de XP no Ranking. | Ranking precisa ser confiável. |
| Média | Melhorar chips de liga no mobile. | Evita corte visual em telas pequenas. |
| Média | Adicionar detalhe e recompensa nas Conquistas. | Fortalece gamificação. |
| Média | Usar mascote como tutor na primeira corrida. | Ajuda onboarding e reduz fricção. |
| Baixa | Adicionar presets em Metas. | Facilita ajuste em celular. |
| Baixa | Revisar se o botão Registrar abre corretamente no APK. | Garante ação do estado vazio. |

## 7. Veredito final pós-ajustes

O GoTreiinar está **melhor do que na primeira auditoria**. As mudanças foram na direção correta e deixaram o produto mais claro, mais bonito e mais convincente. Eu considero que o app está com uma boa base de MVP gamificado para corrida, especialmente pela combinação de mascote, XP, missões, metas, conquistas e ranking.

Mesmo assim, eu ainda não consideraria o APK totalmente pronto para divulgação ampla sem resolver a tela de **Corrida ativa**. O app pode estar tecnicamente com lógica de GPS no código, mas o usuário precisa enxergar claramente o que está acontecendo. Em app de corrida, confiança começa antes da primeira passada: o usuário precisa saber se o GPS está pronto, onde toca para iniciar, como pausa e como finaliza.

Minha recomendação final é: **corrigir o controle visual da corrida, revisar a possível inconsistência do ranking e fazer uma rodada de testes reais no celular**. Depois disso, o app estará muito mais seguro para teste interno, teste fechado na Play Console e, posteriormente, publicação mais ampla.

## Referências

[1]: https://support.google.com/googleplay/android-developer/answer/9845334?hl=pt-BR "Google Play Console Help — Configurar um teste aberto, fechado ou interno"
[2]: https://developer.android.com/develop/sensors-and-location/location/permissions "Android Developers — Request location permissions"
[3]: https://developer.android.com/reference/android/location/Location "Android Developers — Location API reference"
