
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

# Questões ---------------------------------------------------------------------------------------------------------------------------------

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

### Uma variável categórica e uma numérica: -----------------

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

### cut é um fator ordenado: razoável é pior que bom, que por suas vez é pior que
### muito bom e assim por diante. Muitas variáveis categóricas não tem uma ordem
### intrínseca, então você pode querer reordenar elas para tornar mais informativo.
### Um caminho para isso é usar a fct_reorder(). Você irá aprender mais sobre essa
### função na seção 16.4, mas nós queremos dar uma rápida pré-visualização do uso
### dela. Por exemplo, pegue a variável class dos dados mpg. Você pode estar interessado
### em saber como a quilometragem da rodovia varia entre as classes:

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

### Para tornar a tendência mais fácil de visualizar, nós podemos reordenar as classes
### baseado no valor mediano de hwy:

ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot()

### Se você tem nomes longos de variáveis, geom_boxplot() irá trabalhar melhor se você
### virar em 90º. Você pode fazer isso trocando os eixos x e y.

ggplot(mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
  geom_boxplot()

### Duas variáveis categóricas: -------------------------------

### Para visualizar a covariação entre duas variáveis categóricas, você irá necessitar
### contar o número de observações para cada combinação dos níveis dessas variáveis
### categóricas. Uma maneira de fazer isso é contar com o geom_count() integrado:

ggplot(diamonds, aes(x = cut, y = color)) +
  geom_count()

### O tamanho de cada círculo no gráfico exibe quantas observações ocorrem em cada
### combinação de valores. A covariação aparecerá como uma forte correlação entre
### valores específicos de x e valores específicos de y.

### Outra abordagem para explorar a relação entre essas variáveis é calcular as
### contagens com dplyr:

diamonds |> 
  count(color, cut)

### Em seguida, visualize com geom_tile() e a estética (aesthetic) de preechimento:

diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

### Se as variáveis categóricas estão desordenadas, você pode querer usar o pacote de 
### seriação para reordenar simultaneamente as linhas e colunas para revelar padrões
### interessantes com mais clareza. Para gráficos maiores, você pode querer usar o
### pacote heatmaply, que cria gráficos interativos.

### Duas variáveis numéricas: -------------------------------------------

### Você já viu uma ótima maneira de visualizar a covariação entre duas variáveis 
### numéricas: desenhar um gráfico de dispersão com geom_point(). Você pode ver a
### covariação com o padrão dos pontos. Por exemplo, você pode ver uma relação positiva
### entre tamanho de carat e preço do diamante: diamantes com mais carat tem preços
### mais altos. A relação é exponencial.

smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat, y = price)) +
  geom_point()

### (Nesta seção usaremos o conjunto de dados menor para manter o foco na 
### maior parte dos diamantes menores que 3 quilates)

### Gráficos de dispersão se tornam menos usuais a medida que seu conjunto
### de dados cresce, porque os pontos se acumulam, e se amontoam em áreas 
### de preto uniforme, tornando difícil julgar diferenças na densidade dos
### dados em torno do espaço bidimensional, bem como difícil de ver a 
### tendência. Você já tem visto uma forma de corrigir esse problema: usando
### usando a estética (aesthetic) alpha e adicionando transparência.

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_point(alpha = 1 / 100)

### Mas usar transparência pode ser desafiador para conjunto de dados grandes.
### Outra solução é usar o bin (compartimentos/caixas). Previamente, você usou geom_histogram() e 
### geom_freqpoly() para bin em uma dimensão. Agora você irá aprender como usar
### geom_bin2d() e geom_hex() para bin em duas dimensões.

### geom_bin2d() e geom_hex() divide o plano de coordenadas em bins 2D e então
### usa um preenchimento de cor para exibir quantos pontos caem em cada bin.
### geom_bin2d() cria bins retangulares e geom_hex() cria bins hexagonais.
### Você irá necessitar instalar o pacote hexbin para usar geom_hex().

ggplot(smaller, aes(x = carat, y = price)) +
  geom_bin2d()

