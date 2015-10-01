#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  Turbines and manufacturers
#  File: turbines_manufacturers.R
#  Enrique Pérez Herrero
#  29/Sep/2015
#  ----------------------------------------------------------------------------

library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)


# Get the data
data.url <- "http://www.thewindpower.net/turbines_manufacturers_en.php"

doc <- htmlParse(data.url)

data <- readHTMLTable(doc,
                      colClasses = c("character", "character", "character"),
                      trim = TRUE,
                      which = 6
                      )
# Remove empty rows
data <- filter(data, Country != "")

View(data)

# Write data into csv file
write.table(data,
            file = "turbines_manufacturers_en.csv",
            col.names = NA,
            sep = ",")


# Plot Number of Turbine Manufacturers by Country
plot.data <- data %>%
    group_by(Country) %>%
    summarise(Freq = n()) %>%
    mutate(Country = factor(Country, levels = rev(levels(Country))))

View(plot.data)

# A bar graph
# http://stackoverflow.com/questions/32160646/sort-country-names-in-ggplot2-bar-plot
ggplot(plot.data, aes(Country , Freq,  fill = Country)) + 
    coord_flip() +
    geom_bar(stat = "identity", width = .90) + 
    xlab("") + # Set axis labels
    ylab("") + 
    guides(fill = FALSE) +
    ggtitle("Number of Turbine Manufacturers by Country") + 
    theme_minimal()


plot.data2 <- data %>%
    separate(col = Remark,
             into = c("Text", "Year"),
             sep = " \\(",
             remove = TRUE,
             extra = "merge",
             fill = "right") %>%
    mutate(Year, Year = gsub("\\)", "", Year)) %>%
    mutate(Year, Year = gsub("\\#NA", NA , Year))

View(plot.data2)

plot.data3 <- plot.data2 %>%
    group_by(Text) %>%
    summarise(Freq = n())

View(plot.data3)

# A pie chart = stacked bar chart + polar coordinates
ggplot(plot.data3, aes(x = factor(1), y = Freq, fill = Text)) +
    geom_bar(width = 1, stat = "identity") +
    xlab("") +
    ylab("") + 
    coord_polar(theta = "y") +
    scale_fill_brewer(palette ="Blues") +
    theme_minimal() +
    theme(
        axis.title.x = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid=element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank()
        ) +
    geom_text(aes(y = Freq/2 + c(0, cumsum(Freq)[-length(Freq)]), 
                  label = percent(Freq / sum(Freq))), size = 5)
    #scale_y_continuous(labels = percent_format())


plot.data4 <- plot.data2 %>%
    filter(!is.na(Year) & (Text == "Acquired" | Text == "No longer exists")) %>%
    group_by(Year, Text) %>%
    summarise(Freq = n())


View(plot.data4)

ggplot(plot.data4, aes(x = as.numeric(Year), y = Freq, colour = Text)) +
    geom_point()
