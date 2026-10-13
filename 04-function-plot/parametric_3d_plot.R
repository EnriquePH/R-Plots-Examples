#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Parametric 3D curve with an interactive time slider (RStudio only).
#  File: Parametric-3D-Plot.R
#  Enrique Pérez Herrero
#  14/Sep/2016
#  ----------------------------------------------------------------------------

library(manipulate)
library(plot3D)

min_time <- 1
max_time <- 100

# Time parametric functions
x_t <- function(t) 2 * t
y_t <- function(t) t^2
z_t <- function(t) 10 * cos(t / 10)

t <- min_time:max_time
curve <- data.frame(t = t, x = x_t(t), y = y_t(t), z = z_t(t))

# Use manipulate with RStudio
manipulate({
    lines3D(x = curve$x, y = curve$y, z = curve$z)
    scatter3D(x = curve$x[t], y = curve$y[t], z = curve$z[t], add = TRUE)
}, t = slider(min_time, max_time))
