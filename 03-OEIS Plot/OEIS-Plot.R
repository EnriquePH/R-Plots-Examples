#  ----------------------------------------------------------------------------
#  R PLOTS EXAMPLES
#  OEIS Sequences Plot.
#  File: OEIS-Plot.R
#  Enrique Pérez Herrero
#  31/Ago/2015
#  ----------------------------------------------------------------------------

library(ggplot2)


OEIS_bFile <- function(seq){
    # Returns the bFile name associated to a OEIS sequence
    #
    # Args:
    #   seq: OEIS sequence Id, consist on the letter A and 6 digits 
    #
    # Returns:
    #    A string with the OEIS' bFile name.
    return(paste("b", substr(seq, 2, nchar(seq)), ".txt", sep = ""))
}


OEIS_sequence_url <- function(seq, bFile = FALSE){
    # Returns bFile or sequence url in OEIS
    #
    # Args:
    #   seq: OEIS sequence Id
    #   bFile: if TRUE returns bfile url, and sequence url otherwise 
    #
    # Returns:
    #    A string with the OEIS url required
    OEIS_url <- "http://oeis.org"
    if(bFile){
        # bFile url
        return(paste(OEIS_url, seq, OEIS_bFile(seq), sep = "/"))
        } else {
            # Sequence url
            return(paste(OEIS_url, seq, sep = "/"))
        }
}


# Dedekind Psi Function

my_sequence <- "A001615"
OEIS_bFile(my_sequence)
  
OEIS_sequence_url(my_sequence)
my_bFile <- OEIS_sequence_url(my_sequence, bFile = TRUE)

data <- read.csv(my_bFile,
                 header = FALSE,
                 sep = " ",
                 col.names = c("n", my_sequence)
                 )
<<<<<<< HEAD
View(data)

ggplot(data, aes(x = n, y = eval(parse(text = my_sequence)))) +
    geom_point(size = .1, colour = "red") +
    ylab(my_sequence)
=======
>>>>>>> 401e7b142ab00da520527b230024c324774b055e

View(data)

ggplot(data, aes(x = n, y = A001615)) +
    geom_point(size = .1, colour = "red") 
    
    
