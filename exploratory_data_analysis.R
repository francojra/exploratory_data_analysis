
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

# Carregar pacotes necessários -------------------------------------------------------------------------------------------------------------

library(tidyverse)

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

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

# Valores típicos --------------------------------------------------------------------------------------------------------------------------

### In both bar charts and histograms, tall bars show the common values of
### a variable, and shorter bars show less-common values. 

### Which values are the most common? Why?

### Which values are rare? Why? Does that match your expectations?

### Can you see any unusual patterns? What might explain them?

### Vamos observar a distribuição de pequenos diamantes:

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

# Lidando com valores atípicos -------------------------------------------------------------------------------------------------------------

### Se você encontrou valores atípicos no sei conjunto de dados e deseja
### prosseguir com suas análises, você tem duas opções:

### Eliminar a linha inteira com os valores estranhos.

diamonds2 <- diamonds |> 
  filter(between(y, 3, 20))
view(diamonds2)

### Não recomendamos esta opção porque um valor inválido não implica que todos 
### os outros valores para essa observação também sejam inválidos. Além disso, 
### se você tiver dados de baixa qualidade, ao aplicar essa abordagem a todas 
### as variáveis, você poderá descobrir que não tem mais dados!

### Ao invés, nós recomendamos substituir os valores atípicos por missing values,
### ou seja, por NAs. O caminho mais fácil para fazer isso, é usar a função
### mutate() para substituir os valores atípicos da variável.Você também pode
### usar o if_else() para substituir os valores atípicos por NA.

diamonds2 <- diamonds |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))
view(diamonds2)

### O ggplot2 não inclui os valores ausentes no gráfico, mas avisa que eles 
### foram removidos:

ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point()

### Para suprimir esse aviso, defina na.rm = TRUE:

ggplot(diamonds2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

### Outras vezes, você deseja entender o que torna as observações com valores 
### ausentes diferentes das observações com valores registrados. Por exemplo, 
### em nycflights13::flights1, valores ausentes na variável dep_time indicam 
### que o voo foi cancelado. Portanto, você pode querer comparar os horários 
### de partida programados para horários cancelados e não cancelados. Você 
### pode fazer isso criando uma nova variável, usando is.na() para verificar 
### se dep_time está faltando.

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) + 
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

### No entanto, este gráfico não é bom porque há muito mais voos não 
### cancelados do que voos cancelados. Na próxima seção exploraremos algumas 
### técnicas para melhorar essa comparação.

# Covariação -------------------------------------------------------------------------------------------------------------------------------

### Se variação descreve o comportamento dentro de uma variável, covariação descreve
### o comportamento entre variáveis. Covariação é a tendência em que os valores de
### duas ou mais variáveis variam juntas em um caminho relacionado. O melhor caminho
### para ver a covariação é visualizar a relação entre duas ou mais variáveis.

### Uma variável categórica e uma numérica:

### Por exemplo, vamos explorar como o preço do diamante varia com a qualidade dele
### (medida pelo corte (cut)) usando geom_frenqpoly()

ggplot(diamonds, aes(x = price)) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

### Note que o ggplot2 usa uma escala de cor ordenada para cut porque ele está definido
### como um fator ordenado nos dados. Você irá aprender mais sobre isso na seção 16.6.

### A aparência padrão de geom_freqpoly() não é tão útil aqui porque a altura, 
### determinada pela contagem geral, difere muito entre os cortes, tornando difícil 
### ver as diferenças nas formas de suas distribuições.

### Para fazer a comparação mais fácil nós necessitamos trocar o que está no eixo y.
### Ao invés da contagem (frequência), nós iremos exibir a densidade (density), que
### é a contagem padronizada para que a área sob cada polígono de frequência seja um.

ggplot(diamonds, aes(x = price, y = after_stat(density))) + 
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)

### Note que nós estamos mapeando a densidade para o eixo y, mas como densidade não
### é uma variável do banco de dados diamonds, nós precisamos primeiro calcular ela.
### Nós usamos a função afer_stat() para fazer isso.

### Há algo bastante surpreendente neste gráfico - parece que os diamantes razoáveis 
### (a qualidade mais baixa) têm o preço médio mais alto! Mas talvez seja porque 
### os polígonos de frequência são um pouco difíceis de interpretar – há muita 
### coisa acontecendo neste gráfico.

### Um gráfico visualmente mais simples para explorar essa relação são os boxplot
### lado a lado.

ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

### Agora nós vemos muito menos informações sobre a distribuição, mas os boxplots
### são mais compactos uma comparação mais fácil entre eles. Isto apoia a descoberta 
### contra-intuitiva de que diamantes de melhor qualidade são normalmente mais 
### baratos! Nos exercícios, você será desafiado a descobrir o porquê.

