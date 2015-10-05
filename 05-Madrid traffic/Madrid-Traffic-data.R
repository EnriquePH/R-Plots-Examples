#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Madrid Traffic data: ggplot2 multiple columns
#  File: Madrid-Traffic-data.R
#  Enrique Pérez Herrero
#  04/Oct/2015
#  ----------------------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

read_excel_allsheets <- function(filename) {
    sheets <- readxl::excel_sheets(filename)
    x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
    names(x) <- sheets
    x
}


my_url <- "http://datos.madrid.es/egob/catalogo/207831-2-accidentes-trafico.xls"

xls_accidentes <- read_excel_allsheets("03_accidentes_por_tipo_y_dia_semana_2013.xls")


df_2010 <- as.data.frame(xls_accidentes[2010 - 2009 + 1]) %>%
    select(-X2010..10) %>%
    na.omit() %>%
    filter(!grepl("Total", X2010.03..ACCIDENTES.POR.TIPO.Y.DIA.SEMANA)) %>%
    filter(!grepl("Dia Semana", X2010.03..ACCIDENTES.POR.TIPO.Y.DIA.SEMANA))

df_2010 <- t(df_2010)
rownames(df_2010) <- NULL
View(df_2010)

colnames(df_2010) <- df_2010[1, ]
colnames(df_2010)[[1]] <- "TIPO"

df_2010 <- df_2010[-1, ]
df_2010 <- as.data.frame(df_2010)

View(df_2010)