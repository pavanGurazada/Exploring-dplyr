#' ---
#' title: "Learning from the chef... "
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

#'
#' In this script, we replicate the vignettes presented in the package
#' documentation and try to replicate the results presented. As with most
#' explorations in this github this is an attempt to learn the tool with heavy
#' annotations of my understanding of the same.

library(tidyverse)
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
#' - `filter()` to select rows - `arrange()` to re-order rows - `select()` to
#' select features - `mutate()` to add functions of existing features -
#' `summarize()` to summarize a feature vector using functions
#'
#' We look at each of these verbs with an example
#'
#' *Example 1*
#' 

flights %>% filter(month == 1, day == 1)










