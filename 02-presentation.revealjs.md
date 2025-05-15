---
title: "Análise de Vendas e Clientes"
author: "Helena Boing, Alejandra Moreira, Joana Costa, Lohanna Pombo, Pedro Sequeira"
format: 
  revealjs:
    theme: default
    css: styles.css
    slide-number: true
    footer: "Análise de Vendas e Clientes"
    background-transition: fade
    transition: fade
    highlight-style: github
    code-fold: true
    code-tools: true
    code-link: true
    code-copy: true
    code-line-numbers: true
    code-highlight: true
    code-annotations: true
    code-echo: false
    code-eval: true
    code-warning: true
    code-error: true
    code-message: false
    code-output: true
    code-cache: true
    code-freeze: false
    width: 1050
    height: 700
    margin: 0.1
    center: false
    navigationMode: linear
    controlsLayout: edges
    controlsTutorial: false
    hash: true
    history: true
    hashOneBasedIndex: false
    fragmentInURL: false
    pdfSeparateFragments: false
    lang: en
    auto-stretch: true
    header-includes:
      - |
        <style>
          /* Geometric shapes in corners */
          .reveal .slides section::before {
            content: "";
            position: absolute;
            top: 20px;
            left: 20px;
            width: 100px;
            height: 100px;
            border: 2px solid rgba(70, 130, 180, 0.2);
            border-radius: 50%;
            z-index: -1;
          }
          
          .reveal .slides section::after {
            content: "";
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 80px;
            height: 80px;
            border: 2px solid rgba(70, 130, 180, 0.2);
            transform: rotate(45deg);
            z-index: -1;
          }
          
          /* Hexagon pattern in background */
          .reveal .slides section {
            background: 
              linear-gradient(60deg, rgba(70, 130, 180, 0.05) 25%, transparent 25.5%, transparent 75%, rgba(70, 130, 180, 0.05) 75%, rgba(70, 130, 180, 0.05)),
              linear-gradient(120deg, rgba(70, 130, 180, 0.05) 25%, transparent 25.5%, transparent 75%, rgba(70, 130, 180, 0.05) 75%, rgba(70, 130, 180, 0.05));
            background-size: 60px 104px;
            background-position: 0 0, 30px 52px;
          }
          
          /* Decorative lines */
          .reveal .slides section::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, 
              rgba(70, 130, 180, 0.2),
              rgba(70, 130, 180, 0.1),
              rgba(70, 130, 180, 0.2));
          }
          
          /* Title slide special styling */
          .reveal .slides section:first-child::before {
            width: 150px;
            height: 150px;
            border-width: 3px;
          }
          
          .reveal .slides section:first-child::after {
            width: 120px;
            height: 120px;
            border-width: 3px;
          }
          
          /* Ensure content remains readable */
          .reveal .slides section h1,
          .reveal .slides section h2,
          .reveal .slides section h3,
          .reveal .slides section p {
            position: relative;
            z-index: 1;
          }
        </style>
execute: 
  echo: false
  eval: true
  warning: true
  error: true
  message: false
  output: true
  cache: true
  freeze: false
---





## Maioria dos clientes tem 31–45 anos; gêneros igualmente representados


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-1-1.png){width=960}
:::
:::


## Estados Unidos e Austrália concentram a maior parte das vendas

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-2-1.png){width=960}
:::
:::


## Vendas são dominadas por Califórnia e estados australianos

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-3-1.png){width=960}
:::
:::


## Análise Específica dos Estados Unidos

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-4-1.png){width=960}
:::
:::


## Análise de Longevidade dos Clientes

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-5-1.png){width=960}
:::
:::


## Londres e Paris lideram amplamente o volume de vendas entre as cidades

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-6-1.png){width=960}
:::
:::


## Métricas Geográficas Principais

::: {.cell}
::: {.cell-output .cell-output-stdout}

```
Métricas Geográficas Principais:
```


:::

::: {.cell-output .cell-output-stdout}

```
Total de Países : 6 
Total de Regiões/Estados : 53 
Total de Cidades : 269 
País com Maior Volume : United States 
Região com Maior Volume : California 
Cidade com Maior Volume : London 
```


:::
:::


## Paris lidera densidade de clientes, superando amplamente outras regiões

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-8-1.png){width=960}
:::
:::


## Bikes dominam as vendas nas principais regiões

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-9-1.png){width=960}
:::
:::


## Potencial de Crescimento Regional: Identificação de Oportunidades Prioritárias

::: {.cell}

:::


::: {.smaller}
## Metodologia e Fatores de Avaliação

