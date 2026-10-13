#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Function plot no data.
#  File: Function-Plot.R
#  Enrique Pérez Herrero
#  02/Sep/2015
#  ----------------------------------------------------------------------------

library(ggplot2)

my_labels <- expression(0, pi / 2, pi, 3 * pi / 2, 2 * pi)

line_size <- .5

ggplot(data.frame(x = c(0, 2 * pi)), aes(x)) +
    stat_function(fun = sin, colour = "red", linewidth = line_size) +
    stat_function(fun = cos, colour = "blue", linewidth = line_size) +
    scale_x_continuous(breaks = 0:4 * pi / 2,
                       labels = my_labels) +
    ylab("f(x)")
