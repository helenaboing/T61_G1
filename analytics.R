library(dplyr) # Manipular dataframes: filter(), select(), mutate(), group_by(), summarise()
library(lubridate) # Trabalhar com datas: ymd(), today(), now(), interval(), day(), month(), year()
library(ggplot2) # Criar gráficos: ggplot(), geom_point(), geom_line(), geom_bar(), etc.
library(tidyr) # Organizar dados: pivot_longer(), pivot_wider(), separate(), unite()
library(readr) # Ler ficheiros CSV e texto: read_csv(), read_delim(), write_csv()
library(readxl) # Ler ficheiros Excel: read_excel(), excel_sheets()
library(tinytex) # Gerar PDFs a partir de RMarkdown ou Quarto
library(scales) # Formatação de números: comma(), percent()


# ---- Preparação dos Dados ----
# Adicionar variáveis necessárias para análise
dfinal <- dfinal %>%
    # Criar faixa etária
    mutate(
        FaixaIdade = cut(
            Idade,
            breaks = c(0, 18, 30, 45, 60, 150),
            labels = c("0-18", "19-30", "31-45", "46-60", "60+"),
            right = FALSE
        ),
        # Calcular lucro por venda
        Lucro = SalesAmount - (StandardCost * OrderQuantity),
        # Adicionar informações de tempo
        Trimestre = paste0("Q", quarter(OrderDate), " ", year(OrderDate)),
        Weekday = wday(OrderDate, label = TRUE, abbr = FALSE, locale = "pt_BR")
    )

# ---- Análise Demográfica dos Clientes ----
# Distribuição etária
ggplot(dfinal, aes(x = Idade)) +
    geom_histogram(binwidth = 5, fill = "#2c7bb6", color = "white") +
    labs(title = "Histograma da Idade dos Clientes", x = "Idade", y = "Frequência")

# Estatísticas de idade
mean(dfinal$Idade, na.rm = TRUE)
median(dfinal$Idade, na.rm = TRUE)

# ---- Análise de Vendas por Gênero ----
vendas_por_genero <- dfinal %>%
    group_by(Gender) %>%
    summarise(
        Total_Vendas = sum(SalesAmount, na.rm = TRUE),
        Media_Vendas = mean(SalesAmount, na.rm = TRUE),
        .groups = "drop"
    )

ggplot(vendas_por_genero, aes(x = Gender, y = Total_Vendas, fill = Gender)) +
    geom_bar(stat = "identity") +
    labs(title = "Total de Vendas por Gênero", y = "Total de Vendas")

# ---- Análise de Relação Idade vs. Vendas ----
idade_vendas <- dfinal %>%
    group_by(CustomerKey, Idade) %>%
    summarise(TotalGasto = sum(SalesAmount, na.rm = TRUE), .groups = "drop")

ggplot(idade_vendas, aes(x = Idade, y = TotalGasto)) +
    geom_point(alpha = 0.6, color = "#2c7bb6") +
    geom_smooth(method = "lm", color = "#d7191c") +
    labs(
        title = "Relação entre Idade e Valor Gasto",
        x = "Idade",
        y = "Valor Gasto (USD)"
    ) +
    theme_minimal()

# ---- Análise de Comportamento de Compra ----
# Taxa de recompra
clientes_recompra <- dfinal %>%
    group_by(CustomerKey) %>%
    summarise(NumCompras = n_distinct(SalesOrderNumber)) %>%
    filter(NumCompras >= 2) %>%
    nrow()

taxa_recompra <- (clientes_recompra / n_distinct(dfinal$CustomerKey)) * 100

# Tempo médio entre compras
tempo_medio <- dfinal %>%
    group_by(CustomerKey) %>%
    filter(n() >= 2) %>%
    summarise(
        PrimeiraCompra = min(OrderDate),
        UltimaCompra = max(OrderDate),
        NumCompras = n()
    ) %>%
    mutate(
        DiasEntreCompras = as.numeric(difftime(UltimaCompra, PrimeiraCompra, units = "days")),
        TempoMedio = DiasEntreCompras / (NumCompras - 1)
    ) %>%
    summarise(TempoMedioGlobal = mean(TempoMedio, na.rm = TRUE))

# Taxa de churn
total_clientes_todos <- n_distinct(dfinal$CustomerKey)
clientes_uma_compra <- dfinal %>%
    group_by(CustomerKey) %>%
    summarise(n_compras = n()) %>%
    filter(n_compras == 1) %>%
    nrow()

churn_rate <- (clientes_uma_compra / total_clientes_todos) * 100

# ---- Análise de Produtos ----
# Produtos mais vendidos
best_sellers <- dfinal %>%
    group_by(ProductKey, ProductName) %>%
    summarise(
        TotalQuantity = sum(OrderQuantity, na.rm = TRUE),
        TotalSales = sum(SalesAmount, na.rm = TRUE),
        .groups = "drop"
    ) %>%
    arrange(desc(TotalQuantity))

