
# Análise Exploratória dos Dados -----------------------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 22/11/23 ---------------------------------------------------------------------------------------------------------------------------
# Fonte: https://r4ds.hadley.nz/eda#introduction -------------------------------------------------------------------------------------------

# Introdução -------------------------------------------------------------------------------------------------------------------------------

### Esse capítulo mostrará a você como usar visualização e transformação para explorar
### seus dados em uma forma sistemática, uma terfa que os estatísticos chamam de análise
### exploratória dos dados, ou EDA (Exploratory Data Analysis) abreviamente. EDA é um 
### ciclo iterativo. Você:

### 1 - Gera questões sobre os seus dados.
### 2 - Encontra respostas visualizando, transformando e modelando seus dados.
### 3 - Usa o que aprendeu para refinar suas questões e/ou gerar novas questões.

### A EDA não é um processo formal com um conjunto estrito de regras. Mais que 
### qualquer coisa, EDA é um estado da mente. Durante as fases inicias da EDA
### você deverá se sentir livre para investigar cada ideia que ocorre a você.
### Algumas dessas ideias darão certo e outras serão becos sem saída. À medida 
### que sua exploração continua, você se concentrará em alguns insights 
### particularmente produtivos que eventualmente escreverá e comunicará 
### a outras pessoas.

### A EDA é uma parte importante de qualquer análise de dados, mesmo que 
### as principais questões de pesquisa sejam entregues a você de bandeja,
### porque você sempre precisa investigar a qualidade dos seus dados. Limpeza
### de dados é apenas uma das aplicações da EDA: você se questiona sobre se
### seus dados vão de encontro às suas expectativas ou não. Para fazer limpeza
### de dados, você irá necessitar implementar todas as ferramentas da EDA:
### visualização, transformação e modelagem.

# Pré-requisitos ---------------------------------------------------------------------------------------------------------------------------

### Nesse capítulo, nós iremos combinar o que você tem aprendido sobre dplyr e 
### ggplot2 para fazer perguntas interativamente, respondê-las com dados e,
### sem seguida, fazer novas perguntas.

library(tidyverse)

# Questões ---------------------------------------------------------------------------------------------------------------------------------

### "Não existem questões estatísticas rotineiras, apenas rotinas estatísticas 
### questionáveis.” -Sir David Cox 

### "É muito melhor uma resposta aproximada à pergunta certa, que muitas 
### vezes é vaga, do que uma resposta exata à pergunta errada, que sempre 
### pode ser precisa." - John Tukey.

### Seu objetivo durante a EDA é desenvolver uma compreensão dos seus dados. 
### A maneira mais fácil de fazer isso é usar perguntas como ferramentas para
### orientar sua investigação. Quando você faz uma pergunta, ela concentra 
### sua atenção em uma parte específica do seu conjunto de dados e ajuda 
### você a decidir quais gráficos, modelos ou transformações fazer.

### EDA é fundamentalmente um processo criativo. E como a maioria dos processos
### criativos, a chave para fazer perguntas de qualidade é gerar uma grande 
### quantidade de perguntas. É difícil fazer perguntas reveladoras no início da sua 
### análise porque você não sabe quais insights podem ser obtidos do seu 
### conjunto de dados.aspecto dos seus dados e aumentar suas chances de fazer uma 
### descoberta. Você pode detalhar rapidamente as partes mais interessantes dos seus 
### dados — e desenvolver um conjunto de perguntas instigantes - se você 
### acompanhar cada pergunta com uma nova pergunta com base no que encontrar.

### Não há regra sobre quais perguntas você deve fazer para orientar sua 
### pesquisa. No entanto, dois tipos de perguntas sempre serão úteis para 
### fazer descobertas em seus dados. Você pode formular essas perguntas 
### livremente como:

### - Que tipo de variação ocorre dentro das minhas variáveis?
### - Que tipo de covariação ocorre entre as minhas variáveis?

### O restante deste capítulo examinará essas duas questões. Explicaremos o 
### que são variação e covariação e mostraremos várias maneiras de responder 
### a cada pergunta.

# Variação ---------------------------------------------------------------------------------------------------------------------------------

### Variação é a tendência dos valores de uma variável mudar de medida para medida.
### Você pode ver variações facilmente na vida real; se você medir qualquer
### variável contínua duas vezes, você obterá dois diferentes resultados.
### Isso é verdade mesmo se você mede quantidades constantes, como a velocidade
### da luz. Cada uma de suas medidas irá incluir uma pequena quantidade de
### de erro que varia de medida a medida. Variáveis também muda se você mede
### diferentes objetos (por exemplo, cor dos olhos de diferentes pessoas) ou diferentes
### tempos (por exemplo, os níveis de energia de um elétron em diferentes momentos).
### Cada variável tem seu próprio padrão de variação, que pode revelar interessantes
### informações sobre como isso varia entre medições na mesma observação, bem como 
### entre observações.A melhor forma de entender o padrão é visualizando a distribuição
### dos valores da variável, que você tem aprendido sobre no capítulo 1.

