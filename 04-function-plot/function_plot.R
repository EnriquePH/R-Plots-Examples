#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Function plot no data.
#  File: function_plot.R
#  Enrique Pérez Herrero
#  02/Sep/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript function_plot.R

library(ggplot2)

pi_labels <- expression(0, pi / 2, pi, 3 * pi / 2, 2 * pi)

line_width <- .8

p_functions <- ggplot(data.frame(x = c(0, 2 * pi)), aes(x)) +
    stat_function(aes(colour = "sin(x)"), fun = sin, linewidth = line_width) +
    stat_function(aes(colour = "cos(x)"), fun = cos, linewidth = line_width) +
    scale_x_continuous(breaks = 0:4 * pi / 2, labels = pi_labels) +
    scale_colour_manual(values = c("sin(x)" = "red", "cos(x)" = "blue")) +
    labs(title = "Plotting functions without data", y = "f(x)", colour = NULL) +
    theme_minimal()

ggsave("function_plot.png", p_functions, width = 7, height = 4, dpi = 100, bg = "white")
