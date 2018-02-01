Learning from the chef...
================
Pavan Gurazada
February 2018

In this script, we replicate the vignettes presented in the package documentation and try to replicate the results presented. As with most explorations in my github, this is an attempt to learn the tool with heavy annotations of my understanding of the same. As an overall guiding theme, I find drawing pictures of the how the data frame gets transformed/reshaped due to functions is very helpful in composing a workflow.

``` r
library(tidyverse)
```

Global options

``` r
theme_set(theme_bw())
knitr::opts_chunk$set(warning = FALSE)
sessionInfo()
```

    ## R version 3.4.3 (2017-11-30)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows >= 8 x64 (build 9200)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.1252 
    ## [2] LC_CTYPE=English_United States.1252   
    ## [3] LC_MONETARY=English_United States.1252
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] bindrcpp_0.2       nycflights13_0.2.2 forcats_0.2.0     
    ##  [4] stringr_1.2.0      dplyr_0.7.4        purrr_0.2.4       
    ##  [7] readr_1.1.1        tidyr_0.8.0        tibble_1.4.2      
    ## [10] ggplot2_2.2.1      tidyverse_1.2.1   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] reshape2_1.4.3   haven_1.1.1      lattice_0.20-35  colorspace_1.3-2
    ##  [5] htmltools_0.3.6  mgcv_1.8-22      yaml_2.1.16      utf8_1.1.3      
    ##  [9] rlang_0.1.6      pillar_1.1.0     foreign_0.8-69   glue_1.2.0      
    ## [13] modelr_0.1.1     readxl_1.0.0     bindr_0.1        plyr_1.8.4      
    ## [17] munsell_0.4.3    gtable_0.2.0     cellranger_1.1.0 rvest_0.3.2     
    ## [21] psych_1.7.8      evaluate_0.10.1  labeling_0.3     knitr_1.19      
    ## [25] parallel_3.4.3   broom_0.4.3      Rcpp_0.12.15     scales_0.5.0    
    ## [29] backports_1.1.2  jsonlite_1.5     mnormt_1.5-5     hms_0.4.1       
    ## [33] digest_0.6.15    stringi_1.1.6    grid_3.4.3       rprojroot_1.3-2 
    ## [37] cli_1.0.0        tools_3.4.3      magrittr_1.5     lazyeval_0.2.1  
    ## [41] crayon_1.3.4     pkgconfig_2.0.1  Matrix_1.2-12    xml2_1.2.0      
    ## [45] lubridate_1.7.1  assertthat_0.2.0 rmarkdown_1.8    httr_1.3.1      
    ## [49] rstudioapi_0.7   R6_2.2.2         nlme_3.1-131     compiler_3.4.3

``` r
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

To express what we wish to explore using `dplyr` we use a small selection of *verbs*.

They capture conditional execution of common data manipulations:

-   `filter()` to select rows

-   `arrange()` to re-order rows

-   `select()` to select features

-   `mutate()` to add functions of existing features

-   `summarize()` to summarize a feature vector using functions

We look at each of these verbs with an example. Notice how no $ signs or "" obscure the intention. All verbs take a dataframe and return one. No confusion.

Another common task that is executed in conjunction with these verbs is the grouping operation, i.e., selecting a group of rows based on some criterion. This is achieved by `group_by()`. This powerful function is particularly helpful in conjunction with summarize as illustrated in the examples that follow.

In each example we state the intention and follow it with code that executes that intention.

*Example 1* Find all flights that departed on 1st January

``` r
flights %>% filter(month == 1, day == 1) %>% head()
```

    ## # A tibble: 6 x 19
    ##    year month   day dep_time sched_dep_time dep_delay arr_time
    ##   <int> <int> <int>    <int>          <int>     <dbl>    <int>
    ## 1  2013     1     1      517            515      2.00      830
    ## 2  2013     1     1      533            529      4.00      850
    ## 3  2013     1     1      542            540      2.00      923
    ## 4  2013     1     1      544            545     -1.00     1004
    ## 5  2013     1     1      554            600     -6.00      812
    ## 6  2013     1     1      554            558     -4.00      740
    ## # ... with 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
    ## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
    ## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>,
    ## #   time_hour <dttm>

*Example 2* Arrange the data in descending order of arrival delay

``` r
flights %>% arrange(desc(arr_delay)) %>% head()
```

    ## # A tibble: 6 x 19
    ##    year month   day dep_time sched_dep_time dep_delay arr_time
    ##   <int> <int> <int>    <int>          <int>     <dbl>    <int>
    ## 1  2013     1     9      641            900      1301     1242
    ## 2  2013     6    15     1432           1935      1137     1607
    ## 3  2013     1    10     1121           1635      1126     1239
    ## 4  2013     9    20     1139           1845      1014     1457
    ## 5  2013     7    22      845           1600      1005     1044
    ## 6  2013     4    10     1100           1900       960     1342
    ## # ... with 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
    ## #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
    ## #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>,
    ## #   time_hour <dttm>

*Example 3* Select a subset of the data excluding year, month and day

``` r
flights %>% select(-(year:day)) %>% head()
```

    ## # A tibble: 6 x 16
    ##   dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
    ##      <int>          <int>     <dbl>    <int>          <int>     <dbl>
    ## 1      517            515      2.00      830            819      11.0
    ## 2      533            529      4.00      850            830      20.0
    ## 3      542            540      2.00      923            850      33.0
    ## 4      544            545     -1.00     1004           1022     -18.0
    ## 5      554            600     -6.00      812            837     -25.0
    ## 6      554            558     -4.00      740            728      12.0
    ## # ... with 10 more variables: carrier <chr>, flight <int>, tailnum <chr>,
    ## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
    ## #   minute <dbl>, time_hour <dttm>

*Example 4* Compute the increase in flight time because of the delays?

``` r
flights %>% mutate(gain = arr_delay - dep_delay,
                   gain_per_hour = gain/(air_time/60)) %>% 
            select(gain, gain_per_hour) %>% 
            head()