### Vamos iniciar nossa exploração visualizando a variação nos pesos (quilate) 
### de ~54,000 diamantes do pacote 'dados'. Como quilate é uma variável numérica, 
### podemos usar um histograma.

library(dados)

ggplot(diamante, aes(x = quilate)) +
  geom_histogram(binwidth = 0.5)

### Agora que você pode visualizar a variação, o que você deve observar em seus gráficos?
### E que tipo de perguntas de acompanhamento você deve fazer? Nós temos colocado abaixo
### uma lista dos tipos mais comuns de informações que você encontrará em seus gráficos,
### junto com algumas perguntas de acompanhamento para cada tipo de informação. A chave
### para fazer boas questões de acompanhamento irá depender da curiosidade (o que mais você
### quer aprender?) bem como do seu ceticismo (Como isso pode ser enganoso?).

# Valores típicos --------------------------------------------------------------------------------------------------------------------------

### Em ambos gráficos de barras e histogramas, barras altas mostram valores comuns
### de uma variável, e barras mais curtas mostram valores menos comuns. Locais que
### não tem barras revelam valores que não foram vistos nos seus dados. Para transformar
### essas informações em perguntas úteis, observe qualquer coisa não esperada:

### - Quais valores são os mais comuns? Por quê?
### - Quais valores são raros? Por quê? Isso corresponde às suas expectativas?
### - Você consegue ver padrões incomuns? O que pode explicar eles?

### Vamos observar a distribuição de quilate para pequenos diamantes:

menores_diamantes <- diamante |> 
  filter(quilate < 3)

ggplot(menores_diamantes, aes(x = quilate)) +
  geom_histogram(binwidth = 0.01)

### Esse histograma sugere várias questões interessantes:

### - Por que há mais diamantes em números inteiros de quilates e frações 
### comuns de quilates?
### - Por que há mais diamantes ligeiramente à direita de cada pico do que 
### há ligeiramente à esquerda de cada pico?

### Visualizações também podem revelar agrupamentos, os quais sugerem que existem
### subgrupos em seus dados. Para entender os subgrupos, questione:

### - Como são as observações dentro de cada subgrupo similares uns aos outros?
### - Como são as observações em grupos diferentes separados uns dos outros?
### - Como você pode explicar ou descrever os grupos?
### - Por que a aparência de agrupamentos pode ser enganadora?

### Algumas dessas questões podem ser respondidas com os dados, enquanto outras 
### irão requerer experiência de domínio sobre os dados. Muitas delas irão levar
### você a explorar a relação entre variáveis, por exemplo, para ver se os valores
### de uma variável podem explicar o comportamento de outra variável. Chegaremos
### a isso em breve.

# Valores atípicos -------------------------------------------------------------------------------------------------------------------------

### Outliers são observações atípicas, pontos de dados que não estão ajustados
### ao padrão. Algumas vezes outliers são erros de entrada de dados. Algumas vezes
### são apenas valores extremos que passaram a ser observados nesta coleta de dados,
### e outras vezes, eles sugerem importantes novas descobertas.Quando você tem 
### muitos dados, outliers são algumas vezes difícies de serem vistos em histogramas.
### outliers em histogramas. Por exemplo, pegue a distribuição da variável y do 
### conjunto de dados de diamante. A única evidência de valores discrepantes são 
### os limites incomumente amplos no eixo x.

ggplot(diamante, aes(x = y)) + 
  geom_histogram(binwidth = 0.5)

### Há muitas observações nas caixas comuns que as caixas raras são muito curtas,
### tornando muito difícil vê-las (embora talvez se você olhar atentamente 
### para 0 você encontre algo).Para facilitar a visualização dos valores incomuns, 
### precisamos ampliar para os valores pequenos do eixo y com coord_cartesian():

ggplot(diamante, aes(x = y)) + 
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

### coord_cartesian() também possui um argumento xlim() para quando você 
### precisar ampliar o eixo x. ggplot2 também possui as funções xlim() e ylim() 
### que funcionam de maneira um pouco diferente: elas jogam fora os dados fora 
### dos limites.

### Isso nos permite ver que existem três valores incomuns: 0, ~30 
### e ~60. Nós retiramos eles com dplyr:

