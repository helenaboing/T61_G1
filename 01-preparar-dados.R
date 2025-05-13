#
# compreender + preparar dados
#

# ----
# install.packages("tinytex") #(inst 1x) gerar PDFs a partir de documentos Quarto ou RMarkdown
# tinytex::install_tinytex() #(inst 1x) compilar documentos para PDF
# Sys.which("pdflatex") #(faz parte do TinyTeX)

library(dplyr) # Manipular dataframes: filter(), select(), mutate(), group_by(), summarise()
library(lubridate) # Trabalhar com datas: ymd(), today(), now(), interval(), day(), month(), year()
library(ggplot2) # Criar gráficos: ggplot(), geom_point(), geom_line(), geom_bar(), etc.
library(scales) # Formatação de números e percentagens: percent(), comma(), dollar()

library(tidyr) # Organizar dados: pivot_longer(), pivot_wider(), separate(), unite()
library(readr) # Ler ficheiros CSV e texto: read_csv(), read_delim(), write_csv()
library(readxl) # Ler ficheiros Excel: read_excel(), excel_sheets()
library(tinytex) # Gerar PDFs a partir de RMarkdown ou Quarto (instala TinyTeX com install_tinytex())

# ---- Load ficheiros .rda ----
load("geography.rda")
caminho <- getwd()
rda_files <- list.files(path = caminho, pattern = "\\.Rda$", full.names = TRUE)

for (file in rda_files) {
    load(file)
}

rm(caminho, file, rda_files)

# passa do disco rígido para RAM

# ---- customers: prepara dados ----
# Base R
customers <- customers[, !(names(customers) %in% c("Name", "AddressLine", "Phone"))]
# customers <- select(customers, -c("Name", "AddressLine", "Phone"))

# Corrige os fatores
customers$MaritalStatus <- factor(customers$MaritalStatus,
    levels = c("M", "S"),
    labels = c("Casado", "Solteiro")
)

customers$HouseOwnerFlag <- factor(customers$HouseOwnerFlag,
    levels = c(0, 1),
    labels = c("Não é proprietário", "É proprietário")
)

# Formata datas
customers$BirthDate <- as.Date(customers$BirthDate)
customers$DateFirstPurchase <- as.Date(customers$DateFirstPurchase)

# Calcula idade
current_date <- as.Date("2025-04-23")
customers$Idade <- floor(time_length(interval(customers$BirthDate, current_date), "years"))

# Cria categorias de rendimento
customers$TipoCliente <- cut(customers$YearlyIncome,
    breaks = c(-Inf, 30000, 60000, Inf),
    labels = c("Baixo", "Médio", "Alto")
)

# ---- geography: preparar dados ----
# Remove campos desnecessários
geography <- geography[, !(names(geography) %in% c(
    "SpanishCountryRegionName",
    "FrenchCountryRegionName",
    "PostalCode",
    "IpAddressLocator"
))]

# Renomeia para manter consistência em inglês
geography <- geography %>%
    rename(CountryRegionName = EnglishCountryRegionName)

# ---- products: preparar dados ----
# Remove campos redundantes já que temos as tabelas de categoria
products <- products[, !(names(products) %in% c("SubCategory", "Category"))]

# Formata datas
products$StartDate <- as.Date(products$StartDate)
products$EndDate <- as.Date(products$EndDate)

# ---- productCategory: preparar dados ----
# Mantém apenas nome em inglês
productCategory <- productCategory %>%
    select(ProductCategoryKey,
        ProductCategoryName = EnglishProductCategoryName
    )

# ---- productSubCategory: preparar dados ----
# Mantém apenas nome em inglês
productSubCategory <- productSubCategory %>%
    select(ProductSubcategoryKey,
        ProductCategoryKey,
        ProductSubcategoryName = EnglishProductSubcategoryName
    )

# ---- factSales: preparar dados ----
# Formata datas
factSales$OrderDate <- as.Date(factSales$OrderDate)