- **Número de Cidades** (40% do score)
  - Indica a cobertura geográfica e capacidade de expansão local

- **Ticket Médio** (30% do score)
  - Mede o valor médio das transações e poder de compra dos clientes

- **Vendas Anuais** (30% do score)
  - Avalia o volume de negócios e trajetória de crescimento

::: {.callout-note collapse="true"}
Score de Oportunidade = (0.4 × cidades normalizado) + (0.3 × ticket médio normalizado) + (0.3 × vendas por ano normalizado)
:::
:::



## Critérios e Oportunidades

- ✓ Mínimo de 1 ano de operação
- ✓ Dados normalizados para comparabilidade
- ✓ Agregação por região (país/estado)
- ✓ Filtro de operações recentes

- 🎯 **Regiões Líderes**: Mercados mais promissores para expansão e investimentos
- 📊 **Ranking Objetivo**: Facilita a alocação de recursos e decisões comerciais

## Califórnia e Inglaterra lideram em potencial de crescimento entre mercados analisados

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-12-1.png){width=960}
:::
:::


## Detalhes das Top 5 Regiões com Maior Potencial

::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Detalhes das Top 5 Regiões com Maior Potencial:
```


:::

::: {.cell-output .cell-output-stdout}

```

 California :
  Número de Cidades: 47 
  Ticket Médio: € 1,285.84 
  Vendas por Ano: € 1,853,959 
  Score de Oportunidade: 2.67 

 England :
  Número de Cidades: 34 
  Ticket Médio: € 1,772.98 
  Vendas por Ano: € 1,102,382 
  Score de Oportunidade: 1.81 

 New South Wales :
  Número de Cidades: 18 
  Ticket Médio: € 2,523.72 
  Vendas por Ano: € 1,276,522 
  Score de Oportunidade: 1.62 

 Victoria :
  Número de Cidades: 9 
  Ticket Médio: € 2,550.23 
  Vendas por Ano: € 742,342.3 
  Score de Oportunidade: 0.87 

 Washington :
  Número de Cidades: 24 
  Ticket Médio: € 1,090.26 
  Vendas por Ano: € 804,058.6 
  Score de Oportunidade: 0.86 
```


:::
:::


## Resumo de Penetração de Mercado

::: {.cell}
::: {.cell-output .cell-output-stdout}

```
Resumo de Penetração de Mercado:
```


:::

::: {.cell-output .cell-output-stdout}

```
Regiões com Alta Densidade : 23 
Regiões com Baixa Densidade : 30 
Categoria Mais Popular : Accessories 
Região com Maior Crescimento : California 
Ticket Médio Global : 486.0869 
Número Médio de Cidades por Região : 5.377358 
```


:::
:::


## Análise de Preço vs. Demanda por Produto


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-15-1.png){width=960}
:::
:::


## Métricas Resumidas por Categoria de Produto

::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Métricas por Categoria de Produto:
```


:::

::: {.cell-output-display}


Categoria      Preço Médio (€)   Qtd. Média   Vendas Totais (€)   Nº Produtos
------------  ----------------  -----------  ------------------  ------------
Bikes                  1451.11          123          22768247.9           111
Accessories              39.93         1114            448349.7            15
Clothing                 47.78          364            320084.5            19


:::
:::


## Distribuição Geográfica das Vendas


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-17-1.png){width=960}
:::
:::


::: {.smaller}
## Top 10 Cidades por Volume de Vendas

