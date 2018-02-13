Summarizing data with dplyr
================
Pavan Gurazada
February 2018

This tutorial contains annotated/modified snippets from:

-   [Markham](https://github.com/justmarkham/dplyr-tutorial/blob/master/dplyr-tutorial.Rmd)
-   [Enchufa](https://www.enchufa2.es/archives/programming-with-dplyr-by-using-dplyr.html)

``` r
library(tidyverse)
library(hflights)
```

**Introduction**

[`dplyr`](http://dplyr.tidyverse.org/index.html) presents elegant solutions to problems where one is required to collapse a truck-load of data into an easily digestible summary. This part of data exploration provides rich dividends and is often a precursor to a rich plot.

There are three main functions that handle data summaries - `summarize()`, `summarize_all()` and `summarize_at()`.

When the data is ungrouped, the `summarize()` function returns a single row with the corresponding summary.

``` r
glimpse(mtcars)
```

    ## Observations: 32
    ## Variables: 11
    ## $ mpg  <dbl> 21.0, 21.0, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19....
    ## $ cyl  <dbl> 6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, ...
    ## $ disp <dbl> 160.0, 160.0, 108.0, 258.0, 360.0, 225.0, 360.0, 146.7, 1...
    ## $ hp   <dbl> 110, 110, 93, 110, 175, 105, 245, 62, 95, 123, 123, 180, ...
    ## $ drat <dbl> 3.90, 3.90, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.9...
    ## $ wt   <dbl> 2.620, 2.875, 2.320, 3.215, 3.440, 3.460, 3.570, 3.190, 3...
    ## $ qsec <dbl> 16.46, 17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20.00, 2...
    ## $ vs   <dbl> 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, ...
    ## $ am   <dbl> 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, ...
    ## $ gear <dbl> 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, ...
    ## $ carb <dbl> 4, 4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, ...

``` r
mtcars %>% summarize(Mean = mean(disp),
                     Count = n())
```

    ##       Mean Count
    ## 1 230.7219    32

When the data is grouped, the `summarize()` function returns a row for each group.

``` r
mtcars %>% group_by(cyl) %>% 
           summarize(Mean = mean(disp),
                     Count = n())
```

    ## # A tibble: 3 x 3
    ##     cyl  Mean Count
    ##   <dbl> <dbl> <int>
    ## 1  4.00   105    11
    ## 2  6.00   183     7
    ## 3  8.00   353    14

``` r
mtcars %>% group_by(cyl) %>% 
           summarize(Mean = mean(disp),
                     SD = sd(disp))
```

    ## # A tibble: 3 x 3
    ##     cyl  Mean    SD
    ##   <dbl> <dbl> <dbl>
    ## 1  4.00   105  26.9
    ## 2  6.00   183  41.6
    ## 3  8.00   353  67.8

`summarize_all()` allows the generation of summaries for all the non-grouped variables. This is easiest when the built-in functions are used.

`summarize_at()` allows the generation of summaries for variables supplied as character vectors. This is important since internally column names have to be valid R identifiers?

``` r
glimpse(iris)
```

    ## Observations: 150
    ## Variables: 5
    ## $ Sepal.Length <dbl> 5.1, 4.9, 4.7, 4.6, 5.0, 5.4, 4.6, 5.0, 4.4, 4.9,...
    ## $ Sepal.Width  <dbl> 3.5, 3.0, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1,...
    ## $ Petal.Length <dbl> 1.4, 1.4, 1.3, 1.5, 1.4, 1.7, 1.4, 1.5, 1.4, 1.5,...
    ## $ Petal.Width  <dbl> 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1,...
    ## $ Species      <fct> setosa, setosa, setosa, setosa, setosa, setosa, s...

``` r
iris %>% group_by(Species) %>% 
         summarize_all(funs(mean))
```

    ## # A tibble: 3 x 5
    ##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
    ##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
    ## 1 setosa             5.01        3.43         1.46       0.246
    ## 2 versicolor         5.94        2.77         4.26       1.33 
    ## 3 virginica          6.59        2.97         5.55       2.03

``` r
iris %>% group_by(Species) %>% 
         summarize_at(c("Sepal.Length", "Petal.Length"), funs(mean))
```

    ## # A tibble: 3 x 3
    ##   Species    Sepal.Length Petal.Length
    ##   <fct>             <dbl>        <dbl>
    ## 1 setosa             5.01         1.46
    ## 2 versicolor         5.94         4.26
    ## 3 virginica          6.59         5.55

``` r
iris %>% group_by(Species) %>% 
         summarize_at(c("Sepal.Length", "Petal.Length"), funs(mean, sd))
```

    ## # A tibble: 3 x 5
    ##   Species    Sepal.Length_mean Petal.Length_mean Sepal.Length_sd
    ##   <fct>                  <dbl>             <dbl>           <dbl>
    ## 1 setosa                  5.01              1.46           0.352
    ## 2 versicolor              5.94              4.26           0.516
    ## 3 virginica               6.59              5.55           0.636
    ## # ... with 1 more variable: Petal.Length_sd <dbl>

The one thing that is jars in the above code is the usage of the function `funs()` to plug in functions to summarize the groups. Functions specified in this call can be specified either by their name (i.e., "mean") or explicitly using `.` as a dummy for grouped column (i.e., "mean(., na.rm = TRUE)").

So, the following two function calls are identical:

``` r
iris %>% group_by(Species) %>%       # creates a grouping of rows by Species type
         summarize_all(funs(mean), na.rm = TRUE)   # summarizes the rows using the mean function
```

    ## # A tibble: 3 x 5
    ##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
    ##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
    ## 1 setosa             5.01        3.43         1.46       0.246
    ## 2 versicolor         5.94        2.77         4.26       1.33 
    ## 3 virginica          6.59        2.97         5.55       2.03

``` r
iris %>% group_by(Species) %>%       # creates a grouping of rows by Species type
         summarize_all(funs(mean(., na.rm = TRUE)))   # summarizes the rows using the mean function
```

    ## # A tibble: 3 x 5
    ##   Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
    ##   <fct>             <dbl>       <dbl>        <dbl>       <dbl>
    ## 1 setosa             5.01        3.43         1.46       0.246
    ## 2 versicolor         5.94        2.77         4.26       1.33 
    ## 3 virginica          6.59        2.97         5.55       2.03

I find the second form more explicit and easier to wrap my head around. Since the mapping is explicit this form is easier when I have to write custom summary functions.

One more typical case is when we wish to use the verbs within a custom-function. In this case, `dplyr` provides scoped variants that allow us to achieve this with the same workflow

First note the erroneous code

``` r
starwarsMeanBad <- function(var) {
  starwars %>% 
    group_by(var) %>% # Why does this fail?
    summarize(MeanHeight = mean(height, na.rm = TRUE),
              MeanMass = mean(mass, na.rm = TRUE),
              Count = n())
}

# starwarsMeanBad("homeworld") breaks, figure out why!
```

Now to the correct version

``` r
starwarsMean <- function(var) {
  starwars %>% 
    group_by_at(var) %>% # <------ Notice the scoped variant!
    summarize(MeanHeight = mean(height, na.rm = TRUE),
              MeanMass = mean(mass, na.rm = TRUE),
              Count = n())
}
  
starwarsMean("homeworld")  
```

    ## # A tibble: 49 x 4
    ##    homeworld      MeanHeight MeanMass Count
    ##    <chr>               <dbl>    <dbl> <int>
    ##  1 Alderaan            176       64.0     3
    ##  2 Aleen Minor          79.0     15.0     1
    ##  3 Bespin              175       79.0     1
    ##  4 Bestine IV          180      110       1
    ##  5 Cato Neimoidia      191       90.0     1
    ##  6 Cerea               198       82.0     1
    ##  7 Champala            196      NaN       1
    ##  8 Chandrila           150      NaN       1
    ##  9 Concord Dawn        183       79.0     1
    ## 10 Corellia            175       78.5     2
    ## # ... with 39 more rows

This leads to particularly elegant solutions that are otherwise difficult to enfore reuse.

``` r
groupedMean <- function(data, groupingVariables, valueVariables) {
  data %>% 
    group_by_at(groupingVariables) %>% 
    mutate(Count = n()) %>% 
    summarize_at(c(valueVariables, "Count"), funs(mean(., na.rm = TRUE))) %>% 
    rename_at(valueVariables, funs(paste0("mean_", .)))
}  

starwars %>% groupedMean("eye_color", c("mass", "birth_year"))
```

    ## # A tibble: 15 x 4
    ##    eye_color     mean_mass mean_birth_year Count
    ##    <chr>             <dbl>           <dbl> <dbl>
    ##  1 black              76.3            33.0 10.0 
    ##  2 blue               86.5            67.1 19.0 
    ##  3 blue-gray          77.0            57.0  1.00
    ##  4 brown              66.1           109   21.0 
    ##  5 dark              NaN             NaN    1.00
    ##  6 gold              NaN             NaN    1.00
    ##  7 green, yellow     159             NaN    1.00
    ##  8 hazel              66.0            34.5  3.00
    ##  9 orange            282             231    8.00
    ## 10 pink              NaN             NaN    1.00
    ## 11 red                81.4            33.7  5.00
    ## 12 red, blue         NaN             NaN    1.00
    ## 13 unknown            31.5           NaN    3.00
    ## 14 white              48.0           NaN    1.00
    ## 15 yellow             81.1            76.4 11.0

**Examples**

``` r
data("hflights")
glimpse(hflights)
```

    ## Observations: 227,496
    ## Variables: 21
    ## $ Year              <int> 2011, 2011, 2011, 2011, 2011, 2011, 2011, 20...
    ## $ Month             <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
    ## $ DayofMonth        <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1...
    ## $ DayOfWeek         <int> 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6,...
    ## $ DepTime           <int> 1400, 1401, 1352, 1403, 1405, 1359, 1359, 13...
    ## $ ArrTime           <int> 1500, 1501, 1502, 1513, 1507, 1503, 1509, 14...
    ## $ UniqueCarrier     <chr> "AA", "AA", "AA", "AA", "AA", "AA", "AA", "A...
    ## $ FlightNum         <int> 428, 428, 428, 428, 428, 428, 428, 428, 428,...
    ## $ TailNum           <chr> "N576AA", "N557AA", "N541AA", "N403AA", "N49...
    ## $ ActualElapsedTime <int> 60, 60, 70, 70, 62, 64, 70, 59, 71, 70, 70, ...
    ## $ AirTime           <int> 40, 45, 48, 39, 44, 45, 43, 40, 41, 45, 42, ...
    ## $ ArrDelay          <int> -10, -9, -8, 3, -3, -7, -1, -16, 44, 43, 29,...
    ## $ DepDelay          <int> 0, 1, -8, 3, 5, -1, -1, -5, 43, 43, 29, 19, ...
    ## $ Origin            <chr> "IAH", "IAH", "IAH", "IAH", "IAH", "IAH", "I...
    ## $ Dest              <chr> "DFW", "DFW", "DFW", "DFW", "DFW", "DFW", "D...
    ## $ Distance          <int> 224, 224, 224, 224, 224, 224, 224, 224, 224,...
    ## $ TaxiIn            <int> 7, 6, 5, 9, 9, 6, 12, 7, 8, 6, 8, 4, 6, 5, 6...
    ## $ TaxiOut           <int> 13, 9, 17, 22, 9, 13, 15, 12, 22, 19, 20, 11...
    ## $ Cancelled         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
    ## $ CancellationCode  <chr> "", "", "", "", "", "", "", "", "", "", "", ...
    ## $ Diverted          <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...

``` r
sum(is.na(hflights))
```

    ## [1] 25755

**Are flights at some destinations more delayed than others?**

``` r
hflights %>% group_by(Dest) %>% 
             summarize(AvgArrDelay = mean(ArrDelay, na.rm = TRUE),
                       AvgDepDelay = mean(DepDelay, na.rm = TRUE))
```

    ## # A tibble: 116 x 3
    ##    Dest  AvgArrDelay AvgDepDelay
    ##    <chr>       <dbl>       <dbl>
    ##  1 ABQ          7.23        8.48
    ##  2 AEX          5.84        6.38
    ##  3 AGS          4.00       10.0 
    ##  4 AMA          6.84        6.70
    ##  5 ANC         26.1        25.0 
    ##  6 ASE          6.79       16.0 
    ##  7 ATL          8.23       10.3 
    ##  8 AUS          7.45        8.42
    ##  9 AVL          9.97        8.90
    ## 10 BFL        -13.2         5.06
    ## # ... with 106 more rows

**For each carrier, calculate the minimum and maximum arrival and departure delays**

The peculiarity here is that we are not summarizing a particular column for each group but rather summarizing all columns. To achieve this, we replace the column with a `.` as a place holder in the function.

Let us first solve this generally.

``` r
hflights %>% group_by(UniqueCarrier) %>% 
             summarise_all(funs(min(., na.rm = TRUE), max(., na.rm = TRUE)))
```

    ## # A tibble: 15 x 41
    ##    UniqueCarrier Year_min Month_min DayofMonth_min DayOfWeek_min
    ##    <chr>            <dbl>     <dbl>          <dbl>         <dbl>
    ##  1 AA                2011      1.00           1.00          1.00
    ##  2 AS                2011      1.00           1.00          1.00
    ##  3 B6                2011      1.00           1.00          1.00
    ##  4 CO                2011      1.00           1.00          1.00
    ##  5 DL                2011      1.00           1.00          1.00
    ##  6 EV                2011      1.00           1.00          1.00
    ##  7 F9                2011      1.00           1.00          1.00
    ##  8 FL                2011      1.00           1.00          1.00
    ##  9 MQ                2011      1.00           1.00          1.00
    ## 10 OO                2011      1.00           1.00          1.00
    ## 11 UA                2011      1.00           1.00          1.00
    ## 12 US                2011      1.00           1.00          1.00
    ## 13 WN                2011      1.00           1.00          1.00
    ## 14 XE                2011      1.00           1.00          1.00
    ## 15 YV                2011      2.00           1.00          1.00
    ## # ... with 36 more variables: DepTime_min <dbl>, ArrTime_min <dbl>,
    ## #   FlightNum_min <dbl>, TailNum_min <chr>, ActualElapsedTime_min <dbl>,
    ## #   AirTime_min <dbl>, ArrDelay_min <dbl>, DepDelay_min <dbl>,
    ## #   Origin_min <chr>, Dest_min <chr>, Distance_min <dbl>,
    ## #   TaxiIn_min <dbl>, TaxiOut_min <dbl>, Cancelled_min <dbl>,
    ## #   CancellationCode_min <chr>, Diverted_min <dbl>, Year_max <dbl>,
    ## #   Month_max <dbl>, DayofMonth_max <dbl>, DayOfWeek_max <dbl>,
    ## #   DepTime_max <dbl>, ArrTime_max <dbl>, FlightNum_max <dbl>,
    ## #   TailNum_max <chr>, ActualElapsedTime_max <dbl>, AirTime_max <dbl>,
    ## #   ArrDelay_max <dbl>, DepDelay_max <dbl>, Origin_max <chr>,
    ## #   Dest_max <chr>, Distance_max <dbl>, TaxiIn_max <dbl>,
    ## #   TaxiOut_max <dbl>, Cancelled_max <dbl>, CancellationCode_max <chr>,
    ## #   Diverted_max <dbl>

Notice how `.` matched all the columns and added two columns (min and max) for each column. Also, notice how this is a verbose version of the following call:

``` r
hflights %>% group_by(UniqueCarrier) %>% 
             summarise_all(funs(min, max), na.rm = TRUE)
```

    ## # A tibble: 15 x 41
    ##    UniqueCarrier Year_min Month_min DayofMonth_min DayOfWeek_min
    ##    <chr>            <dbl>     <dbl>          <dbl>         <dbl>
    ##  1 AA                2011      1.00           1.00          1.00
    ##  2 AS                2011      1.00           1.00          1.00
    ##  3 B6                2011      1.00           1.00          1.00
    ##  4 CO                2011      1.00           1.00          1.00
    ##  5 DL                2011      1.00           1.00          1.00
    ##  6 EV                2011      1.00           1.00          1.00
    ##  7 F9                2011      1.00           1.00          1.00
    ##  8 FL                2011      1.00           1.00          1.00
    ##  9 MQ                2011      1.00           1.00          1.00
    ## 10 OO                2011      1.00           1.00          1.00
    ## 11 UA                2011      1.00           1.00          1.00
    ## 12 US                2011      1.00           1.00          1.00
    ## 13 WN                2011      1.00           1.00          1.00
    ## 14 XE                2011      1.00           1.00          1.00
    ## 15 YV                2011      2.00           1.00          1.00
    ## # ... with 36 more variables: DepTime_min <dbl>, ArrTime_min <dbl>,
    ## #   FlightNum_min <dbl>, TailNum_min <chr>, ActualElapsedTime_min <dbl>,
    ## #   AirTime_min <dbl>, ArrDelay_min <dbl>, DepDelay_min <dbl>,
    ## #   Origin_min <chr>, Dest_min <chr>, Distance_min <dbl>,
    ## #   TaxiIn_min <dbl>, TaxiOut_min <dbl>, Cancelled_min <dbl>,
    ## #   CancellationCode_min <chr>, Diverted_min <dbl>, Year_max <dbl>,
    ## #   Month_max <dbl>, DayofMonth_max <dbl>, DayOfWeek_max <dbl>,
    ## #   DepTime_max <dbl>, ArrTime_max <dbl>, FlightNum_max <dbl>,
    ## #   TailNum_max <chr>, ActualElapsedTime_max <dbl>, AirTime_max <dbl>,
    ## #   ArrDelay_max <dbl>, DepDelay_max <dbl>, Origin_max <chr>,
    ## #   Dest_max <chr>, Distance_max <dbl>, TaxiIn_max <dbl>,
    ## #   TaxiOut_max <dbl>, Cancelled_max <dbl>, CancellationCode_max <chr>,
    ## #   Diverted_max <dbl>

Now to the original question

``` r
hflights %>% group_by(UniqueCarrier) %>% 
             summarize_at(c("ArrDelay", "DepDelay"), funs(min, max), na.rm = TRUE)
```

    ## # A tibble: 15 x 5
    ##    UniqueCarrier ArrDelay_min DepDelay_min ArrDelay_max DepDelay_max
    ##    <chr>                <dbl>        <dbl>        <dbl>        <dbl>
    ##  1 AA                   -39.0        -15.0        978          970  
    ##  2 AS                   -43.0        -15.0        183          172  
    ##  3 B6                   -44.0        -14.0        335          310  
    ##  4 CO                   -55.0        -18.0        957          981  
    ##  5 DL                   -32.0        -17.0        701          730  
    ##  6 EV                   -40.0        -18.0        469          479  
    ##  7 F9                   -24.0        -15.0        277          275  
    ##  8 FL                   -30.0        -14.0        500          507  
    ##  9 MQ                   -38.0        -23.0        918          931  
    ## 10 OO                   -57.0        -33.0        380          360  
    ## 11 UA                   -47.0        -11.0        861          869  
    ## 12 US                   -42.0        -17.0        433          425  
    ## 13 WN                   -44.0        -10.0        499          548  
    ## 14 XE                   -70.0        -19.0        634          628  
    ## 15 YV                   -32.0        -11.0         72.0         54.0
