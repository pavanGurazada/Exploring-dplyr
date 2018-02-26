#' ---
#' title: "data.table tutorial"
#' author: Pavan Gurazada
#' date: "2018-02-26"
#' output: github_document
#' ---

#' data.table shines on massive data sets. It has got its own syntax to master
#' though and is sometimes not as intuitive as the tidyverse

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

dat