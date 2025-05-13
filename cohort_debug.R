# COHORT RETENTION DEBUG SCRIPT
library(dplyr)
library(lubridate)

# Load the data
load("dfinal.Rda")

# 1. Identify first purchase date for each customer
primeiras_compras <- dfinal %>%
  group_by(CustomerKey) %>%
  summarise(PrimeiraCompra = min(OrderDate), .groups = "drop")

# 2. Add cohort month and relative month to each purchase
cohort_data <- dfinal %>%
  inner_join(primeiras_compras, by = "CustomerKey") %>%
  mutate(
    CohortMonth = format(floor_date(PrimeiraCompra, "month"), "%Y-%m"),
    MesRelativo = (year(OrderDate) - year(PrimeiraCompra)) * 12 +
                  (month(OrderDate) - month(PrimeiraCompra))
  )

# 3. For each customer, cohort, and month, count purchases
compras_por_mes <- cohort_data %>%
  group_by(CohortMonth, CustomerKey, MesRelativo) %>%
  summarise(NumCompras = n(), .groups = "drop")

# 4. For month 0, only count customers with NumCompras > 1
#    For months > 0, count customers with NumCompras > 0
compras_por_mes <- compras_por_mes %>%
  mutate(
    Recompra = case_when(
      MesRelativo == 0 ~ NumCompras > 1,
      MesRelativo > 0 ~ NumCompras > 0,
      TRUE ~ FALSE
    )
  )

# 5. Cohort size
cohort_sizes <- cohort_data %>%
  filter(MesRelativo == 0) %>%
  group_by(CohortMonth) %>%
  summarise(CohortSize = n_distinct(CustomerKey), .groups = "drop")

# 6. Retention calculation
cohort_retention <- compras_por_mes %>%
  filter(Recompra) %>%
  group_by(CohortMonth, MesRelativo) %>%
  summarise(ClientesRetidos = n_distinct(CustomerKey), .groups = "drop") %>%
  left_join(cohort_sizes, by = "CohortMonth") %>%
  mutate(Retencao = ClientesRetidos / CohortSize)

# DEBUG: Print for a single cohort and month 0
cat("\nDEBUG: Cohort sizes\n")
print(cohort_sizes)
cat("\nDEBUG: Month 0 retention\n")
print(cohort_retention %>% filter(MesRelativo == 0))
cat("\nDEBUG: All retention values (first 20 rows)\n")
print(head(cohort_retention, 20))

# If you want to see the full table:
# print(cohort_retention) 