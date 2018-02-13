Understanding Joins
================
Pavan Gurazada
February 2018

``` r
library(tidyverse)
library(nycflights13)
```

On several occasions one needs to work with multiple tables. These are tackled in `dplyr` by using two-table verbs. These verbs match or filter observations from one table using another.

[This](http://r4ds.had.co.nz/relational-data.html) is the place to go for pretty pictures and clear explanations. In my experience, what I could not grok for a long time made sense once I used it to solve a problem I cared about. Otherwise, the stuff here is merely a 'nice-to-know'.

**Mutating Joins**

``` r
glimpse(flights)
```

    ## Observations: 336,776
    ## Variables: 19
    ## $ year           <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013,...
    ## $ month          <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
    ## $ day            <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
    ## $ dep_time       <int> 517, 533, 542, 544, 554, 554, 555, 557, 557, 55...
    ## $ sched_dep_time <int> 515, 529, 540, 545, 600, 558, 600, 600, 600, 60...
    ## $ dep_delay      <dbl> 2, 4, 2, -1, -6, -4, -5, -3, -3, -2, -2, -2, -2...
    ## $ arr_time       <int> 830, 850, 923, 1004, 812, 740, 913, 709, 838, 7...
    ## $ sched_arr_time <int> 819, 830, 850, 1022, 837, 728, 854, 723, 846, 7...
    ## $ arr_delay      <dbl> 11, 20, 33, -18, -25, 12, 19, -14, -8, 8, -2, -...
    ## $ carrier        <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV",...
    ## $ flight         <int> 1545, 1714, 1141, 725, 461, 1696, 507, 5708, 79...
    ## $ tailnum        <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN...
    ## $ origin         <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR"...
    ## $ dest           <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL"...
    ## $ air_time       <dbl> 227, 227, 160, 183, 116, 150, 158, 53, 140, 138...
    ## $ distance       <dbl> 1400, 1416, 1089, 1576, 762, 719, 1065, 229, 94...
    ## $ hour           <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5,...
    ## $ minute         <dbl> 15, 29, 40, 45, 0, 58, 0, 0, 0, 0, 0, 0, 0, 0, ...
    ## $ time_hour      <dttm> 2013-01-01 05:00:00, 2013-01-01 05:00:00, 2013...

``` r
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)

glimpse(flights2)
```

    ## Observations: 336,776
    ## Variables: 8
    ## $ year    <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, ...
    ## $ month   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    ## $ day     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    ## $ hour    <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, ...
    ## $ origin  <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LGA"...
    ## $ dest    <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IAD"...
    ## $ tailnum <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N39...
    ## $ carrier <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6", ...

``` r
glimpse(airlines)
```

    ## Observations: 16
    ## Variables: 2
    ## $ carrier <chr> "9E", "AA", "AS", "B6", "DL", "EV", "F9", "FL", "HA", ...
    ## $ name    <chr> "Endeavor Air Inc.", "American Airlines Inc.", "Alaska...

Notice the differences in the following, first note that there is a unique common column between the data frames

``` r
intersect(colnames(flights2), colnames(airlines))
```

    ## [1] "carrier"

``` r
flights2 %>% left_join(airlines) %>% head(2)
```

    ## Joining, by = "carrier"

    ## # A tibble: 2 x 9
    ##    year month   day  hour origin dest  tailnum carrier name               
    ##   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr>              
    ## 1  2013     1     1  5.00 EWR    IAH   N14228  UA      United Air Lines I~
    ## 2  2013     1     1  5.00 LGA    IAH   N24211  UA      United Air Lines I~

``` r
flights2 %>% right_join(airlines) %>% head(2)
```

    ## Joining, by = "carrier"

    ## # A tibble: 2 x 9
    ##    year month   day  hour origin dest  tailnum carrier name             
    ##   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr>            
    ## 1  2013     1     1  8.00 JFK    MSP   N915XJ  9E      Endeavor Air Inc.
    ## 2  2013     1     1 15.0  JFK    IAD   N8444F  9E      Endeavor Air Inc.

``` r
flights2 %>% inner_join(airlines) %>% head(2)
```

    ## Joining, by = "carrier"

    ## # A tibble: 2 x 9
    ##    year month   day  hour origin dest  tailnum carrier name               
    ##   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr>              
    ## 1  2013     1     1  5.00 EWR    IAH   N14228  UA      United Air Lines I~
    ## 2  2013     1     1  5.00 LGA    IAH   N24211  UA      United Air Lines I~

``` r
flights2 %>% full_join(airlines) %>% head(2)
```

    ## Joining, by = "carrier"

    ## # A tibble: 2 x 9
    ##    year month   day  hour origin dest  tailnum carrier name               
    ##   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr>              
    ## 1  2013     1     1  5.00 EWR    IAH   N14228  UA      United Air Lines I~
    ## 2  2013     1     1  5.00 LGA    IAH   N24211  UA      United Air Lines I~

The pivot column by which the two tables are joined can also be controlled by the `by =` option in the respective `_join()`. This is useful because there might be several common unwanted columns (i.e., they mean different things).

This is particularly important when there are several common columns in the two data frames

``` r
glimpse(flights2)
```

    ## Observations: 336,776
    ## Variables: 8
    ## $ year    <int> 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, 2013, ...
    ## $ month   <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    ## $ day     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    ## $ hour    <dbl> 5, 5, 5, 5, 6, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 6, ...
    ## $ origin  <chr> "EWR", "LGA", "JFK", "JFK", "LGA", "EWR", "EWR", "LGA"...
    ## $ dest    <chr> "IAH", "IAH", "MIA", "BQN", "ATL", "ORD", "FLL", "IAD"...
    ## $ tailnum <chr> "N14228", "N24211", "N619AA", "N804JB", "N668DN", "N39...
    ## $ carrier <chr> "UA", "UA", "AA", "B6", "DL", "UA", "B6", "EV", "B6", ...

``` r
glimpse(planes)
```

    ## Observations: 3,322
    ## Variables: 9
    ## $ tailnum      <chr> "N10156", "N102UW", "N103US", "N104UW", "N10575",...
    ## $ year         <int> 2004, 1998, 1999, 1999, 2002, 1999, 1999, 1999, 1...
    ## $ type         <chr> "Fixed wing multi engine", "Fixed wing multi engi...
    ## $ manufacturer <chr> "EMBRAER", "AIRBUS INDUSTRIE", "AIRBUS INDUSTRIE"...
    ## $ model        <chr> "EMB-145XR", "A320-214", "A320-214", "A320-214", ...
    ## $ engines      <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2...
    ## $ seats        <int> 55, 182, 182, 182, 55, 182, 182, 182, 182, 182, 5...
    ## $ speed        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    ## $ engine       <chr> "Turbo-fan", "Turbo-fan", "Turbo-fan", "Turbo-fan...

``` r
intersect(colnames(flights2), colnames(planes))
```

    ## [1] "year"    "tailnum"

Here there are 2 common columns between the two data frames. Now lets see if there are any differences.

``` r
flights2 %>% left_join(planes, by = "tailnum") %>% head(2)
```

    ## # A tibble: 2 x 16
    ##   year.x month   day  hour origin dest  tailnum carrier year.y type       
    ##    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>      
    ## 1   2013     1     1  5.00 EWR    IAH   N14228  UA        1999 Fixed wing~
    ## 2   2013     1     1  5.00 LGA    IAH   N24211  UA        1998 Fixed wing~
    ## # ... with 6 more variables: manufacturer <chr>, model <chr>,
    ## #   engines <int>, seats <int>, speed <int>, engine <chr>

``` r
flights2 %>% right_join(planes, by = "tailnum") %>% head(2)
```

    ## # A tibble: 2 x 16
    ##   year.x month   day  hour origin dest  tailnum carrier year.y type       
    ##    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>      
    ## 1   2013     1    10  6.00 EWR    PIT   N10156  EV        2004 Fixed wing~
    ## 2   2013     1    10 10.0  EWR    CHS   N10156  EV        2004 Fixed wing~
    ## # ... with 6 more variables: manufacturer <chr>, model <chr>,
    ## #   engines <int>, seats <int>, speed <int>, engine <chr>

``` r
flights2 %>% inner_join(planes, by = "tailnum") %>% head(2)
```

    ## # A tibble: 2 x 16
    ##   year.x month   day  hour origin dest  tailnum carrier year.y type       
    ##    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>      
    ## 1   2013     1     1  5.00 EWR    IAH   N14228  UA        1999 Fixed wing~
    ## 2   2013     1     1  5.00 LGA    IAH   N24211  UA        1998 Fixed wing~
    ## # ... with 6 more variables: manufacturer <chr>, model <chr>,
    ## #   engines <int>, seats <int>, speed <int>, engine <chr>

``` r
flights2 %>% full_join(planes, by = "tailnum") %>% head(2)
```

    ## # A tibble: 2 x 16
    ##   year.x month   day  hour origin dest  tailnum carrier year.y type       
    ##    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>      
    ## 1   2013     1     1  5.00 EWR    IAH   N14228  UA        1999 Fixed wing~
    ## 2   2013     1     1  5.00 LGA    IAH   N24211  UA        1998 Fixed wing~
    ## # ... with 6 more variables: manufacturer <chr>, model <chr>,
    ## #   engines <int>, seats <int>, speed <int>, engine <chr>

**Filtering Joins**

There are two types of joins in this category - one, where we keep observations that match in the first dataframe and second, where we drop all observations that match in the first dataframe.

``` r
flights %>% anti_join(planes, by = "tailnum") %>% 
            count(tailnum, sort = TRUE)
```

    ## # A tibble: 722 x 2
    ##    tailnum     n
    ##    <chr>   <int>
    ##  1 <NA>     2512
    ##  2 N725MQ    575
    ##  3 N722MQ    513
    ##  4 N723MQ    507
    ##  5 N713MQ    483
    ##  6 N735MQ    396
    ##  7 N0EGMQ    371
    ##  8 N534MQ    364
    ##  9 N542MQ    363
    ## 10 N531MQ    349
    ## # ... with 712 more rows