```

    ## # A tibble: 6 x 2
    ##     gain gain_per_hour
    ##    <dbl>         <dbl>
    ## 1   9.00          2.38
    ## 2  16.0           4.23
    ## 3  31.0          11.6 
    ## 4 -17.0         - 5.57
    ## 5 -19.0         - 9.83
    ## 6  16.0           6.40

*Example 5* Each flight has a unique tail number. Generate a summary of the data by each plane, number of flights it took, average distance traveled, average arrival delay.

``` r
delay <- flights %>% group_by(tailnum) %>% 
                     summarize(count = n(),
                               avg_dist = mean(distance, na.rm = TRUE),
                               avg_delay = mean(arr_delay, na.rm = TRUE)) %>% 
                     filter(count > 20, avg_dist < 2000)

glimpse(delay)            
```

    ## Observations: 2,962
    ## Variables: 4
    ## $ tailnum   <chr> "N0EGMQ", "N10156", "N102UW", "N103US", "N104UW", "N...
    ## $ count     <int> 371, 153, 48, 46, 47, 289, 45, 41, 60, 48, 40, 129, ...
    ## $ avg_dist  <dbl> 676.1887, 757.9477, 535.8750, 535.1957, 535.2553, 51...
    ## $ avg_delay <dbl> 9.9829545, 12.7172414, 2.9375000, -6.9347826, 1.8043...

``` r
ggplot(delay, aes(x = avg_dist, y = avg_delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()
```

    ## `geom_smooth()` using method = 'gam'

![](C:\Users\kimmcodxb\Documents\GitHub\Exploring-dplyr\vignettes\Introduction_files/figure-markdown_github/unnamed-chunk-8-1.png)

*Example 6* Find the number of planes and number of flights that go to each possible destination

``` r
flights %>% group_by(dest) %>% 
            summarize(num_planes = n_distinct(tailnum),
                      num_flights = n_distinct(flight),
                      flights = n())
```

    ## # A tibble: 105 x 4
    ##    dest  num_planes num_flights flights
    ##    <chr>      <int>       <int>   <int>
    ##  1 ABQ          108           2     254
    ##  2 ACK           58           4     265
    ##  3 ALB          172          42     439
    ##  4 ANC            6           1       8
    ##  5 ATL         1180         300   17215
    ##  6 AUS          993         113    2439
    ##  7 AVL          159          10     275
    ##  8 BDL          186          34     443
    ##  9 BGR           46          16     375
    ## 10 BHM           45           4     297
    ## # ... with 95 more rows

As can be seen here, when you think on the lines "for each of...", it is time to deploy a `group_by()`. In my experience, logic using `group_by`'s are readable only when the grouping is on one or two variables. Groups involving multiple variables are difficult to parse.
