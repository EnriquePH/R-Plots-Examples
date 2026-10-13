#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Turbines and manufacturers
#  File: turbines_manufacturers.R
#  Enrique Pérez Herrero
#  29/Sep/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript turbines_manufacturers.R
#  By default the bundled CSV snapshot is used. Set `refresh_data <- TRUE` to
#  scrape the table again from thewindpower.net (the site layout may change).

library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

data_file    <- "turbines_manufacturers_en.csv"
data_url     <- "https://www.thewindpower.net/turbines_manufacturers_en.php"
refresh_data <- FALSE


# Get the data ----------------------------------------------------------------

scrape_manufacturers <- function(url) {
    # Downloads the manufacturers table from thewindpower.net
    #
    # Returns:
    #   A data frame with columns Name, Country and Remark.
    tables <- rvest::html_table(rvest::read_html(url))
    is_target <- vapply(tables,
                        function(t) all(c("Name", "Country", "Remark") %in% names(t)),
                        logical(1))
    if (!any(is_target)) stop("Manufacturers table not found at ", url)
    tables[[which(is_target)[1]]][, c("Name", "Country", "Remark")]
}

if (refresh_data || !file.exists(data_file)) {
    manufacturers <- scrape_manufacturers(data_url) |>
        mutate(across(everything(), trimws)) |>
        filter(Country != "")
    write.csv(manufacturers, data_file, row.names = FALSE)
}

manufacturers <- read.csv(data_file,
                          colClasses = "character",
                          na.strings = character(0)) |>
    select(Name, Country, Remark)


# Tidy the data ---------------------------------------------------------------

# Split "Acquired (2010)" into Status = "Acquired" and Year = 2010.
# An empty remark means the manufacturer is still active; "(#NA)" means no year.
manufacturers <- manufacturers |>
    extract(Remark,
            into = c("Status", "Year"),
            regex = "^(.*?)\\s*(?:\\((.*)\\))?$") |>
    mutate(Status = if_else(Status == "", "Active", Status),
           Year   = suppressWarnings(as.integer(Year)))


# Plot 1: Number of turbine manufacturers by country --------------------------

by_country <- manufacturers |>
    count(Country, name = "Freq") |>
    mutate(Country = reorder(Country, Freq))

p_country <- ggplot(by_country, aes(Freq, Country)) +
    geom_col(fill = "steelblue", width = .9) +
    scale_x_continuous(expand = expansion(mult = c(0, .05))) +
    labs(title = "Number of Turbine Manufacturers by Country", x = NULL, y = NULL) +
    theme_minimal()

ggsave("turbine_manufacturers_by_country.png", p_country,
       width = 7, height = 7, dpi = 100, bg = "white")


# Plot 2: Manufacturers by status (pie chart) ---------------------------------

# A pie chart = stacked bar chart + polar coordinates
by_status <- manufacturers |>
    count(Status, name = "Freq")

p_status <- ggplot(by_status, aes(x = factor(1), y = Freq, fill = Status)) +
    geom_col(width = 1) +
    geom_text(aes(label = percent(Freq / sum(Freq), accuracy = 1)),
              position = position_stack(vjust = .5), size = 5) +
    coord_polar(theta = "y") +
    scale_fill_brewer(palette = "Blues") +
    labs(title = "Turbine Manufacturers by Status", fill = NULL) +
    theme_void()

ggsave("turbine_manufacturers_by_status.png", p_status,
       width = 6, height = 5, dpi = 100, bg = "white")


# Plot 3: Acquisitions and closures per year ----------------------------------

by_year <- manufacturers |>
    filter(!is.na(Year), Status %in% c("Acquired", "No longer exists")) |>
    count(Year, Status, name = "Freq")

p_year <- ggplot(by_year, aes(Year, Freq, colour = Status)) +
    geom_point(size = 3) +
    scale_y_continuous(breaks = breaks_width(1), limits = c(0, NA)) +
    labs(title = "Acquisitions and Closures of Turbine Manufacturers",
         x = NULL, y = "Manufacturers", colour = NULL) +
    theme_minimal()

ggsave("turbine_manufacturers_by_year.png", p_year,
       width = 7, height = 4, dpi = 100, bg = "white")
