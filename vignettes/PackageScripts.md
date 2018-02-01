Learning from the chef...
================
Pavan Gurazada
February 2018

*Taking dplyr out for a spin*

In this script we replicate the vignettes presented in the package documentation and try to replicate the results presented. As with most explorations in this github this is an attempt to learn the tool with heavy annotations of my understanding of the same.

``` r
library(tidyverse)
if (!require(nycflights13)) {install.packages("nycflights13"); library(nycflights13)}
```

The tidyverse presents a small vocabulary of verbs to execute most data-related tasks in a time-efficient manner. By composing data tasks as sentences comprising these verbs, data analysis turns into poetry. In sum, there is a near-direct translation from intention to code.

The data set used in this vignette is the flight departure data from New York in 2013.

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
sum(is.na(flights))
```

    ## [1] 46595

As we can see, there is significant amount of missing data. Since, the aim of this vignette is not modeling, we let it be for now.

To express what we wish to explore using `dplyr` we use a small selection of *verbs* They capture conditional execution of common data manipulations: - `filter()` to select rows - `arrange()` to re-order rows - `select()` to select features - `mutate()` to add functions of existing features - `summarize()` to summarize a feature vector using functions

We look at each of these verbs with an example

*Example 1*

``` r
flights %>% filter(month == 1, day == 1)
```

    ## # A tibble: 842 x 19
    ##     year month   day dep_time sched_dep_time dep_delay arr_time
    ##    <int> <int> <int>    <int>          <int>     <dbl>    <int>
    ##  1  2013     1     1      517            515      2.00      830
    ##  2  2013     1     1      533            529      4.00      850
    ##  3  2013     1     1      542            540      2.00      923
    ##  4  2013     1     1      544            545     -1.00     1004
    ##  5  2013     1     1      554            600     -6.00      812
    ##  6  2013     1     1      554            558     -4.00      740
    ##  7  2013     1     1      555            600     -5.00      913
    ##  8  2013     1     1      557            600     -3.00      709
    ##  9  2013     1     1      557            600     -3.00      838
    ## 10  2013     1     1      558            600     -2.00      753
    ## # ... with 832 more rows, and 12 more variables: sched_arr_time <int>,
    ## #   arr_delay <dbl>, carrier <chr>, flight <int>, tailnum <chr>,
    ## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
    ## #   minute <dbl>, time_hour <dttm>
