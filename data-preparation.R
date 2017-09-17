# This script prepares the text corpus for structural topic modeling using the stm R
# package.
# 
# Script by:      Jose Don T. De Alban
# Date created:   16 Sept 2017
# Date modified:  


# Search Terms Used ------------------------------

# The following search terms were used to extract relevant studies in the Web of Science
# database:

# TOPIC: (Myanmar OR Burma) AND
# TOPIC: (“land grab*” OR “land acquisition*” OR “land acquir*” OR “land dispossess*")


# Load Libraries ---------------------------------

library(pdftools)   # Package for text mining
library(tm)         # Package for text extraction, rendering, converting PDF documents


# Set Working Directories ------------------------

# Clear the working environment
rm(list = ls(all=TRUE))

## Set the working directories
getwd() # Ensure working directory is the R project directory
pdfMMR <- "./pdf/mmr/" # Directory of pdf files for Myanmar
setwd(pdfMMR)


# Loading Texts ----------------------------------

# Create vector of PDF file names
filesMMR <- list.files(pattern = "pdf$")
print(filesMMR)

# Extract text from PDF files
textMMR <- lapply(filesMMR, pdf_text)

# Create corpus
corpMMR <- VCorpus(VectorSource(textMMR))
summary(corpMMR)

# Make original PDF file names as column headers
names(corpMMR) <- filesMMR

# Execute transformations 
corpMMR <- tm_map(corpMMR, removePunctuation, preserve_intra_word_dashes = TRUE)
corpMMR <- tm_map(corpMMR, removeNumbers)
corpMMR <- tm_map(corpMMR, tolower)
corpMMR <- tm_map(corpMMR, removeWords, stopwords("english"))

# length(stopwords("english"))
# stopwords("english")

for (j in seq(corpMMR))
{
  corpMMR[[j]] <- gsub("land grab", "land_grab", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land grabs", "land_grabs", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land grabbing", "land_grabbing", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land acquisition", "land_acquisition", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land acquisitions", "land_acquisitions", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land acquired", "land_acquired", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land dispossession", "land_dispossession", corpMMR[[j]])
  corpMMR[[j]] <- gsub("land dispossessions", "land_dispossessions", corpMMR[[j]])
  corpMMR[[j]] <- gsub("\n", " ", corpMMR[[j]])
  #corpMMR[[j]] <- gsub('references.*"', ' ",', corpMMR[[j]])
}

corpMMR <- tm_map(corpMMR, stripWhitespace)
corpMMR <- tm_map(corpMMR, PlainTextDocument)

# Save transformed corpus into text file
sink("stm-corpMMR-inspect7.txt", append=FALSE, split=TRUE)
print(writeLines(as.character(corpMMR)))
sink()

# Things to do:
# How to remove references/biobliography section of a paper from the corpus?
# How to remove spaces for words that have been split?
# How to remove long urls?

# Preprocess Data --------------------------------

# Create term-document matrix
#tdmMMR <- TermDocumentMatrix(corpMMR, 
#                             control = list(removePunctuation = TRUE, 
#                                            preserve_intra_word_dashes = TRUE,
#                                            topwords = TRUE, 
#                                            tolower = TRUE, 
#                                            stemming = TRUE, 
#                                            removeNumbers = TRUE,
#                                            removeWords = TRUE, stopwords("english"),
#                                            bounds = list(global = c(3, Inf))))
tdmMMR <- DocumentTermMatrix(corpMMR)
tdmMMR <- TermDocumentMatrix(corpMMR)

inspect(tdmMMR[1:10,1:5]) # [No. of terms, No. of documents]



findFreqTerms(tdmMMR, lowfreq = 100, highfreq = Inf)


