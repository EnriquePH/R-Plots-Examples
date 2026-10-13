# R-Plots-Examples

Small, self-contained R plotting examples for learning R with the tidyverse
(`dplyr`, `tidyr`, `ggplot2`) and a few interactive/3D packages.

| Folder | Script | What it shows | Extra packages |
|---|---|---|---|
| `01-Wind Energy` | `turbines_manufacturers.R` | Bar, pie and scatter plots of wind-turbine manufacturers by country, status and year | `scales`, `rvest` (only to refresh data) |
| `02-Air Gases` | `Air Gases.R` | Multiple series with LOESS smoothing and plotmath legend labels (NO₂, SO₂, O₃) | — |
| `03-OEIS Plot` | `OEIS-Plot.R` | Plotting an OEIS integer sequence from its b-file, metadata via the OEIS JSON API | `jsonlite` |
| `04-Function Plot` | `Function-Plot.R` | Plotting functions without data (`stat_function`) with π axis labels | — |
| `04-Function Plot` | `Parametric-3D-Plot.R` | Parametric 3D curve with a time slider (RStudio only) | `plot3D`, `manipulate` |
| `05-Madrid traffic` | `Madrid-Traffic-data.R` | Reading and reshaping a multi-sheet Excel file of Madrid traffic accidents | `readxl` |
| `06-Network` | `network.R` | Interactive network graph | `networkD3` |

## Usage

Run each script from its own folder, e.g.:

```sh
cd "01-Wind Energy"
Rscript turbines_manufacturers.R
```

Install everything at once:

```r
install.packages(c("dplyr", "tidyr", "ggplot2", "scales", "rvest", "jsonlite",
                   "readxl", "plot3D", "manipulate", "networkD3"))
```

`03-OEIS Plot` needs an internet connection.

## License

GPL-3.0 — see [LICENSE.txt](LICENSE.txt).