incomum <- diamante |> 
  filter(y < 3 | y > 20) |> 
  select(preco, x, y, z) |>
  arrange(y)
incomum

### A variável y mede uma das três dimensões desses diamantes, em mm. 
### Sabemos que os diamantes não podem ter largura de 0 mm, então esses 
### valores devem estar incorretos. Ao fazer EDA, descobrimos dados 
### faltantes codificados como 0, que nunca teríamos encontrado 
### simplesmente procurando por NAs.do a diantes, nós podemos escolher
### recodificar estes valores como NAs, a fim de evitar cálculos enganosos. 
### Também podemos suspeitar que as medidas de 32 mm e 59 mm são implausíveis: 
### esses diamantes têm mais de uma polegada de comprimento, mas não custam 
### centenas de milhares de dólares!

### É uma boa prática repetir suas análises com e sem valores discrepantes. 
### Se eles tiverem um efeito mínimo nos resultados e você não conseguir 
### descobrir por que estão ali, é razoável omiti-los e seguir em frente.
### No entanto, se eles tiverem um efeito substancial nos seus resultados,
### você não deve abandoná-los sem justificativa. Você precisará descobrir 
### o que os causou (por exemplo, um erro de entrada de dados) e divulgar 
### que os removeu em seu artigo.

# Lidando com valores atípicos -------------------------------------------------------------------------------------------------------------

### Se você encontrou valores atípicos no seu conjunto de dados e simplesmente
### deseja prosseguir com o restante das suas análises, você tem duas opções:

### 1 - Eliminar a linha inteira com os valores estranhos:

diamante2 <- diamante |> 
  filter(between(y, 3, 20))

### Não recomendamos esta opção porque um valor inválido não implica que todos 
### os outros valores para essa observação também sejam inválidos. Além disso, 
### se você tiver dados de baixa qualidade, ao aplicar essa abordagem a todas 
### as variáveis, você poderá descobrir que não tem mais dados!

### 2 - Ao invés, nós recomendamos substituir os valores atípicos por valores
### faltantes (missing values). O caminho mais fácil para fazer isso, é usar a função
### mutate() para substituir os valores atípicos da variável.Você também pode
### usar o if_else() para substituir os valores atípicos por NA:

diamante2 <- diamante |> 
  mutate(y = if_else(y < 3 | y > 20, NA, y))

### Não é óbvio onde você deve traçar os valores ausentes, então o ggplot2 não 
### inclui os valores ausentes no gráfico, mas avisa que eles 
### foram removidos:

ggplot(diamante2, aes(x = x, y = y)) + 
  geom_point()

### Para suprimir esse aviso, defina na.rm = TRUE:

