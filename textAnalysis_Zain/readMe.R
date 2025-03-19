
Introduction
In this analysis, I will leverage the tidytext package in R Studio to perform sentiment analysis on a dataset of consumer complaints. The goal is to evaluate the polarity of these complaints using both the NRC and Bing Lexicons, which will help uncover insights into the emotional tone expressed by consumers.

Dictionary
The primary column used for the analysis is:
  
  Consumer.complaint.narrative: This column contains the complaints submitted by consumers in their original format.
Data Cleaning
To begin the analysis, I first cleaned the data by removing any missing or empty values in the Consumer.complaint.narrative column. After this, only the relevant column was retained for further processing.

df_clean <- df %>% 
  filter(!is.na(Consumer.complaint.narrative) & Consumer.complaint.narrative != "") %>% 
  select(Consumer.complaint.narrative)
Data Pre-processing
Next, I performed data pre-processing to remove unnecessary elements from the complaints. This includes punctuation, digits, and extra spaces that may interfere with the analysis.

df_clean$Consumer.complaint.narrative <- df_clean$Consumer.complaint.narrative %>% 
  str_replace_all("[[:punct:]]", "") %>%  # remove punctuation
  str_replace_all("[[:digit:]]", "") %>%  # remove numbers
  str_squish()
Remove Stopwords
Stopwords such as "the," "an," "I," "me," and "you" were removed, as they do not add significant value to sentiment analysis. This allowed us to focus on more meaningful words within the complaints.

df_clean <- df_clean %>% 
  mutate(Consumer.complaint.narrative = removeWords(Consumer.complaint.narrative, stop_words$word))
Tokenization
The next step was tokenization, where the complaint texts were split into individual words (tokens). This helps analyze word frequency and identify the main sentiments expressed.

df_words <- df_clean %>% 
  unnest_tokens(word, Consumer.complaint.narrative)

# Remove custom unwanted words like "XXXX" or "XXXXX"
df_words <- df_words %>% 
  filter(!str_detect(word, "^x+$"))
Export to CSV File
Once the data was cleaned and tokenized, I exported the processed dataset to a CSV file for further analysis.

write.csv(df_words, "~/Documents/r_projects/textanalysis/clean_data.csv", row.names = FALSE)
Data Summary
Here are some of the most common words found in the dataset:
  
  received
capital
one
charge
card
offer
applied
accepted
limit
activated
Data Analysis
Bing Lexicon
The sentiment analysis using the Bing Lexicon shows that most consumer complaints are negative. The sentiment scores from this analysis reflect widespread dissatisfaction, with a significant number of complaints exhibiting extreme negativity. Only a small fraction of the complaints exhibit neutral or slightly positive sentiment. This suggests that complaints are primarily driven by negative emotions, which aligns with expectations based on the nature of consumer complaints.

Pie Chart: Positive vs Negative Sentiment
A pie chart was used to visually distinguish the proportion of positive and negative sentiments in consumer complaints. The majority of complaints are negative, as indicated by the larger portion of the pie chart, while a smaller portion is positive. This finding highlights the general dissatisfaction consumers have in their feedback.

NRC Lexicon
To add nuance to the sentiment analysis, I also employed the NRC Lexicon, which categorizes words into eight emotions rather than simply classifying them as positive or negative. This provides a deeper understanding of the emotional responses in consumer complaints. Using the NRC Lexicon, the most frequently expressed emotions were positive sentiment and trust.

The results revealed a variety of emotional responses, such as anger, sadness, and fear, in addition to positive feelings like trust and anticipation. Understanding these diverse emotions is crucial for businesses looking to improve customer relations.

Word Cloud
A word cloud was generated to highlight the most common words found in the consumer complaints. Words that appeared at least 50 times were included in the word cloud, which provided a visual representation of recurring issues or concerns. The most frequent words indicated that many complaints related to issues with credit, accounts, loans, banks, and payments.

Conclusion
The analysis reveals that negative sentiment predominates in consumer complaints, indicating widespread dissatisfaction with the products or services in question. Although trust and anticipation were significant emotions, negative emotions such as sadness, anger, and fear were also commonly expressed. This suggests that while some customers may have trust in the service providers, many are frustrated and dissatisfied.

In conclusion, consumers primarily complained about issues related to credit, accounts, loans, banks, and payments. Addressing these concerns could be key to improving customer satisfaction and loyalty.