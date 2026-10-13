# R-Plots-Examples
#
#   make            Regenerate every PNG plot
#   make <folder>   Regenerate the plots of one example, e.g. make 02-air-gases
#   make lint       Check R style with lintr (settings in .lintr)
#   make style      Reformat R scripts with styler (4-space indent)
#   make install    Install the R packages used by the examples (system libraries
#                   for sf: see README)
#   make clean      Delete the generated PNG plots
#
# 04-function-plot/parametric_3d_plot.R (RStudio only) and 06-network/network.R
# (interactive HTML widget) are not run by make.

RSCRIPT  := Rscript --no-save --no-restore
PACKAGES := "dplyr", "tidyr", "ggplot2", "scales", "rvest", "jsonlite", \
            "readxl", "plot3D", "manipulate", "networkD3", "sf", "mapSpain", "lintr", "styler"

WIND    := $(addprefix 01-wind-energy/turbine_manufacturers_by_,country.png status.png year.png)
GASES   := 02-air-gases/air_gases.png
OEIS    := 03-oeis-plot/oeis_plot.png
FUNC    := 04-function-plot/function_plot.png
MADRID  := 05-madrid-traffic/madrid_traffic.png
SPAIN   := 07-spain-map/spain_map.png
PLOTS   := $(WIND) $(GASES) $(OEIS) $(FUNC) $(MADRID) $(SPAIN)

.PHONY: all lint style install clean \
        01-wind-energy 02-air-gases 03-oeis-plot 04-function-plot 05-madrid-traffic \
        07-spain-map

all: $(PLOTS)

01-wind-energy:    $(WIND)
02-air-gases:      $(GASES)
03-oeis-plot:      $(OEIS)
04-function-plot:  $(FUNC)
05-madrid-traffic: $(MADRID)
07-spain-map:      $(SPAIN)

# Each script writes its PNGs into its own folder; the grouped target (&:)
# runs the wind-energy script once for its three plots.
$(WIND) &: 01-wind-energy/turbines_manufacturers.R 01-wind-energy/turbines_manufacturers_en.csv
	cd $(@D) && $(RSCRIPT) $(<F)

$(GASES): 02-air-gases/air_gases.R
	cd $(@D) && $(RSCRIPT) $(<F)

$(OEIS): 03-oeis-plot/oeis_plot.R
	cd $(@D) && $(RSCRIPT) $(<F)

$(FUNC): 04-function-plot/function_plot.R
	cd $(@D) && $(RSCRIPT) $(<F)

$(MADRID): 05-madrid-traffic/madrid_traffic.R 05-madrid-traffic/03_accidentes_por_tipo_y_dia_semana_2013.xls
	cd $(@D) && $(RSCRIPT) $(<F)

$(SPAIN): 07-spain-map/spain_map.R
	cd $(@D) && $(RSCRIPT) $(<F)

lint:
	$(RSCRIPT) -e 'l <- lintr::lint_dir("."); print(l); quit(status = length(l) > 0)'

style:
	$(RSCRIPT) -e 'styler::style_dir(".", transformers = styler::tidyverse_style(indent_by = 4))'

install:
	S2_FORCE_BUNDLED_ABSEIL=false $(RSCRIPT) -e 'install.packages(c($(PACKAGES)), repos = "https://cloud.r-project.org")'

clean:
	rm -f $(PLOTS)