::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Top 10 Cidades por Volume de Vendas:
```


:::

::: {.cell-output-display}


Cidade        Estado/Província   País             Total de Vendas (€)    Nº de Clientes
------------  -----------------  ---------------  --------------------  ---------------
London        England            United Kingdom   802,810                           420
Paris         Seine (Paris)      France           539,726                           386
Wollongong    New South Wales    Australia        338,913                           105
Warrnambool   Victoria           Australia        327,036                           105
Bendigo       Victoria           Australia        314,569                           104
Goulburn      New South Wales    Australia        310,876                           106
Bellflower    California         United States    302,279                           194
Brisbane      Queensland         Australia        295,354                           106
Townsville    Queensland         Australia        285,487                           105
Geelong       Victoria           Australia        283,802                           106


:::
:::


:::

## Vendas aceleram fortemente a partir de Q2 2018

::: {.cell}
::: {.cell-output .cell-output-stderr}

```
Warning in annotate("text", x = Inf, y = -Inf, label = paste0("CAGR: ", :
Ignoring unknown parameters: `linewidth`
```


:::

::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-19-1.png){width=960}
:::
:::



## Vendas uniformemente distribuídas ao longo da semana

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-20-1.png){width=960}
:::
:::


## Visão Geral do Negócio

- Total de vendas: 29,358,677 €
- Número de clientes únicos: 18484
- Número de produtos vendidos: 158
- Período analisado: 01/07/2016 a 31/07/2019

## ATV em queda desde ago/2017


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-21-1.png){width=960}
:::

::: {.cell-output .cell-output-stdout}

```

ATV (Valor médio por transação) Geral: € 1,098.37
```


:::
:::


## Top 10 Produtos Mais Vendidos

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-22-1.png){width=960}
:::
:::


## A maioria dos lucros são gerados pela categoria de produtos "Bike"


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-23-1.png){width=960}
:::
:::


## Comportamento de Compra

### Taxa de Recompra


- Clientes com múltiplas compras: 6865
- Taxa de recompra: 37.1%
- Tempo médio entre compras: 69.7 dias


::: {.cell}

:::

## Retenção de Clientes - 2016 

![](02-presentation_files/figure-revealjs/unnamed-chunk-26-1.png){width=960}

## Retenção de Clientes - 2017 

![](02-presentation_files/figure-revealjs/unnamed-chunk-26-2.png){width=960}

## Retenção de Clientes - 2018 

![](02-presentation_files/figure-revealjs/unnamed-chunk-26-3.png){width=960}

## Retenção de Clientes - 2019 

![](02-presentation_files/figure-revealjs/unnamed-chunk-26-4.png){width=960}

## Margens por Categoria de Produto

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-27-1.png){width=960}
:::
:::


## Análise de Custos Operacionais

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-28-1.png){width=960}
:::
:::


## Eficiência Operacional por Região

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-29-1.png){width=960}
:::
:::


## Resumo de Rentabilidade e Eficiência

::: {.cell}
::: {.cell-output .cell-output-stdout}

```
Resumo de Rentabilidade e Eficiência:
```


:::

::: {.cell-output .cell-output-stdout}

```
Margem Bruta Média : 47.8 %
Margem Líquida Média : 37.3 %
Custo de Frete Médio : 2.500117 
Custo de Taxas Médio : 8 
Categoria Mais Rentável : Accessories 
Categoria Menos Rentável : Clothing 
Região Mais Eficiente : California 
```


:::
:::


## Análise de Rentabilidade por Categoria e Subcategoria


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-31-1.png){width=960}
:::
:::


## Crescimento de Vendas por Subcategoria


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-32-1.png){width=960}
:::
:::


## Análise de Crescimento Detalhada


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
Métricas de Crescimento:
```


:::

::: {.cell-output .cell-output-stdout}

```
Subcategorias em Crescimento: 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 
```


:::

::: {.cell-output .cell-output-stdout}

```
Subcategorias em Declínio: 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 
```


:::

::: {.cell-output .cell-output-stdout}

```
Crescimento Médio: 39.4 9.2 44 47.5 37.1 40.2 46.1 43.4 40.3 45.8 -4.4 -26.1 34.3 29 37.8 71.3 74.1 %
```


:::

::: {.cell-output .cell-output-stdout}

```
Crescimento Máximo: 39.4 9.2 44 47.5 37.1 40.2 46.1 43.4 40.3 45.8 -4.4 -26.1 34.3 29 37.8 71.3 74.1 %
```


:::

::: {.cell-output .cell-output-stdout}

```
Crescimento Mínimo: 39.4 9.2 44 47.5 37.1 40.2 46.1 43.4 40.3 45.8 -4.4 -26.1 34.3 29 37.8 71.3 74.1 %
```


:::
:::


## Top 10 Produtos por Crescimento de Lucro


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-34-1.png){width=960}
:::
:::


## Proporção de Clientes com e sem Filhos

::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-35-1.png){width=960}
:::
:::


## Distribuição Salarial por Ocupação


::: {.cell}
::: {.cell-output-display}
![](02-presentation_files/figure-revealjs/unnamed-chunk-36-1.png){width=960}
:::
:::


## Estatísticas Salariais das Top 5 Ocupações


::: {.cell}
::: {.cell-output .cell-output-stdout}

```


Ocupação          Mediana      Média   Mínimo   Máximo      Q1       Q3   Nº Clientes
---------------  --------  ---------  -------  -------  ------  -------  ------------
Management          90000   94157.07    40000   170000   70000   110000         10594
Professional        70000   76122.14    30000   170000   60000    90000         18995
Skilled Manual      50000   52288.06    10000    90000   40000    60000         14261
Clerical            30000   31548.21    10000    40000   30000    40000          9624
Manual              20000   16454.36    10000    30000   10000    20000          6924
```


:::
:::



