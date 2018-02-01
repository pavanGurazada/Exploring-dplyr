#' ---
#' title: "Learning from the chef... "
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

#' In this script, we replicate the vignettes presented in the package
#' documentation and try to replicate the results presented. As with most
#' explorations in my github, this is an attempt to learn the tool with heavy
#' annotations of my understanding of the same. As an overall guiding theme, I
#' find drawing pictures of the how the data frame gets transformed/reshaped due
#' to functions is very helpful in composing a workflow.

library(tidyverse)

#' Global options
theme_set(theme_bw())
knitr::opts_chunk$set(warning = FALSE)
sessionInfo()

if (!require(nycflights13)) {install.packages("nycflights13"); library(nycflights13)}

#' The tidyverse presents a small vocabulary of verbs to execute most
#' data-related tasks in a time-efficient manner. By composing data tasks as
#' sentences comprising these verbs, data analysis turns into poetry. In sum,
#' there is a near-direct translation from intention to code.
#'
#' The data set used in this vignette is the flight departure data from New York
#' in 2013.

glimpse(flights)
sum(is.na(flights))

#' As we can see, there is significant amount of missing data. Since, the aim of
#' this vignette is not modeling, we let it be for now.
#'
#' To express what we wish to explore using `dplyr` we use a small selection of
#' *verbs*.
#'
#' They capture conditional execution of common data manipulations:
#'
#' - `filter()` to select rows
#'
#' - `arrange()` to re-order rows
#'
#' - `select()` to select features
#'
#' - `mutate()` to add functions of existing features
#'
#' - `summarize()` to summarize a feature vector using functions
#'
#' We look at each of these verbs with an example. Notice how no $ signs or ""
#' obscure the intention. All verbs take a dataframe and return one. No
#' confusion.
#'
#' Another common task that is executed in conjunction with these verbs is the
#' grouping operation, i.e., selecting a group of rows based on some criterion.
#' This is achieved by `group_by()`. This powerful function is particularly
#' helpful in conjunction with summarize as illustrated in the examples that
#' follow.
#'
#' In each example we state the intention and follow it with code that executes
#' that intention.
#'
#' *Example 1* Find all flights that departed on 1st January

flights %>% filter(month == 1, day == 1) %>% head()

#' *Example 2* Arrange the data in descending order of arrival delay

flights %>% arrange(desc(arr_delay)) %>% head()

#' *Example 3* Select a subset of the data excluding year, month and day

flights %>% select(-(year:day)) %>% head()

#' *Example 4* Compute the increase in flight time because of the delays?

flights %>% mutate(gain = arr_delay - dep_delay,
                   gain_per_hour = gain/(air_time/60)) %>% 
            select(gain, gain_per_hour) %>% 
            head()

#' *Example 5* Each flight has a unique tail number. Generate a summary of the
#' data by each plane, number of flights it took, average distance traveled,
#' average arrival delay.

delay <- flights %>% group_by(tailnum) %>% 
                     summarize(count = n(),
                               avg_dist = mean(distance, na.rm = TRUE),
                               avg_delay = mean(arr_delay, na.rm = TRUE)) %>% 
                     filter(count > 20, avg_dist < 2000)

glimpse(delay)            

ggplot(delay, aes(x = avg_dist, y = avg_delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()

#' *Example 6* Find the number of planes and number of flights that go to each
#' possible destination
#' 

flights %>% group_by(dest) %>% 
            summarize(num_planes = n_distinct(tailnum),
                      num_flights = n_distinct(flight),
                      flights = n())

#' As can be seen here, when you think on the lines "for each of...", it is time
#' to deploy a `group_by()`. In my experience, logic using `group_by`'s are
#' readable only when the grouping is on one or two variables. Groups involving
#' multiple variables are difficult to parse.





