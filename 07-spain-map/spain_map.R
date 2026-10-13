#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Spain Map: population density by province (choropleth with sf)
#  File: spain_map.R
#  Enrique Pérez Herrero
#  02/Sep/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript spain_map.R  (needs an internet connection)
#  Province boundaries are downloaded by mapSpain from Eurostat GISCO
#  (© EuroGeographics for the administrative boundaries) and cached locally.
#  Population: mapSpain::pobmun19, INE municipal register 2019.

library(dplyr)
library(ggplot2)
library(sf)
library(mapSpain)

# Population by province, adding up the municipalities
population <- mapSpain::pobmun19 |>
    group_by(cpro) |>
    summarise(population = sum(pob19))

# Areas are measured on the real geometry: with moveCAN = TRUE the Canary
# Islands are shifted next to the peninsula, which would distort their area.
areas <- esp_get_prov(moveCAN = FALSE, resolution = "20") |>
    mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6) |>
    st_drop_geometry() |>
    select(cpro, area_km2)

provinces <- esp_get_prov(moveCAN = TRUE, resolution = "20") |>
    left_join(population, by = "cpro") |>
    left_join(areas, by = "cpro") |>
    mutate(density = population / area_km2)

p_spain <- ggplot(provinces) +
    geom_sf(aes(fill = density), colour = "white", linewidth = .2) +
    geom_sf(data = esp_get_can_box(), colour = "grey50") +
    scale_fill_viridis_c(trans = "log10", labels = scales::label_comma(),
                         name = "Inhabitants\nper km²") +
    labs(title = "Population density by province, Spain 2019",
         caption = "Data: INE municipal register 2019 · Boundaries: © EuroGeographics (GISCO)") +
    theme_void()

ggsave("spain_map.png", p_spain, width = 8, height = 6, dpi = 100, bg = "white")