# Top 10 produtos
top10 <- best_sellers %>%
    arrange(desc(TotalQuantity)) %>%
    slice_head(n = 10)

# Gráfico de top 10
ggplot(top10, aes(x = reorder(ProductName, TotalQuantity), y = TotalQuantity)) +
    geom_bar(stat = "identity", fill = "darkgreen") +
    coord_flip() +
    labs(
        title = "Top 10 Produtos Mais Vendidos",
        x = "Produto",
        y = "Quantidade Vendida"
    ) +
    theme_minimal() +
    theme(
        text = element_text(size = 12),
        plot.title = element_text(face = "bold", hjust = 0.5)
    )

# ---- Análise Temporal de Vendas ----
# Vendas por Trimestre
vendas_trimestrais <- dfinal %>%
    group_by(Trimestre) %>%
    summarise(TotalVendas = sum(SalesAmount, na.rm = TRUE), .groups = "drop") %>%
    # Para manter a ordem cronológica correta no eixo X
    mutate(Trimestre = factor(Trimestre, levels = unique(Trimestre)))

# Gráfico de vendas trimestrais
ggplot(vendas_trimestrais, aes(x = Trimestre, y = TotalVendas, group = 1)) +
    geom_line(color = "blue", size = 1) +
    geom_point(color = "darkblue") +
    labs(
        title = "Volume de Vendas por Trimestre",
        x = "Trimestre",
        y = "Total de Vendas"
    ) +
    scale_y_continuous(labels = comma) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Vendas por Dia da Semana
vendas_por_dia <- dfinal %>%
    group_by(Weekday) %>%
    summarise(TotalVendas = sum(SalesAmount, na.rm = TRUE), .groups = "drop") %>%
    # Ordenar dias da semana corretamente
    mutate(Weekday = factor(Weekday,
        levels = c(
            "domingo", "segunda-feira", "terça-feira", "quarta-feira",
            "quinta-feira", "sexta-feira", "sábado"
        )
    ))

# Gráfico de vendas por dia da semana
ggplot(vendas_por_dia, aes(x = Weekday, y = TotalVendas)) +
    geom_col(fill = "steelblue") +
    labs(
        title = "Total de Vendas por Dia da Semana",
        x = "Dia da Semana",
        y = "Valor Total de Vendas"
    ) +
    scale_y_continuous(labels = comma) +
    theme_minimal()

# ---- Análise de Lucro por Categoria ----
lucro_categoria <- dfinal %>%
    group_by(ProductCategoryName) %>%
    summarise(LucroTotal = sum(Lucro, na.rm = TRUE)) %>%
    arrange(desc(LucroTotal))

# ---- Análise de Cohorte ----
# Preparar dados para análise de coorte
cohort_data <- dfinal %>%
    group_by(CustomerKey) %>%
    summarise(PrimeiraCompra = min(OrderDate, na.rm = TRUE), .groups = "drop") %>%
    left_join(dfinal, by = "CustomerKey") %>%
    mutate(
        CohortMonth = floor_date(PrimeiraCompra, "month"),
        OrderMonth = floor_date(OrderDate, "month"),
        CohortIndex = interval(CohortMonth, OrderMonth) %/% months(1) + 1
    )

# Calcular retenção por coorte
cohort_retention <- cohort_data %>%
    group_by(CohortMonth, CohortIndex) %>%
    summarise(UsuariosAtivos = n_distinct(CustomerKey), .groups = "drop")

cohort_sizes <- cohort_retention %>%
    filter(CohortIndex == 1) %>%
    select(CohortMonth, UsuariosAtivos) %>%
    rename(CohortSize = UsuariosAtivos)

cohort_retention <- cohort_retention %>%
    left_join(cohort_sizes, by = "CohortMonth") %>%
    mutate(Retencao = UsuariosAtivos / CohortSize)

# Visualizar análise de coorte
ggplot(cohort_retention, aes(x = CohortIndex, y = CohortMonth, fill = Retencao)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "#deebf7", high = "#3182bd", labels = scales::percent) +
    geom_text(aes(label = scales::percent(Retencao, accuracy = 1)), size = 3, color = "black") +
    labs(
        title = "Cohort Analysis: Retenção de Clientes",
        x = "Meses desde a 1ª compra",
        y = "Cohorte (Mês da 1ª compra)",
        fill = "Retenção"
    ) +
    theme_minimal()

dfinal <- dfinal %>%
    mutate(
        FaixaIdade = cut(
            Idade,
            breaks = c(0, 18, 30, 45, 60, 150),
            labels = c("0-18", "19-30", "31-45", "46-60", "60+"),
            right = FALSE
        ),
        Lucro = SalesAmount - (StandardCost * OrderQuantity),
        Trimestre = paste0("Q", quarter(OrderDate), " ", year(OrderDate)),
        Weekday = wday(OrderDate, label = TRUE, abbr = FALSE, locale = "pt_BR")
    )

save(dfinal, file = "dfinal.Rda")
