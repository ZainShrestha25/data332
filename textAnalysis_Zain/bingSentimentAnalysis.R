# Install and load necessary packages
required_packages <- c("syuzhet", "tm", "lubridate", "dplyr", "tidytext", 
                       "stringr", "tidyverse", "wordcloud", "ggplot2")

new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
if (length(new_packages)) install.packages(new_packages)

# Load libraries
lapply(required_packages, library, character.only = TRUE)

# Clear environment
rm(list = ls())

# Set working directory and read cleaned tokenized data
working_dir <- "~/Documents/r_projects/textanalysis/data"
setwd(working_dir)

# Load the cleaned data
df_words <- read.csv("clean_data.csv", stringsAsFactors = FALSE)

# --- Sentiment Analysis: Bing Lexicon ---

# Analysis 1: Sentiment scores over grouped indexes
bing_sentiment_scores <- df_words %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(index_group = row_number() %/% 80) %>%
  count(index_group, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(net_sentiment_score = positive - negative)

# Plot sentiment scores
ggplot(bing_sentiment_scores, aes(index_group, net_sentiment_score)) +
  geom_col(fill = "#FF7F0E") +
  labs(title = "Sentiment Score Over Grouped Complaints (Bing Lexicon)",
       x = "Index Group (every 80 words)",
       y = "Net Sentiment Score (Positive - Negative)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))

# Interpretation:
# If most sentiment scores are negative, complaints tend to be negative in tone.


# Analysis 2: Proportion of Positive vs Negative Words
bing_sentiment_proportion <- df_words %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  count(sentiment) %>%
  mutate(proportion = n / sum(n))

# Plot sentiment proportion as a pie chart
ggplot(bing_sentiment_proportion, aes(x = "", y = proportion, fill = sentiment)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y") +
  theme_void() +
  labs(title = "Proportion of Sentiments in Consumer Complaints (Bing Lexicon)") +
  scale_fill_manual(values = c("positive" = "#2CA02C", "negative" = "#D62728")) +
  theme(legend.title = element_blank())

# Interpretation:
# This pie chart shows the proportion of positive vs negative sentiment words across all complaints.