ggplot(diamante2, aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

### Outras vezes, você deseja entender o que torna as observações com valores 
### ausentes diferentes das observações com valores registrados. Por exemplo, 
### em nycflights13::flights1, valores ausentes na variável dep_time indicam 
### que o voo foi cancelado. Então, você pode querer comparar os horários 
### de partida programados para horários cancelados e não cancelados. Você 
### pode fazer isso criando uma nova variável, usando is.na() para verificar 
### se dep_time está faltando.

dados::voos |> 
  mutate(
    cancelado = is.na(horario_saida),
    hora_programada = saida_programada %/% 100,
    min_programado = saida_programada %% 100,
    saida_programada = hora_programada + (min_programado / 60)
  ) |> 
  ggplot(aes(x = saida_programada)) + 
  geom_freqpoly(aes(color = cancelado), binwidth = 1/4)

### No entanto, este gráfico não é bom porque há muito mais voos não 
### cancelados do que voos cancelados. Na próxima seção exploraremos algumas 
### técnicas para melhorar essa comparação.

# Covariação -------------------------------------------------------------------------------------------------------------------------------

### Se variação descreve o comportamento dentro de uma variável, covariação descreve
### o comportamento entre variáveis. Covariação é a tendência em que os valores de
### duas ou mais variáveis variam juntas de maneira relacionada. O melhor caminho
### para ver a covariação é visualizar a relação entre duas ou mais variáveis.

### Uma variável categórica e uma numérica: -----------------

### Por exemplo, vamos explorar como o preço do diamante varia com a qualidade dele
### (medida pelo corte) usando geom_frenqpoly():

ggplot(diamante, aes(x = preco)) + 
  geom_freqpoly(aes(color = corte), binwidth = 500, linewidth = 0.75)

### Note que o ggplot2 usa uma escala de cor ordenada para corte porque ele está definido
### como um fator ordenado nos dados. Você irá aprender mais sobre isso na seção 16.6.

### A aparência padrão de geom_freqpoly() não é tão útil aqui porque a altura, 
### determinada pela contagem geral, difere muito entre os cortes, tornando difícil 
### ver as diferenças nas formas de suas distribuições.

### Para fazer a comparação mais fácil nós necessitamos trocar o que está no eixo y.
### Ao invés da contagem (frequência), nós iremos exibir a densidade (density), que
### é a contagem padronizada para que a área sob cada polígono de frequência seja um.

ggplot(diamante, aes(x = preco, y = after_stat(density))) + 
  geom_freqpoly(aes(color = corte), binwidth = 500, linewidth = 0.75)

### Note que nós estamos mapeando a densidade para o eixo y, mas como density não
### é uma variável do banco de dados diamante, nós precisamos primeiro calcular ela.
### Nós usamos a função afer_stat() para fazer isso.

### Há algo bastante surpreendente neste gráfico - parece que os diamantes razoáveis 
### (de qualidade mais baixa) têm o preço médio mais alto! Mas talvez seja porque 
### os polígonos de frequência são um pouco difíceis de interpretar – há muita 
### coisa acontecendo neste gráfico.

### Um gráfico visualmente mais simples para explorar essa relação são os boxplot
### lado a lado.

ggplot(diamante, aes(x = corte, y = preco)) +
  geom_boxplot()

### Agora nós vemos muito menos informações sobre a distribuição, mas os boxplots
### são muito mais compactos então nós podemos mais facilmente comparar eles
### (e se ajusta mais em um gráfico). Isto apoia a descoberta 
### contra-intuitiva de que diamantes de melhor qualidade são normalmente mais 
### baratos! Nos exercícios, você será desafiado a descobrir o porquê.

### corte é um fator ordenado: razoável é pior que bom, que por suas vez é pior que
### muito bom e assim por diante. Muitas variáveis categóricas não tem uma ordem
### intrínseca, então você pode querer reordenar elas para tornar uma exibição
### mais informativa.
### Um caminho para isso é usar a fct_reorder(). Você irá aprender mais sobre essa
### função na seção 16.4, mas nós queremos dar a você uma rápida pré-visualização do uso
### dela. Por exemplo, pegue a variável classe dos dados milhas. Você pode estar 
### interessado em saber como a quilometragem da rodovia varia entre as classes:

ggplot(milhas, aes(x = classe, y = rodovia)) +
  geom_boxplot()

### Para tornar a tendência mais fácil de visualizar, nós podemos reordenar as classes
### baseado no valor mediano de rodovia:

ggplot(milhas, aes(x = fct_reorder(classe, rodovia, median), y = rodovia)) +
  geom_boxplot()

### Se você tem nomes longos de variáveis, geom_boxplot() irá trabalhar melhor se você
### virar em 90º. Você pode fazer isso trocando os eixos x e y.

ggplot(milhas, aes(x = rodovia, y = fct_reorder(classe, rodovia, median))) +
  geom_boxplot()

### Duas variáveis categóricas: -------------------------------

### Para visualizar a covariação entre variáveis categóricas, você irá necessitar
### contar o número de observações para cada combinação dos níveis dessas variáveis
### categóricas. Uma maneira de fazer isso é contar com o geom_count() integrado:

ggplot(diamante, aes(x = corte, y = cor)) +
  geom_count()

### O tamanho de cada círculo no gráfico exibe quantas observações ocorrem em cada
### combinação de valores. A covariação aparecerá como uma forte correlação entre
### valores específicos de x e valores específicos de y.

### Outra abordagem para explorar a relação entre essas variáveis é calcular as
### contagens com dplyr:

diamante |> 
  count(cor, corte)

### Em seguida, visualize com geom_tile() e a estética (aesthetic) de preechimento:

diamante |> 
  count(cor, corte) |>  
  ggplot(aes(x = cor, y = corte)) +
  geom_tile(aes(fill = n))

### Se as variáveis categóricas não estão ordenadas, você pode querer usar o pacote de 
### seriação para reordenar simultaneamente as linhas e colunas para revelar padrões
### interessantes com mais clareza. Para gráficos maiores, você pode querer usar o
### pacote heatmaply, que cria gráficos interativos.

### Duas variáveis numéricas: -------------------------------------------

### Você já viu uma ótima maneira de visualizar a covariação entre duas variáveis 
### numéricas: desenhar um gráfico de dispersão com geom_point(). Você pode ver a
### covariação com um padrão dos pontos. Por exemplo, você pode ver uma relação positiva
### entre quilate e preço do diamante: diamantes com mais quilates tem preços
### mais altos. A relação é exponencial.

menores_diamantes <- diamante |> 
  filter(quilate < 3)

ggplot(menores_diamantes, aes(x = quilate, y = preco)) +
  geom_point()

### (Nesta seção usaremos o conjunto de dados menor para manter o foco na 
### maior parte dos diamantes menores que 3 quilates)

### Gráficos de dispersão se tornam menos usuais à medida que seu conjunto
### de dados cresce, porque os pontos se acumulam, e se amontoam em áreas 
### de preto uniforme, tornando difícil julgar diferenças na densidade dos
### dados em torno do espaço bidimensional, bem como difícil de ver alguma 
### tendência. Você já tem visto uma forma de corrigir esse problema: usando
### a estética (aesthetic) alpha para adicionar transparência.

ggplot(menores_diamantes, aes(x = quilate, y = preco)) + 
  geom_point(alpha = 1 / 100)

### Mas usar transparência pode ser desafiador para conjunto de dados grandes.
### Outra solução é usar intervalos (bins). Previamente, você usou geom_histogram() e 
### geom_freqpoly() para bin em uma dimensão. Agora você irá aprender como usar
### geom_bin2d() e geom_hex() para bins em duas dimensões.

### geom_bin2d() e geom_hex() divide o plano de coordenadas em bins 2D e então
### usa um preenchimento de cor para exibir quantos pontos caem em cada bin.
### geom_bin2d() cria bins retangulares e geom_hex() cria bins hexagonais.
### Você irá necessitar instalar o pacote hexbin para usar geom_hex().

ggplot(menores_diamantes, aes(x = quilate, y = preco)) +
  geom_bin2d()

# install.packages("hexbin")
ggplot(menores_diamantes, aes(x = quilate, y = preco)) +
  geom_hex()

### Outra opção é agrupar uma variável contínua para que ela atue como uma variável 
### categórica. Então você usa uma das técnicas para visualizar a combinação
### de uma variável categórica e uma contínua que você aprendeu antes. Por exemplo,
### você poderia categorizar a variável quilate, e então para cada grupo exibir um 
### boxplot:

ggplot(menores_diamantes, aes(x = quilate, y = preco)) + 
  geom_boxplot(aes(group = cut_width(quilate, 0.1)))

### cut_width(x, width), conforme usado acima, divide x em compartimentos de 
### largura (width). Por padrão, os boxplots parecem praticamente os mesmos 
### (exceto pelo número de valores discrepantes) independentemente de 
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
### - A relação muda se você observar subgrupos individuais dos dados?

### Os padrões nos seus dados revelam pistas sobre as relações, por exemplo, 
### eles revelam covariação.Se pensarmos na variação como um fenômeno que cria incerteza, covariação é
### um fenômeno que reduz ela. Se duas variáveis covariam, você pode usar os valores
### de uma variável para fazer melhores previsões sobre os valores da segunda. Se a
### covariação é uma relação causal (um caso especial), então você pode usar o valor
### de uma variável para controlar o valor da segunda.

### Os modelos são ferramentas para extrair padrões dos dados. Por exemplo, considere
### os dados diamantes. É difícil entender a relação entre corte e preço, porque corte
### e quilate, e quilate e preço são intimamente relacionados. É possível usar o modelo
### para remover a forte relação entre preço e quilate, então nós podemos explorar as
### complexidades que permanecem. O seguinte código ajusta o modelo que prediz preço de
### quilate e então calcula os resíduos (a diferença entre o valor predito e o valor real).
### Os resíduos nos dão uma visão do preço do diamante, uma vez que o efeito do quilate
### tem sido removido. Note que ao invés de usar os valores das linhas de preço e quilate,
### nós transformamos em log primeiro, e ajustamos o modelo aos valores transformados
### em log. Depois, exponenciamos os resíduos para colocá-los de volta na escala de 
### preços brutos.

library(tidymodels)

diamante <- diamante |>
  mutate(
    log_preco = log(preco),
    log_quilate = log(quilate)
  )

diamante_fit <- linear_reg() |>
  fit(log_preco ~ log_quilate, data = diamante)

diamante_aug <- augment(diamante_fit, new_data = diamante) |>
  mutate(.resid = exp(.resid))

ggplot(diamante_aug, aes(x = quilate, y = .resid)) + 
  geom_point()

### Uma vez que você tem removido a forte relação entre quilate e preço,
### você pode ver o esperado da relação entre corte e preço: relativo ao
### tamanho deles, diamantes de melhor qualidade (corte) são mais caros.

ggplot(diamante_aug, aes(x = corte, y = .resid)) + 
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





