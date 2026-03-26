library(tidyverse)
library(lubridate)
library(purrr)
library(stringr)
book <- read.csv("C:\\Users\\Sanjana\\Downloads\\sales2019.csv")
head(book)
view(book)

# Before commencing any data analysis project, we should explore the data itself and make note of any potential problems that we might run into.

colnames(book)
nrow(book)
ncol(book)

#Presence of some rows with NA or blank spaces
# 1. Remove rows with blank/whitespace in user_submitted_review
book <- book %>%
  filter(trimws(user_submitted_review) != "")

# 2. Impute NA values in total_purchased with the column average
avg_purchased <- mean(book$total_purchased, na.rm = TRUE)
book <- book %>%
  mutate(total_purchased = ifelse(is.na(total_purchased), avg_purchased, total_purchased))
View(book)

# The user_submitted_review column contains reviews in the form of sentences. Ultimately, we want to be able to classify reviews as either positive or negative. This allows us to count the number of negative or positive reviews in the analysis part of the workflow.

# Create a function that checks if a review is positive
is_positive_review <- function(review) {
  case_when(
    str_detect(review, "Awesome!|learned|Never read a better book") ~ TRUE,
    TRUE ~ FALSE  # default case: not positive
  )
}
is_positive_review("This book was Awesome!")

#Create a new column in the dataset that indicates whether or not the review in a given row is positive or not.

book <- book %>%
  mutate(Positive_review = is_positive_review(user_submitted_review))
view(book)

#With the review data and order quantities processed into a usable form, we can finally make a move towards answering the main question of the analysis, Was the new book program effective in increasing book sales?
#First, the dates are currently represented in string form. These must be properly formatted before we can make any comparisons based on date and time.
#Secondly, we need a clear way to distinguish between sales that happened before the program started and those that happened after. We need to distinguish between these two groups so that we can use what we've learned to easily calculate the summary values we want from the data.
#Finally, this analysis should be put into a neat form that can be easily read and understood by anyone looking at it. 

#Perform the proper conversion of the date column, so that it actually represents a date and time.
book <- book %>%
  mutate(date = mdy(date))
view(book)
#Create a new grouping column using the mutate() function that will help distinguish between sales that happened before July 1, 2019 and sales that happened after this date.
book <- book %>%
  mutate(pre_july = if_else(date < as.Date("2019-07-01"), TRUE, FALSE))
view(book)

#Create a summary table that compares the number of books purchased before July 1, 2019 to after.
table(book$pre_july)

#Use the group column from step 2 to group the data in group_by() function and summarize with the summarize() function
summary_table <- book %>%
  group_by(pre_july) %>%
  summarize(
    total_books_sold = sum(total_purchased, na.rm = TRUE)
  )

summary_table

#After creating the table, judge whether or not the program was actually effective in terms of increasing the number of books sold.
8642-8525
#succesfull as it increased sales by 117 books

#Perform the same analysis that you did in the last step but add in the customer_type column to further subdivide the groups.Examine the results of the analysis and write about your observations. Does the program still seem to have an effect on increasing sales? Did it have a different effect for individuals versus businesses?
summary_table1 <- book %>%
  group_by(pre_july, customer_type) %>%
  summarize(
    total_books_sold = sum(total_purchased, na.rm = TRUE)
  )

summary_table1

#Business
5872-5897
#Individual
2770-2628
#Worked only for individual sales

#The last question that we need to answer with the data is, did review scores improve as a result of the program? Create another summary table that compares the number of positive reviews before and after July 1, 2019. Does it seem that review sentiment improved after the program was created? Or did it get worse?

summary_table2 <- book %>%
  group_by(pre_july) %>%
  summarize(
    total_positive_reviews = sum(Positive_review, na.rm = TRUE)
  )

summary_table2

658-684
#The number of positive reviews decreased after the programme