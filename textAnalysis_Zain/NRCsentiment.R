required_packages <- c("syuzhet", "tm", "lubridate", "dplyr", "tidytext",
                      "stringr", "tidyverse", "wordcloud", "ggplot2")

installed_packages <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

lapply(required_packages, library, character.only = TRUE)

rm(list = ls())

df_words <- read.csv("clean_data.csv", stringsAsFactors = FALSE)

head(df_words)

sentiment_summary <- df_words %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  mutate(index_group = row_number() %/% 80) %>%
  count(index_group, sentiment) %>%
  pivot_wider(names_from = sentiment,
              values_from = n,
              values_fill = list(n = 0)) %>%
  mutate(sentiment_score = positive - negative)

ggplot(sentiment_summary, aes(x = index_group, y = sentiment_score)) +
  geom_col(fill = "steelblue") +
  labs(title = "Sentiment Analysis of Consumer Complaints",
       subtitle = "Net Sentiment Score by Grouped Complaints",
       x = "Index Group (Grouped Every 80 Complaints)",
       y = "Net Sentiment Score") +
  theme_minimal()

sentiment_proportion <- df_words %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  count(sentiment) %>%
  mutate(proportion = n / sum(n))

ggplot(sentiment_proportion, aes(x = "", y = proportion, fill = sentiment)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  theme_void() +
  labs(title = "Proportion of Sentiment in Consumer Complaints") +
  scale_fill_manual(values = c("positive" = "forestgreen", "negative" = "firebrick")) +
  theme(legend.title = element_blank())