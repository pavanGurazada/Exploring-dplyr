Programming with dplyr
================
Pavan Gurazada
February 2018

``` r
library(tidyverse)
```

This script is a heavy annotation of [Wickham](https://rpubs.com/hadley/dplyr-programming)

Nonstandard evaluation (NSE) of code allows the programmer to parse a user input before execution. This is important so that once can write code like so:

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
mtcars %>% filter(cyl == 6)
```

    ##    mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## 1 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## 2 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## 3 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## 4 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## 5 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## 6 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## 7 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6

Notice that in the above function call, the expression `cyl == 6` is parsed without execution by `filter` to execute the intention. This allows us to avoid code like so:

``` r
mtcars[mtcars$cyl == 6, ] 
```

    ##                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4      21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Valiant        18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Merc 280       19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C      17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6

However, because of this variables used as function parameters are limited by the function scope.

``` r
# myVar <- cyl # throws up an error
```

The following code also does not work as intended

``` r
myVar <- "cyl"

mtcars %>% filter(myVar == 6)
```

    ##  [1] mpg  cyl  disp hp   drat wt   qsec vs   am   gear carb
    ## <0 rows> (or 0-length row.names)

This is bad since the following code works

``` r
mtcars[["cyl"]] == mtcars$cyl
```

    ##  [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    ## [15] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    ## [29] TRUE TRUE TRUE TRUE

Clearly, such code requires evaluation of each of the elements of the expression.

In sum, the scope of the variables is lost when NSE is employed since the expression is not evaluated before modification. NSE is widespread through the `tidyverse` starting from `%>%`, where expressions on either side of the pipe operator are parsed before evaluation. NSE makes the user life easier since it produces easily readable code.

On the flip side, the scope of the variables is not clear from the expression and can often bite in the wrong places.

Not all verbs suffer from this scope restriction. For instance, `mutate` does not touch the data argument so one can write code like so:

``` r
mutate_y <- function(df) {
  df %>% mutate(y = a + x)
}
```

In the code above, the scope of `x` is within `df` but it also works if either `x` or `a` is a global variable. To get around this limitation, `.data` is used as a pronoun to clarify the scope:

``` r
mutate_y <- function(df) {
  df %>% mutate(y = .data$a + .data$x)
}
```

Using the code above generates an error if a local variable is absent.

The downside of automatic quoting employed by `dplyr` is that general functions employing verbs to automate repetitive tasks is not straight-forward.

What exactly is this quoting business? It is the act of capturing an unevaluated expression, exploited to dramatic effect in lienar models.

For instance, note the following three statements

``` r
letters[1:3] 
```

    ## [1] "a" "b" "c"

``` r
quote(letters[1:3])
```

    ## letters[1:3]

``` r
~letters[1:3]
```

    ## ~letters[1:3]

As noted in a separate notebook, `~` is a better option because the context of the expression is also captured. This enables the mixing of variables in various contexts. For e.g.,

``` r
myCyl <- 10000
mtcars %>% summarize(Mean = mean(cyl) * myCyl)
```

    ##    Mean
    ## 1 61875

Lets put it all together in the example from the Master.

``` r
df <- data_frame(g1 = c(1, 1, 2, 2, 2),
                 g2 = c(1, 2, 1, 2, 1),
                 a = sample(5),
                 b = sample(5))

df %>% group_by(g1) %>% 
       summarize(Mean = mean(a))
```

    ## # A tibble: 2 x 2
    ##      g1  Mean
    ##   <dbl> <dbl>
    ## 1  1.00  4.00
    ## 2  2.00  2.33

We might want to avoid duplication of this by writing up the following function

``` r
makeSummary <-  function(df, groupingVariable) {
  df %>% group_by(groupingVariable) %>% 
         summarize(Mean = mean(a))
}

# makeSummary(df, g1) # Throws up error on the groupingVariable
# makeSummary(df, "g2") # Throws up error on the groupingVariable
```

Clearly, `group_by()` does not evaulate its input. For this code to work, We need to do two things:

1.  Quote the `groupingVariable` manually. We saw earlier that one way to make this happen is to use the formula operator `~`. The `tidyverse` recommendation to accomplish this is to use the `quo()` function

2.  Tell `group_by()` to stop quoting the input `groupingVariable`. We do this by using `!!`

With these changes, the function definition now becomes:

``` r
makeSummary <- function(df, groupingVariable) {
  df %>% group_by(!!groupingVariable) %>% 
         summarize(Mean = mean(a))
}

makeSummary(df, quo(g1))
```

    ## # A tibble: 2 x 2
    ##      g1  Mean
    ##   <dbl> <dbl>
    ## 1  1.00  4.00
    ## 2  2.00  2.33

The usage of `quo` as a function argument is still ugly.

The resolution of such ugliness is by using the scoped variants of the verbs They take in the column names as strings and allow the programmer to avoid the `quo()` and `!!`

``` r
makeSummary <- function(df, groupingVariable) {
  df %>% group_by_at(groupingVariable) %>% 
         summarize(Mean = mean(a))
}

makeSummary(df, "g1")
```

    ## # A tibble: 2 x 2
    ##      g1  Mean
    ##   <dbl> <dbl>
    ## 1  1.00  4.00
    ## 2  2.00  2.33

``` r
makeSummary(df, "g2")
```

    ## # A tibble: 2 x 2
    ##      g2  Mean
    ##   <dbl> <dbl>
    ## 1  1.00  3.33
    ## 2  2.00  2.50

Moral: Scoped versions of the verbs are a real life-saver
