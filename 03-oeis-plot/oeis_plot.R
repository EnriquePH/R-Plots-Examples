#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  OEIS Sequences Plot.
#  File: oeis_plot.R
#  Enrique Pérez Herrero
#  31/Ago/2015
#  ----------------------------------------------------------------------------
#
#  Run from this folder: Rscript oeis_plot.R  (needs an internet connection)

library(ggplot2)

oeis_url <- "https://oeis.org"

oeis_bfile_url <- function(seq_id) {
    # Returns the b-file url of an OEIS sequence
    #
    # Args:
    #   seq_id: OEIS sequence Id, the letter A followed by 6 digits
    #
    # Returns:
    #   A string such as "https://oeis.org/A001615/b001615.txt"
    paste0(oeis_url, "/", seq_id, "/b", substring(seq_id, 2), ".txt")
}

oeis_info <- function(seq_id) {
    # Returns the sequence metadata (name, first terms, comments...) as a list
    jsonlite::fromJSON(paste0(oeis_url, "/search?q=id:", seq_id, "&fmt=json"))
}


# Dedekind Psi function
my_sequence <- "A001615"

# The b-file holds "n a(n)" pairs, with optional "#" comment lines
seq_data <- read.table(oeis_bfile_url(my_sequence),
                       col.names = c("n", "value"),
                       comment.char = "#")

info <- oeis_info(my_sequence)

p_oeis <- ggplot(seq_data, aes(n, value)) +
    geom_point(size = .05, colour = "red") +
    labs(title = paste(my_sequence, info$name, sep = ": "),
         x = "n", y = paste0(my_sequence, "(n)")) +
    theme_minimal() +
    theme(plot.title = element_text(size = 11))

ggsave("oeis_plot.png", p_oeis, width = 7, height = 5, dpi = 100, bg = "white")


# Other metadata returned by the OEIS JSON API
first_terms <- as.numeric(strsplit(info$data, ",")[[1]])
print(first_terms)
cat(info$comment[[1]], sep = "\n")
