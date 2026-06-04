# Relatório de Análise Visual - Gotreiinar (Cooper Maratonista)

Este relatório apresenta uma análise detalhada da interface do usuário (UI) e da experiência do usuário (UX) do site [gotreiinar.web.app](https://gotreiinar.web.app/), com foco em proporções, fontes, ícones e elementos visuais.

## 1. Análise de Proporções e Layout

O site utiliza um layout limpo, mas apresenta alguns desafios de proporcionalidade que podem afetar a harmonia visual.

| Elemento | Observação Atual | Sugestão de Melhoria |
| :--- | :--- | :--- |
| **Botão "Bora treinar!"** | Muito alongado horizontalmente, ocupando quase toda a largura da tela. | Reduzir a largura máxima ou transformá-lo em um botão de ação flutuante (FAB) ou centralizado com bordas arredondadas mais suaves. |
| **Cards de Resumo** | Os cards de "Total corrido" e "Treinos" possuem muito espaço em branco (white space) subutilizado. | Centralizar as informações dentro dos cards ou adicionar micro-interações/gráficos simples para preencher o espaço de forma útil. |
| **Espaçamento Geral** | O distanciamento entre as seções (Missões, Resumo) está adequado, mas as margens laterais parecem um pouco estreitas em telas maiores. | Implementar um `max-width` no container principal para evitar que os elementos se espalhem demais em monitores ultra-wide. |

## 2. Ícones e Imagens (Foco nos Elos)

Os ícones são essenciais para a gamificação do app, mas precisam de ajustes para ganhar o destaque merecido.

*   **Imagens dos Elos (Ligas):** 
    *   **Problema:** O ícone da "Liga Bronze" na home aparece pequeno e um pouco "perdido" ao lado do mascote.
    *   **Melhoria:** Aumentar a escala do ícone em pelo menos 20% e adicionar um efeito de brilho ou sombra suave (drop shadow) para dar profundidade. Ele deve parecer uma "recompensa" visual.
*   **Ícones do Menu Inferior:**
    *   **Problema:** A espessura das linhas dos ícones varia levemente entre eles, o que quebra a consistência.
    *   **Melhoria:** Utilizar um conjunto de ícones com a mesma espessura de traço (stroke weight). O ícone de "Conquistas" (troféu) está bem resolvido, mas o de "Ranking" poderia ser mais robusto.

## 3. Tipografia e Fontes

A hierarquia tipográfica é o ponto que mais precisa de atenção para guiar o olhar do usuário.

> **Observação Técnica:** A fonte atual é legível, mas falta contraste entre o que é título, o que é dado numérico e o que é legenda.

| Contexto | Estado Atual | Recomendação |
| :--- | :--- | :--- |
| **Números de XP/KM** | Fonte padrão, peso médio. | Usar **Negrito (Bold)** e aumentar o tamanho da fonte. Os números são a principal métrica de sucesso do usuário. |
| **Legendas do Menu** | Muito pequenas e com baixo contraste. | Aumentar em 1px ou 2px e garantir que a cor tenha contraste suficiente com o fundo branco/cinza claro. |
| **Títulos de Seção** | "Missões de hoje", "Resumo". | Adicionar um pouco mais de `letter-spacing` (espaçamento entre letras) para um visual mais moderno e "premium". |

## 4. Menus e Navegação

*   **Menu Inferior:** O comportamento de "clique" no Flutter Web pode parecer um pouco lento se não houver um feedback visual imediato. Sugere-se adicionar uma animação de "ripple" ou mudança de cor mais vibrante ao selecionar um item.
*   **Acessibilidade:** Os ícones de cadeado na tela de Conquistas são pequenos. Para usuários com dificuldades motoras, a área de toque pode ser um problema.

## 5. Conclusão e Próximos Passos

O site tem uma base sólida e funcional. As melhorias sugeridas são focadas em transformar uma ferramenta funcional em uma experiência **envolvente e visualmente atraente**.

**Principais Prioridades:**
1.  Aumentar o destaque visual dos **Elos/Ligas**.
2.  Refinar a hierarquia das **Fontes** (destacar números).
3.  Ajustar a largura do botão principal para uma melhor **Proporção**.

---
*Relatório gerado por Manus AI para o projeto Gotreiinar.*
