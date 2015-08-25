#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Air Gases: ggplot2 multiple columns
#  File: Air Gases.R
#  Enrique Pérez Herrero
#  25/Ago/2015
#  ----------------------------------------------------------------------------

library(reshape2)
library(ggplot2)

data <- "
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

df <- read.delim(textConnection(data), sep = "")
df$Date <- as.Date(df$Date, "%Y-%m-%d")

df <- melt(df, id.vars = "Date")

ggplot(df, aes(Date, value, col = variable)) + 
    ylab("Gas") + 
    #geom_line() +
    stat_smooth(method = loess) +
    scale_colour_hue(
        labels=c(expression(NO[2]),
                 expression(SO[2]),
                 expression(O[3])
                 )) +
    # Remove legend title
    theme(legend.title = element_blank())
    