# ---- Cria tabela final ----
# Junta todas as tabelas relevantes
prod_total <- products %>%
    left_join(productSubCategory, by = c("ProductSubCategoryKey" = "ProductSubcategoryKey")) %>%
    left_join(productCategory, by = "ProductCategoryKey") %>%
    select(
        ProductKey, ProductName, StandardCost, Color, SafetyStockLevel,
        ListPrice, Size, Class, ModelName, Description, Status,
        ProductSubCategoryKey, ProductSubcategoryName,
        ProductCategoryKey, ProductCategoryName
    )

# Primeiro junta geography com territory
geo_territory <- geography %>%
    inner_join(territory, by = c("SalesTerritoryKey" = "Territory Key")) %>%
    select(-SalesTerritoryKey) # Remove a coluna duplicada

# Depois junta com as outras tabelas
dfinal <- factSales %>%
    inner_join(customers, by = "CustomerKey") %>%
    inner_join(geo_territory, by = "GeographyKey") %>%
    inner_join(prod_total, by = "ProductKey") %>%
    # Organiza as colunas em grupos lógicos
    select(
        # Informações da venda
        OrderDate, SalesOrderNumber, SalesOrderLineNumber,
        OrderQuantity, UnitPrice, SalesAmount, TaxAmt, Freight,
        # Informações do produto
        ProductKey, ProductName,
        ProductSubCategoryKey, ProductSubcategoryName,
        ProductCategoryKey, ProductCategoryName,
        StandardCost, Color, Size, Class, ModelName,
        # Informações do cliente
        CustomerKey, BirthDate, MaritalStatus, Gender, YearlyIncome,
        NumberChildrenAtHome, Occupation, HouseOwnerFlag, NumberCarsOwned,
        DateFirstPurchase, Idade, TipoCliente,
        # Informações geográficas
        City, StateProvinceName, CountryRegionName, Region, Country, Group
    )

# Cohort Analysis (first 12 months for clarity)
cohort_data <- dfinal %>%
    group_by(CustomerKey) %>%
    summarise(PrimeiraCompra = min(OrderDate, na.rm = TRUE), .groups = "drop") %>%
    left_join(dfinal, by = "CustomerKey") %>%
    mutate(
        CohortMonth = floor_date(PrimeiraCompra, "month"),
        OrderMonth = floor_date(OrderDate, "month"),
        CohortIndex = interval(CohortMonth, OrderMonth) %/% months(1) + 1
    ) %>%
    filter(CohortIndex <= 12) # Show only first 12 months

cohort_retention <- cohort_data %>%
    group_by(CohortMonth, CohortIndex) %>%
    summarise(UsuariosAtivos = n_distinct(CustomerKey), .groups = "drop") %>%
    left_join(
        cohort_data %>%
            group_by(CohortMonth) %>%
            summarise(CohortSize = n_distinct(CustomerKey), .groups = "drop"),
        by = "CohortMonth"
    ) %>%
    mutate(Retencao = UsuariosAtivos / CohortSize)

ggplot(cohort_retention, aes(x = CohortIndex, y = CohortMonth, fill = Retencao)) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "#deebf7", high = "#3182bd", labels = percent) +
    geom_text(aes(label = percent(Retencao, accuracy = 1)), size = 3, color = "black") +
    labs(
        title = "Análise de Cohorte: Retenção de Clientes",
        x = "Meses desde a 1ª compra",
        y = "Cohorte (Mês da 1ª compra)",
        fill = "Retenção"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Top 10 Produtos Mais Vendidos
top10 <- dfinal %>%
    group_by(ProductKey, ProductName) %>%
    summarise(TotalQuantity = sum(OrderQuantity, na.rm = TRUE), .groups = "drop") %>%
    slice_max(TotalQuantity, n = 10) %>%
    arrange(TotalQuantity)

ggplot(top10, aes(x = reorder(ProductName, TotalQuantity), y = TotalQuantity)) +
    geom_col(fill = "darkgreen") +
    coord_flip() +
    labs(
        title = "Top 10 Produtos Mais Vendidos",
        x = "Produto",
        y = "Quantidade Vendida"
    ) +
    theme_minimal() +
    theme(
        text = element_text(size = 14),
        plot.title = element_text(face = "bold", hjust = 0.5)
    )

# Salva resultado
save(dfinal, file = "dfinal.Rda")
