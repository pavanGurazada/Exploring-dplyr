#' ---
#' title: "Understanding Joins "
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

library(tidyverse)
library(nycflights13)

#' On several occasions one needs to work with multiple tables. These are
#' tackled in `dplyr` by using two-table verbs. These verbs match or filter
#' observations from one table using another.
#'
#' [This](http://r4ds.had.co.nz/relational-data.html) is the place to go for
#' pretty pictures and clear explanations. In my experience, what I could not
#' grok for a long time made sense once I used it to solve a problem I cared
#' about. Otherwise, the stuff here is merely a 'nice-to-know'.
#'
#' **Mutating Joins**

glimpse(flights)
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)

glimpse(flights2)
glimpse(airlines)

#' Notice the differences in the following, first note that there is a unique
#' common column between the data frames

intersect(colnames(flights2), colnames(airlines))

flights2 %>% left_join(airlines) %>% head(2)
flights2 %>% right_join(airlines) %>% head(2)
flights2 %>% inner_join(airlines) %>% head(2)
flights2 %>% full_join(airlines) %>% head(2)

#' The pivot column by which the two tables are joined can also be controlled by
#' the `by = ` option in the respective `_join()`. This is useful because there
#' might be several common unwanted columns (i.e., they mean different things).
#'
#' This is particularly important when there are several common columns in the
#' two data frames

glimpse(flights2)
glimpse(planes)

intersect(colnames(flights2), colnames(planes))

#' Here there are `r length(intersect(colnames(flights2), colnames(planes)))`
#' common columns between the two data frames. Now lets see if there are any
#' differences.

flights2 %>% left_join(planes, by = "tailnum") %>% head(2)
flights2 %>% right_join(planes, by = "tailnum") %>% head(2)
flights2 %>% inner_join(planes, by = "tailnum") %>% head(2)
flights2 %>% full_join(planes, by = "tailnum") %>% head(2)

#' **Filtering Joins**
#'
#' There are two types of joins in this category - one, where we keep
#' observations that match in the first dataframe and second, where we drop all
#' observations that match in the first dataframe.

flights %>% anti_join(planes, by = "tailnum") %>% 
            count(tailnum, sort = TRUE)
