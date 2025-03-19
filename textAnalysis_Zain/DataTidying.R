# Install and load required packages
required_packages <- c("syuzhet", "tm", "dplyr", "tidytext", 
                       "stringr", "tidyverse", "wordcloud", "ggplot2")

# Install missing packages
new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

# Load libraries
invisible(lapply(required_packages, library, character.only = TRUE))

# Clear current environment
rm(list = ls())

# Set working directory and file path
working_dir <- "~/Documents/r_projects/textanalysis/data"
setwd(working_dir)

# Load the dataset
complaints_data <- read.csv("Consumer_Complaints.csv", stringsAsFactors = FALSE)

# Filter dataset: keep only non-empty narratives
narratives_clean <- complaints_data %>%
  filter(!is.na(Consumer.complaint.narrative),
         Consumer.complaint.narrative != "") %>%
  select(Consumer.complaint.narrative)

# Text cleaning: remove punctuation, digits, and extra whitespace
narratives_clean <- narratives_clean %>%
  mutate(clean_text = Consumer.complaint.narrative %>%
           str_replace_all("[[:punct:]]", "") %>%
           str_replace_all("[[:digit:]]", "") %>%
           str_squish())

# Remove common stopwords from the text
narratives_clean <- narratives_clean %>%
  mutate(clean_text = removeWords(clean_text, stop_words$word))

# Tokenize the cleaned text into individual words
tokens <- narratives_clean %>%
  unnest_tokens(word, clean_text)

# Filter out placeholders like 'XXXX', 'XXX', etc.
tokens_filtered <- tokens %>%
  filter(!str_detect(word, "^x+$"))

# Export cleaned tokenized data to a new CSV
output_file <- file.path(working_dir, "clean_data.csv")
write.csv(tokens_filtered, output_file, row.names = FALSE)

# Message to confirm successful export
message("Cleaned data has been saved to: ", output_file)
