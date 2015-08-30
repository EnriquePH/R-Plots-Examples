
my_sequence <- "A095996"



OEIS_bFile <- function(seq){
    return(paste("b", substr(seq, 2, nchar(seq)), ".txt", sep = ""))
}


OEIS_bFile(my_sequence)

OEIS_sequence_url <- function(seq, bFile = FALSE){
    OEIS_url <- "http://oeis.org"
    if(bFile){
        return(paste(OEIS_url, seq, OEIS_bFile(seq), sep = "/"))
        } else {
            return(paste(OEIS_url, seq, sep = "/"))
        }
}
    
OEIS_sequence_url(my_sequence)
OEIS_sequence_url(my_sequence, bFile = TRUE)

