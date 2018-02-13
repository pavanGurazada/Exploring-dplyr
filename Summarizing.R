#' ---
#' title: "Summarizing data with dplyr"
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

#' This tutorial contains annotated/modified snippets from:
#' 
#' - [Markham](https://github.com/justmarkham/dplyr-tutorial/blob/master/dplyr-tutorial.Rmd)
#' - [Enchufa](https://www.enchufa2.es/archives/programming-with-dplyr-by-using-dplyr.html)

library(tidyverse)
library(hflights)

#' **Introduction**
#' 
#' [`dplyr`](http://dplyr.tidyverse.org/index.html) presents elegant solutions
#' to problems where one is required to collapse a truck-load of data into an
#' easily digestible summary. This part of data exploration provides rich
#' dividends and is often a precursor to a rich plot.
#'
#' There are three main functions that handle data summaries - `summarize()`, 
#' `summarize_all()` and `summarize_at()`.
#'
#' When the data is ungrouped, the `summarize()` function returns a single row
#' with the corresponding summary.

glimpse(mtcars)
mtcars %>% summarize(Mean = mean(disp),
                     Count = n())

#' When the data is grouped, the `summarize()` function returns a row for each 
#' group.

mtcars %>% group_by(cyl) %>% 
           summarize(Mean = mean(disp),
                     Count = n())

mtcars %>% group_by(cyl) %>% 
           summarize(Mean = mean(disp),
                     SD = sd(disp))

#' `summarize_all()` allows the generation of summaries for all the non-grouped
#' variables. This is easiest when the built-in functions are used.
#'
#' `summarize_at()` allows the generation of summaries for variables supplied as
#' character vectors. This is important since internally column names have to be
#' valid R identifiers?
#' 

glimpse(iris)

iris %>% group_by(Species) %>% 
         summarize_all(funs(mean))

iris %>% group_by(Species) %>% 
         summarize_at(c("Sepal.Length", "Petal.Length"), funs(mean))

iris %>% group_by(Species) %>% 
         summarize_at(c("Sepal.Length", "Petal.Length"), funs(mean, sd))

#' The one thing that is jars in the above code is the usage of the function
#' `funs()` to plug in functions to summarize the groups. Functions specified in
#' this call can be specified either by their name (i.e., "mean") or explicitly
#' using `.` as a dummy for grouped column (i.e., "mean(., na.rm = TRUE)").
#'
#' So, the following two function calls are identical:

iris %>% group_by(Species) %>%       # creates a grouping of rows by Species type
         summarize_all(funs(mean), na.rm = TRUE)   # summarizes the rows using the mean function

iris %>% group_by(Species) %>%       # creates a grouping of rows by Species type
         summarize_all(funs(mean(., na.rm = TRUE)))   # summarizes the rows using the mean function

#' I find the second form more explicit and easier to wrap my head around. Since
#' the mapping is explicit this form is easier when I have to write custom
#' summary functions.
#'
#' One more typical case is when we wish to use the verbs within a
#' custom-function. In this case, `dplyr` provides scoped variants that allow us
#' to achieve this with the same workflow
#' 
#' First note the erroneous code
#' 


starwarsMeanBad <- function(var) {
  starwars %>% 
    group_by(var) %>% # Why does this fail?
    summarize(MeanHeight = mean(height, na.rm = TRUE),
              MeanMass = mean(mass, na.rm = TRUE),
              Count = n())
}

# starwarsMeanBad("homeworld") breaks, figure out why!

#' Now to the correct version

starwarsMean <- function(var) {
  starwars %>% 
    group_by_at(var) %>% # <------ Notice the scoped variant!
    summarize(MeanHeight = mean(height, na.rm = TRUE),
              MeanMass = mean(mass, na.rm = TRUE),
              Count = n())
}
  
starwarsMean("homeworld")  

#' This leads to particularly elegant solutions that are otherwise difficult to
#' enfore reuse.

groupedMean <- function(data, groupingVariables, valueVariables) {
  data %>% 
    group_by_at(groupingVariables) %>% 
    mutate(Count = n()) %>% 
    summarize_at(c(valueVariables, "Count"), funs(mean(., na.rm = TRUE))) %>% 
    rename_at(valueVariables, funs(paste0("mean_", .)))
}  

starwars %>% groupedMean("eye_color", c("mass", "birth_year"))


#' **Examples** 

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