# install.packages("hexbin")
ggplot(smaller, aes(x = carat, y = price)) +
  geom_hex()

### Outra opção é agrupar uma variável contínua para que ela atue como uma variável 
### categórica. Então você usa uma das técnicas para visualizar a combinação
### de uma variável categórica e uma contínua que você aprendeu antes. Por exemplo,
### você poderia agrupar carat, e então para cada grupo exibir um boxplot:

ggplot(smaller, aes(x = carat, y = price)) + 
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

### cut_width(x, width), conforme usado acima, divide x em compartimentos de 
### largura (width). Por padrão, os boxplots parecem praticamente os mesmos 
### (exceto pelo número de valores discrepantes), independentemente de 
### quantas observações existem, então é difícil dizer que cada boxplot resume
### um diferente número de pontos. Uma maneira de mostrar isso é tornar a 
### largura do boxplot proporcional ao número de pontos com varwidth = TRUE.

# Padrões e modelos ------------------------------------------------------------------------------------------------------------------------

### Se existe uma relação sistemática entre duas variáveis ela irá aparecer como
### um padrão nos dados. Se você detectar um padrão, se questione:

### - Poderia esse padrão ser uma coincidência (ou seja, ao acaso)?
### - Como você pode descrever a relação implícita no padrão?
### - Quão forte é a relação implícita no padrão?
### - Quais outras variáveis podem afetar a relação?
### - O relacionamento muda se você observar subgrupos individuais de dados?

### Os padrões nos seus dados revelam relações, por exemplo, eles revelam covariação.
### Se pensarmos na variação como um fenômeno que cria incerteza, covariação é
### um fenômeno que reduz ela. Se duas variáveis covariam, você pode usar os valores
### de uma variável para fazer melhores previsões sobre os valores da segunda. Se a
### covariação é uma relação causal (um caso especial), então você pode usar o valor
### de uma variável para controlar o valor da segunda.

### Os modelos são ferramentas para extrair padrões dos dados. Por exemplo, considere
### os dados diamonds. É difícil entender a relação entre corte e preço, porque corte
### e quilate, e quilate e preço são intimamente relacionados. É possível usar o modelo
### para remover a forte relação entre preço e quilate então nós podemos explorar as
### complexidades que permanecem. O seguinte código ajusta o modelo que prediz preço de
### quilate e então calcula os resíduos (a diferença entre o valor predito e o valor real).
### Os resíduos nos dão uma visão do preço do diamante, uma vez que o efeito do quilate
### tem sido removido. Note que ao invés de usar os valores das linhas de preço e quilate,
### nós transformamos em log primeiro, e ajustamos o modelo aos valores transformados
### em log. Depois, exponenciamos os resíduos para colocá-los de volta na escala de 
### preços brutos.

library(tidymodels)

diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

diamonds_fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))

ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
  geom_point()

### Uma vez que você tem removido a forte relação entre quilate e preço,
### você pode ver o esperado da relação entre corte e preço: relativo ao
### tamanho deles, diamantes de melhor qualidade (corte) são mais caros.

ggplot(diamonds_aug, aes(x = cut, y = .resid)) + 
  geom_boxplot()

### Nós não discutimos modelagem nesse livro porque entender o que são os 
### modelos e como eles trabalham é mais fácil uma vez que você tem ferramentas
### de organização de dados (data wrangling) e programação em mãos.

# Resumo -----------------------------------------------------------------------------------------------------------------------------------

### Nesse capítulo você tem aprendido uma variedade de ferramentas para ajudar
### você a entender a variação dentro dos dados. Você tem visto técnicas que
### trabalham com uma única variável no tempo e com um par de variáveis. Isso
### pode parecer dolorosamente restritivo se você tem dezenas ou centenas de
### variáveis nos seus dados, mas elas são a base sobre a qual todas as outras
### técnicas são construídas.

### No próximo capítulo, nós focaremos sobre ferramentas que podemos usar para
### comunicar nossos resultados.





