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

# Salva resultado
save(dfinal, file = "dfinal.Rda")
