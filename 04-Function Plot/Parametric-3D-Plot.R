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
X <- function(t) 2 * t
Y <- function(t) t^2
Z <- function(t) 10 * cos(t / 10)

t <- min_time:max_time
DF <- data.frame(t = t, x = X(t), y = Y(t), z = Z(t))

# Use manipulate with RStudio
manipulate({
    lines3D(x = DF$x, y = DF$y, z = DF$z)
    scatter3D(x = DF$x[t], y = DF$y[t], z = DF$z[t], add = TRUE)
}, t = slider(min_time, max_time))
