#' ---
#' title: "Summarizing data with dplyr"
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

#' This tutorial contains annotated/modified snippets from:
#' 
#' - [Markham](https://github.com/justmarkham/dplyr-tutorial/blob/master/dplyr-tutorial.Rmd)

library(tidyverse)
library(hflights)

#' `dplyr` presents elegant solutions to problems where one is required to
#' collapse a truck-load of data into an easily digestible summary. This part of
#' data exploration provides rich dividends and is often a precursor to a rich
#' plot.

data("hflights")
glimpse(hflights)

sum(is.na(hflights))

#' **Are flights at some destinations more delayed than others?**

hflights %>% group_by(Dest) %>% 
             summarize(AvgArrDelay = mean(ArrDelay, na.rm = TRUE),
                       AvgDepDelay = mean(DepDelay, na.rm = TRUE))

#' **For each carrier, calculate the minimum and maximum arrival and departure
#' delays**
#'
#' The peculiarity here is that we are not summarizing a particular column for
#' each group but rather summarizing all columns. To achieve this, we replace
#' the column with a `.` as a place holder in the function.
#' 
#' Let us first solve this generally.

hflights %>% group_by(UniqueCarrier) %>% 
             summarise_all(funs(min(., na.rm = TRUE), max(., na.rm = TRUE)))

#' Notice how `.` matched all the columns and added two columns (min and max) for
#' each column.
#' Also, notice how this is a verbose version of the following call:

hflights %>% group_by(UniqueCarrier) %>% 
             summarise_all(funs(min, max), na.rm = TRUE)

#' Now to the original question

hflights %>% group_by(UniqueCarrier) %>% 
             summarize_at(c("ArrDelay", "DepDelay"), funs(min, max), na.rm = TRUE)
