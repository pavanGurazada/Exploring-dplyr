#' ---
#' title: "data.table tutorial"
#' author: Pavan Gurazada
#' date: "2018-02-26"
#' output: github_document
#' ---

#' data.table shines on massive data sets. It has got its own syntax to master
#' though and is sometimes not as intuitive as the tidyverse. Once your data
#' reaches 1 GB rethink your tidyverse solution

library(data.table)

flights <- fread("https://github.com/arunsrinivasan/satrdays-workshop/raw/master/flights_2014.csv")
names(flights)
head(flights)

nrow(flights)
ncol(flights)

#' *Selecting columns*

dat1 <- flights[, .(origin)] # select one column
dat2 <- flights[, .(origin, year, month, hour)] # select multiple columns

#' *Dropping columns*

dat3 <- flights[, !c("origin", "year", "month"), with = FALSE]

#' *Rename columns*

dat4 <- setnames(flights, c("dest"), "Destination")
dat5 <- setnames(flights, c("Destination", "origin"), c("Destination", "Origin"))

#' *Filter rows* based on condition on columns

dat6 <- flights[Origin %in% c("JFK", "LGA")]
dat7 <- flights[!Origin %in% c("JFK", "LGA")]
dat8 <- flights[Origin == "JFK" & carrier == "AA"]


#' *Setting keys* makes lookups in the table faster
setkey(flights, Origin)
system.time(flights[Origin %in% c("JFK", "LGA")])

key(flights)

#' Ordering the rows by column

dat9 <- setorder(flights, Origin)
dat10 <- setorder(flights, -Origin)
dat11 <- setorder(flights, Origin, -carrier)

#' Add new columns, aka, mutate
#' Notice the := assignment operator

flights[, dep_sch := dep_time - dep_delay] # one column
flights[, c("dep_sch", "arr_sch") := list(dep_time - dep_delay, arr_time - arr_delay)] # multiple columns

#' pipelining without magrittr

flights[, dep_sch := dep_time - dep_delay][, .(dep_time, dep_delay, dep_sch)]

#' *Summarizing*

flights[, .(mean = mean(arr_delay, na.rm = TRUE),
            median = median(arr_delay, na.rm = TRUE),
            min = min(arr_delay, na.rm = TRUE),
            max = max(arr_delay, na.rm = TRUE))] # Single column

flights[, .(arrmean = mean(arr_delay), depmean = mean(dep_delay))] # multiple columns
flights[, lapply(.SD, mean), .SDcols = c("arr_delay", "dep_delay")] # Special syntax for functions on multiple columns
flights[, lapply(.SD, mean, na.rm = TRUE)] # default is apply on all columns

flights[, sapply(.SD, function(x) c(mean = mean(x, na.rm = TRUE), median = median(x, na.rm = TRUE)))]

#' group by

flights[, .(mean_arr_delay = mean(arr_delay, na.rm = TRUE)), by = Origin]
flights[, lapply(.SD, mean, na.rm = TRUE), .SDcols = c("arr_delay", "dep_delay"), by = Origin]

#' Taking out the already set key
setkey(flights, NULL)
unique(flights)

#' Extract values within a group

flights[, .SD[1:2], by = carrier]
flights[, .SD[.N], by = carrier] # last value

flights[, cum := cumsum(distance), by = carrier]
flights[, .(cum)]

#' Calculate rows by month and sort on descending order

flights[, .N, by = month][order(-N)]

#' Top 3 months with high mean arrival delay

flights[, .(mean_arr_delay = mean(arr_delay, na.rm = TRUE)), by = month][order(-mean_arr_delay)][1:3]

#' Origin of flights with more than 20 mins of average total delay

flights[, .(mean_delay = mean(arr_delay + dep_delay)), by = Origin][mean_delay > 20] 
flights[, lapply(.SD, mean, na.rm = TRUE), .SDcols = c("arr_delay", "dep_delay"), by = Origin][(arr_delay + dep_delay) > 20]

#' Extract average of arrival and departure delays for carrier 'DL', by Origin and Destination

flights[carrier == "DL", lapply(.SD, mean, na.rm = TRUE), by = .(Origin, Destination), .SDcols = c("arr_delay", "dep_delay")]
