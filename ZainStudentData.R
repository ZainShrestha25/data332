# Load required libraries
library(tidyverse)
library(lubridate)
library(readxl)

setwd("~/Desktop/DATA332/r_projects/student/")

course_df <- read_excel("course.xlsx")
registration_df <- read_excel("registration.xlsx")
student_df <- read_excel("student.xlsx")

registration_df <- rename(registration_df, Student_ID = `Student ID`, Instance_ID = `Instance ID`)
student_df <- rename(student_df, Student_ID = `Student ID`)
course_df <- rename(course_df, Instance_ID = `Instance ID`)
merged_df <- registration_df %>%
  left_join(student_df, by = "Student_ID") %>%
  left_join(course_df, by = "Instance_ID")

merged_df <- merged_df %>%
  mutate(
    `Birth Year` = year(as.Date(`Birth Date`)),
    Title = replace_na(Title, "Unknown Major"),
    `Payment Plan` = factor(str_trim(as.character(`Payment Plan`)),
                            levels = c("Cash", "Loan", "Scholarship"))
  )

major_count <- count(merged_df, Title, name = "Student_Count")
cost_per_major <- merged_df %>% group_by(Title, `Payment Plan`) %>% summarise(Total_Cost = sum(`Total Cost`, na.rm = TRUE))
balance_due_per_major <- merged_df %>% group_by(Title, `Payment Plan`) %>% summarise(Balance_Due = sum(`Balance Due`, na.rm = TRUE))

# Print validation checks
print(paste("Total Cost:", sum(cost_per_major$Total_Cost, na.rm = TRUE)))
print(paste("Total Balance Due:", sum(balance_due_per_major$Balance_Due, na.rm = TRUE)))

ggplot(major_count, aes(x = fct_reorder(Title, Student_Count), y = Student_Count, fill = Title)) +
  geom_col() +
  labs(title = "Number of Students per Major", x = "Major", y = "Student Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(filter(merged_df, !is.na(`Birth Year`)), aes(x = `Birth Year`)) +
  geom_density(fill = "tomato", alpha = 0.7) +
  labs(title = "Distribution of Students by Birth Year", x = "Birth Year", y = "Density") +
  theme_minimal()

ggplot(cost_per_major, aes(x = fct_reorder(Title, Total_Cost), y = Total_Cost, fill = `Payment Plan`)) +
  geom_col(position = "dodge") +
  labs(title = "Total Cost per Major by Payment Plan", x = "Major", y = "Total Cost ($)") +
  scale_y_continuous(labels = scales::dollar_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(balance_due_per_major, aes(x = fct_reorder(Title, Balance_Due), y = Balance_Due, color = `Payment Plan`, group = `Payment Plan`)) +
  geom_line(size = 1) + geom_point(size = 3) +
  labs(title = "Trend of Balance Due per Major by Payment Plan", x = "Major", y = "Balance Due ($)") +
  scale_y_continuous(labels = scales::dollar_format()) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))