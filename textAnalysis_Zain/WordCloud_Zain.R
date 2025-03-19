# Install and load necessary packages
required_packages <- c("syuzhet", "tm", "dplyr", "tidytext", "stringr", 
                       "tidyverse", "wordcloud", "ggplot2", "RColorBrewer")

new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

# Load libraries
lapply(required_packages, library, character.only = TRUE)

# Clear the environment
rm(list = ls())

# Set working directory
working_dir <- "~/Documents/r_projects/textanalysis/data"
setwd(working_dir)

# Load cleaned tokenized data (assuming df_words exists already)
df_words <- read.csv("clean_data.csv", stringsAsFactors = FALSE)

# Create a word frequency table
word_freq <- df_words %>%
  count(word, sort = TRUE)

# Display top 10 most frequent words (optional)
head(word_freq, 10)

# Generate the word cloud
set.seed(1234)  # for reproducibility
wordcloud(words = word_freq$word,
          freq = word_freq$n,
          min.freq = 50,
          max.words = 200,
          random.order = FALSE,
          rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))

# Optional: Add a title to your plot
title(main = "Word Cloud of Consumer Complaints")
