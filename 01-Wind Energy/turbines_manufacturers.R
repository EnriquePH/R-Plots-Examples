# Turbines and manufacturers


library(XML)
library(dplyr)
library(ggplot2)

data_url <- "http://www.thewindpower.net/turbines_manufacturers_en.php"

doc <- htmlParse(data_url)

data <- readHTMLTable(doc,
                      colClasses = c("character","character","character"),
                      trim = TRUE,
                      which = 6
                      )

data <- filter(data, Country != "")

View(data)

# Write data into csv file
write.table(data,
            file = "turbines_manufacturers_en.csv",
            col.names = NA,
            sep=",")


# Plot Number of Turbine Manufacturers by Country

plot_data <- data %>%
    group_by(Country) %>%
    summarise(Freq = n()) %>%
    mutate(Country = factor(Country, levels = rev(levels(Country))))


# A bar graph
# http://stackoverflow.com/questions/32160646/sort-country-names-in-ggplot2-bar-plot
ggplot(plot_data, aes(Country , Freq,  fill=Country)) + 
    coord_flip() +
    geom_bar(stat="identity", width=.90) + 
    xlab("") + # Set axis labels
    ylab("") + 
    guides(fill=FALSE) +
    ggtitle("Number of Turbine Manufacturers by Country") + 
    theme_minimal()

