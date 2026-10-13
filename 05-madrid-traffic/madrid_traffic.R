#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Madrid Traffic data: reading a multi-sheet Excel file
#  File: madrid_traffic.R
#  Enrique Pérez Herrero
#  04/Oct/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript madrid_traffic.R
#  Data: Madrid city council open data portal, traffic accidents by type and
#  weekday, one sheet per year (2009-2014).
#  http://datos.madrid.es/egob/catalogo/207831-2-accidentes-trafico.xls

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

xls_file <- "03_accidentes_por_tipo_y_dia_semana_2013.xls"

weekdays_es <- c("LUNES", "MARTES", "MIERCOLES", "JUEVES",
                 "VIERNES", "SABADO", "DOMINGO")


read_year_sheet <- function(sheet) {
    # Reads one yearly sheet of the Excel file
    #
    # Sheets have a title block, a "Tipo Accidente" row with the accident types
    # and one row per weekday, but not always in the same rows (2013 is
    # shifted), so rows are located by their content.
    #
    # Returns:
    #   A long data frame with columns Year, Weekday, Type and Accidents.
    raw <- read_excel(xls_file, sheet = sheet, col_names = FALSE,
                      col_types = "text", .name_repair = "minimal")
    first_col <- trimws(raw[[1]])
    types     <- unlist(raw[which(first_col == "Tipo Accidente"), -1])
    keep      <- !is.na(types) & types != "Total"

    raw[first_col %in% weekdays_es, c(TRUE, keep)] |>
        setNames(c("Weekday", types[keep])) |>
        mutate(Weekday = trimws(Weekday)) |>
        pivot_longer(-Weekday, names_to = "Type", values_to = "Accidents") |>
        mutate(Year = as.integer(sheet), Accidents = as.integer(Accidents),
               .before = 1)
}

accidents <- excel_sheets(xls_file) |>
    lapply(read_year_sheet) |>
    bind_rows() |>
    mutate(Weekday = factor(Weekday, levels = weekdays_es),
           Type    = reorder(Type, -Accidents, sum))


# Plot: accidents by weekday for each accident type ---------------------------

p_accidents <- ggplot(accidents,
                      aes(Weekday, Accidents, colour = factor(Year), group = Year)) +
    geom_line() +
    facet_wrap(~ Type, scales = "free_y", ncol = 2) +
    scale_x_discrete(labels = substr(weekdays_es, 1, 2)) +
    scale_colour_viridis_d(end = .9) +
    labs(title = "Madrid traffic accidents by type and weekday",
         x = NULL, y = "Accidents", colour = "Year") +
    theme_minimal()

ggsave("madrid_traffic.png", p_accidents, width = 8, height = 9, dpi = 100, bg = "white")
