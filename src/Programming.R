#' ---
#' title: "Programming with dplyr "
#' author: Pavan Gurazada
#' date: "February 2018"
#' output: github_document
#' ---

library(tidyverse)

#'This script is a heavy annotation of
#'[Wickham](https://rpubs.com/hadley/dplyr-programming)
#'
#'Nonstandard evaluation (NSE) of code allows the programmer to parse a user input
#'before execution. This is important so that once can write code like so:

glimpse(mtcars)
mtcars %>% filter(cyl == 6)

#' Notice that in the above function call, the expression `cyl == 6` 
#' is parsed without execution by `filter` to execute the intention. This allows
#' us to avoid code like so:

mtcars[mtcars$cyl == 6, ] 

#' However, because of this variables used as function parameters are limited
#' by the function scope. 

# myVar <- cyl # throws up an error

#' The following code also does not work as intended

myVar <- "cyl"

mtcars %>% filter(myVar == 6)

#' This is bad since the following code works 

mtcars[["cyl"]] == mtcars$cyl

#' Clearly, such code requires evaluation of each of the elements of the
#' expression.
#'
#' In sum, the scope of the variables is lost when NSE is employed since the
#' expression is not evaluated before modification. NSE is widespread through
#' the `tidyverse` starting from `%>%`, where expressions on either side of the
#' pipe operator are parsed before evaluation. NSE makes the user life easier
#' since it produces easily readable code.
#'
#' On the flip side, the scope of the variables is not clear from the expression
#' and can often bite in the wrong places.
#'
#' Not all verbs suffer from this scope restriction. For instance, `mutate` does
#' not touch the data argument so one can write code like so:

mutate_y <- function(df) {
  df %>% mutate(y = a + x)
}

#' In the code above, the scope of `x` is within `df` but it also works if either
#' `x` or `a` is a global variable. To get around this limitation, `.data` is used
#' as a pronoun to clarify the scope:

mutate_y <- function(df) {
  df %>% mutate(y = .data$a + .data$x)
}

#' Using the code above generates an error if a local variable is absent.
#'
#' The downside of automatic quoting employed by `dplyr` is that general
#' functions employing verbs to automate repetitive tasks is not
#' straight-forward.
#'
#' What exactly is this quoting business? It is the act of capturing an
#' unevaluated expression, exploited to dramatic effect in lienar models.
#'
#' For instance, note the following three statements 

letters[1:3] 
quote(letters[1:3])
~letters[1:3]

#' As noted in a separate notebook, `~` is a better option because the context of
#' the expression is also captured. This enables the mixing of variables in various contexts.
#' For e.g.,

myCyl <- 10000
mtcars %>% summarize(Mean = mean(cyl) * myCyl)

#' Lets put it all together in the example from the Master.

df <- data_frame(g1 = c(1, 1, 2, 2, 2),
                 g2 = c(1, 2, 1, 2, 1),
                 a = sample(5),
                 b = sample(5))

df %>% group_by(g1) %>% 
       summarize(Mean = mean(a))

#' We might want to avoid duplication of this by writing up the following
#' function

makeSummary <-  function(df, groupingVariable) {
  df %>% group_by(groupingVariable) %>% 
         summarize(Mean = mean(a))
}

# makeSummary(df, g1) # Throws up error on the groupingVariable
# makeSummary(df, "g2") # Throws up error on the groupingVariable

#' Clearly, `group_by()` does not evaulate its input. For this code to work, We
#' need to do two things: 1. Quote the `groupingVariable` manually. We saw
#' earlier that one way to make this happen is to use the formula operator `~`.
#' The `tidyverse` recommendation to accomplish this is to use the `quo()`
#' function
#'
#' 2. Tell `group_by()` to stop quoting the input `groupingVariable`. We do this 
#' by using `!!`
#' 
#' With these changes, the function definition now becomes:

makeSummary <- function(df, groupingVariable) {
  df %>% group_by(!!groupingVariable) %>% 
         summarize(Mean = mean(a))
}

makeSummary(df, quo(g1))

#' The usage of `quo` as a function argument is still ugly.
#' 
#' The resolution of such ugliness is by using the scoped variants of the verbs
#' They take in the column names as strings and allow the programmer to avoid the
#' `quo()` and `!!`

makeSummary <- function(df, groupingVariable) {
  df %>% group_by_at(groupingVariable) %>% 
         summarize(Mean = mean(a))
}

makeSummary(df, "g1")
makeSummary(df, "g2")

#' Moral: Scoped versions of the verbs are a real life-saver
