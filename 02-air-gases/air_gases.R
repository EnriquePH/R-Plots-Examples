#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Air Gases: ggplot2 multiple columns
#  File: air_gases.R
#  Enrique Pérez Herrero
#  30/Ago/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript air_gases.R

library(dplyr)
library(tidyr)
library(ggplot2)

formula_expression <- function(formula) {
    # Turns a chemical formula such as "NO2" into the plotmath expression NO[2]
    x <- gsub("(\\d+)", "[\\1]*", formula)
    x <- sub("\\*$", "", x)
    parse(text = x)[[1]]
}


gases_text <- "
      Date       NO2         SO2          O3
2004-01-01  24.49864    2.756818    30.17857
2004-01-02  33.40000    3.912609    22.45514
2004-01-03  27.55435    5.654783    24.33342
2004-01-04  24.87391    8.910000    30.64569
2004-01-05  41.96348    10.893478   44.92825
2004-01-06  48.80913    13.417391   44.91305
2004-01-07  49.10217    16.808696   28.34968
2004-01-08  49.14217    26.273913   16.61955
2004-01-09  34.52261    8.438261    17.80235
2004-01-10  45.33087    7.955217    36.34493
"

# Load the data
gases <- read.table(text = gases_text, header = TRUE)

# Tidy the data: one row per date and gas
gases_long <- gases |>
    mutate(Date = as.Date(Date)) |>
    pivot_longer(-Date, names_to = "Gas", values_to = "Concentration")

# Plot the data, with subscripts in the legend labels (NO₂, SO₂, O₃)
gas_names  <- setdiff(names(gases), "Date")
gas_labels <- setNames(lapply(gas_names, formula_expression), gas_names)

p_gases <- ggplot(gases_long, aes(Date, Concentration, colour = Gas)) +
    geom_point(alpha = .5) +
    geom_smooth(method = "loess", formula = y ~ x) +
    scale_colour_hue(labels = gas_labels) +
    labs(title = "Air Gases Concentration", x = NULL, colour = NULL) +
    theme_minimal()

ggsave("air_gases.png", p_gases, width = 7, height = 4, dpi = 100, bg = "white")
