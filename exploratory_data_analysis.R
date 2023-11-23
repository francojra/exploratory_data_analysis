
# Análise Exploratória dos Dados -----------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 22/11/23 ---------------------------------------------------------------------------------------------------------------------------
# Fonte: https://r4ds.hadley.nz/eda#introduction -------------------------------------------------------------------------------------------

# Introdução -------------------------------------------------------------------------------------------------------------------------------

### A análise exploratória dos dados (EDA) serve para:

### 1 - Gerar questões sobre os seus dados;
### 2 - Encontrar respostas visualizando, transformando e modelando os dados;
### 3 - Usar o que aprendeu para refinar questões/gerar novas questões.

### Durante as fases iniciais da EDA, você deve se sentir à vontade para 
### investigar cada ideia que lhe ocorrer. Algumas dessas ideias darão certo 
### e outras serão becos sem saída.

### A EDA é uma parte importante de qualquer análise de dados, mesmo que 
### as principais questões de pesquisa sejam entregues a você de bandeja,
### porque você sempre precisa investigar a qualidade dos seus dados.

### Para fazer a limpeza de dados, você precisará implantar todas as 
### ferramentas de EDA: visualização, transformação e modelagem.

### "É muito melhor uma resposta aproximada à pergunta certa, que muitas 
### vezes é vaga, do que uma resposta exata à pergunta errada, que sempre 
### pode ser precisa." - John Tukey.

### Seu objetivo durante a EDA é desenvolver uma compreensão dos seus dados. 
### A maneira mais fácil de fazer isso é usar perguntas como ferramentas para
### orientar sua investigação. Quando você faz uma pergunta, ela concentra 
### sua atenção em uma parte específica do seu conjunto de dados e ajuda 
### você a decidir quais gráficos, modelos ou transformações fazer.

### A chave para fazer perguntas de qualidade é gerar uma grande quantidade 
### de perguntas. É difícil fazer perguntas reveladoras no início da sua 
### análise porque você não sabe quais insights podem ser obtidos do seu 
### conjunto de dados.

### Por outro lado, cada nova pergunta que você fizer irá expô-lo a um novo 
### aspecto dos seus dados e aumentar suas chances de fazer uma descoberta.
### Você pode detalhar rapidamente as partes mais interessantes dos seus 
### dados — e desenvolver um conjunto de perguntas instigantes.

### Não há regra sobre quais perguntas você deve fazer para orientar sua 
### pesquisa. No entanto, dois tipos de perguntas sempre serão úteis para 
### fazer descobertas em seus dados. Você pode formular essas perguntas 
### livremente como:

### - Que tipo de variação ocorre dentro das minhas variáveis?
### - Que tipo de covariação ocorre entre as minhas variáveis?

# Variação ---------------------------------------------------------------------------------------------------------------------------------

### Variation is the tendency of the values of a variable to change from 
### measurement to measurement. You can see variation easily in real life; 
### if you measure any continuous variable twice, you will get two different 
### results.

### Every variable has its own pattern of variation, which can reveal 
### interesting information about how that it varies between measurements 
### on the same observation as well as across observations.

### Vamos iniciar visualizando a variação no peso de diamantes do dataset
### diamonds. Como carat é uma variável numérica, podemos usar um histograma.

library(ggplot2)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

# Valores típicos --------------------------------------------------------------------------------------------------------------------------

### In both bar charts and histograms, tall bars show the common values of
### a variable, and shorter bars show less-common values. 

### Which values are the most common? Why?

### Which values are rare? Why? Does that match your expectations?

### Can you see any unusual patterns? What might explain them?

### Vamos observar a distribuição de pequenos diamantes:

library(dplyr)
smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

### This histogram suggests several interesting questions:

### Why are there more diamonds at whole carats and common fractions of carats?

### Why are there more diamonds slightly to the right of each peak than 
### there are slightly to the left of each peak?

# Valores atípicos -------------------------------------------------------------------------------------------------------------------------

### Outliers são observações atípicas, pontos de dados que não estão ajustados
### ao padrão. Algumas vezes outliers são erros de entrada de dados. Algumas vezes
### são apenas valores extermos coletados e observados. Outras vezes, pode revelar
### importantes descobertas. Quando você tem muitos dados, fica difícil ver os
### outliers em histogramas

### Por exemplo, pegue a distribuição da variável y do conjunto de dados de 
### diamantes. A única evidência de valores discrepantes são os limites 
### incomumente amplos no eixo x.

ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)

### Há tantas observações nas caixas comuns que as caixas raras são muito curtas,
### tornando muito difícil vê-las (embora talvez se você olhar atentamente 
### para 0 você encontre algo).

### Para facilitar a visualização dos valores incomuns, precisamos ampliar para 
### valores pequenos do eixo y com coord_cartesian():

ggplot(diamonds, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

### coord_cartesian() também possui um argumento xlim() para quando você 
### precisar ampliar o eixo x. ggplot2 também possui funções xlim() e ylim() 
### que funcionam de maneira um pouco diferente: elas jogam fora os dados fora 
### dos limites.

### Isso nos permite ver que existem três valores incomuns: 0, ~30 
### e ~60. Nós os arrancamos com dplyr:

unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |>
  arrange(y)
unusual

### A variável y mede uma das três dimensões desses diamantes, em mm. 
### Sabemos que os diamantes não podem ter largura de 0 mm, então esses 
### valores devem estar incorretos. Ao fazer EDA, descobrimos dados 
### faltantes codificados como 0, que nunca teríamos encontrado 
### simplesmente procurando por NAs.

### No futuro, poderemos optar por recodificar estes valores como NAs, a 
### fim de evitar cálculos enganosos. Também podemos suspeitar que as 
### medidas de 32 mm e 59 mm são implausíveis: esses diamantes têm mais 
### de uma polegada de comprimento, mas não custam centenas de milhares 
### de dólares!

### É uma boa prática repetir sua análise com e sem valores discrepantes. 
### Se eles tiverem um efeito mínimo nos resultados e você não conseguir 
### descobrir por que estão ali, é razoável omiti-los e seguir em frente.

### No entanto, se eles tiverem um efeito substancial nos seus resultados,
### você não deve abandoná-los sem justificativa. Você precisará descobrir 
### o que os causou (por exemplo, um erro de entrada de dados) e divulgar 
### que os removeu em seu artigo.