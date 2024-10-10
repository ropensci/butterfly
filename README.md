
<!-- README.md is generated from README.Rmd. Please edit that file -->

# butterfly

<!-- badges: start -->
<!-- badges: end -->

The goal of butterfly is to aid in the QA/QC of continually
updating/overwritten time-series data where we expect new values over
time, but where we want to ensure previous data remains unchanged. Data
previously recorded or calculated might change due equipment
recalibration, discovery of human error in model code or a change in
methodology.

This could have unintended consequences, as changes to previous input
data may also alter future predictions in forecasting models.

The butterfly package aims to flag changes to previous data to prevent
data changes going unnoticed.

## Installation

You can install the development version of butterfly from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("thomaszwagerman/butterfly")
```

## Example

This is a basic example which shows you how to use butterfly:

``` r
library(butterfly)

# Imagine a continually updated dataset, say once a month
jan <- data.frame(
  time = c("2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(0.45, 0.33, 0.24)
)

# In February an additional row appears, all previous data remains the same
feb <- data.frame(
  time = c("2024-02-01", "2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(1.75, 0.45, 0.33, 0.24)
)

# In March an additional row appears again
# ...but a previous value has unexpectedly changed
mar <- data.frame(
  time = c("2024-03-01", "2024-02-01", "2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(2.22, 1.75, 0.45, 1.33, 0.24)
)

# Let's use butterfly() to check if our previous values have changed
# And if so, where this change occurred
butterfly(
  feb,
  jan,
  datetime_variable = "time"
)
#> ✔ No differences

butterfly(
  mar,
  feb,
  datetime_variable = "time"
)
#> old vs new
#>            value
#>   old[1, ]  1.75
#>   old[2, ]  0.45
#> - old[3, ]  1.33
#> + new[3, ]  0.33
#>   old[4, ]  0.24
#> 
#> `old$value`: 2 0 1 0
#> `new$value`: 2 0 0 0
```

## Why butterfly

But why butterfly, are there no other method to do this?

``` r
library(butterfly)

# Imagine a continually updated dataset, say once a month
jan <- data.frame(
  time = c("2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(0.45, 0.33, 0.24)
)

# In February an additional row appears, all remaining data remains the same
feb <- data.frame(
  time = c("2024-02-01", "2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(1.75, 0.45, 0.33, 0.24)
)

#In March an additional row appears again
# ...but a previous value has unexpectedly changed
mar <- data.frame(
  time = c("2024-03-01", "2024-02-01", "2024-01-01", "2023-12-01", "2023-11-01"),
  value = c(2.22, 1.75, 0.45, 1.33, 0.24)
)

# There are several methods of checking difference in dataframes
all.equal(
  feb,
  jan
)
#> [1] "Attributes: < Component \"row.names\": Numeric: lengths (4, 3) differ >"
#> [2] "Component \"time\": Lengths (4, 3) differ (string compare on first 3)"  
#> [3] "Component \"time\": 3 string mismatches"                                
#> [4] "Component \"value\": Numeric: lengths (4, 3) differ"

# However in our case, these are not helpful or consistent
library(diffdf)
diffdf(
  feb,
  jan
)
#> Warning in diffdf(feb, jan): 
#> There are rows in BASE that are not in COMPARE !!
#> Not all Values Compared Equal
#> Differences found between the objects!
#> 
#> Summary of BASE and COMPARE
#>   ====================================
#>     PROPERTY      BASE        COMP    
#>   ------------------------------------
#>       Name        feb         jan     
#>      Class     data.frame  data.frame 
#>     Rows(#)        4           3      
#>    Columns(#)      2           2      
#>   ------------------------------------
#> 
#> 
#> There are rows in BASE that are not in COMPARE !!
#>   ===============
#>    ..ROWNUMBER.. 
#>   ---------------
#>          4       
#>   ---------------
#> 
#> 
#> Not all Values Compared Equal
#>   =============================
#>    Variable  No of Differences 
#>   -----------------------------
#>      time            3         
#>     value            3         
#>   -----------------------------
#> 
#> 
#>   =================================================
#>    VARIABLE  ..ROWNUMBER..     BASE      COMPARE   
#>   -------------------------------------------------
#>      time          1        2024-02-01  2024-01-01 
#>      time          2        2024-01-01  2023-12-01 
#>      time          3        2023-12-01  2023-11-01 
#>   -------------------------------------------------
#> 
#> 
#>   ========================================
#>    VARIABLE  ..ROWNUMBER..  BASE  COMPARE 
#>   ----------------------------------------
#>     value          1        1.75   0.45   
#>     value          2        0.45   0.33   
#>     value          3        0.33   0.24   
#>   ----------------------------------------

diffdf(
  jan,
  feb
)
#> Warning in diffdf(jan, feb): 
#> There are rows in COMPARE that are not in BASE !!
#> Not all Values Compared Equal
#> Differences found between the objects!
#> 
#> Summary of BASE and COMPARE
#>   ====================================
#>     PROPERTY      BASE        COMP    
#>   ------------------------------------
#>       Name        jan         feb     
#>      Class     data.frame  data.frame 
#>     Rows(#)        3           4      
#>    Columns(#)      2           2      
#>   ------------------------------------
#> 
#> 
#> There are rows in COMPARE that are not in BASE !!
#>   ===============
#>    ..ROWNUMBER.. 
#>   ---------------
#>          4       
#>   ---------------
#> 
#> 
#> Not all Values Compared Equal
#>   =============================
#>    Variable  No of Differences 
#>   -----------------------------
#>      time            3         
#>     value            3         
#>   -----------------------------
#> 
#> 
#>   =================================================
#>    VARIABLE  ..ROWNUMBER..     BASE      COMPARE   
#>   -------------------------------------------------
#>      time          1        2024-01-01  2024-02-01 
#>      time          2        2023-12-01  2024-01-01 
#>      time          3        2023-11-01  2023-12-01 
#>   -------------------------------------------------
#> 
#> 
#>   ========================================
#>    VARIABLE  ..ROWNUMBER..  BASE  COMPARE 
#>   ----------------------------------------
#>     value          1        0.45   1.75   
#>     value          2        0.33   0.45   
#>     value          3        0.24   0.33   
#>   ----------------------------------------

# Regardless of order, diffdf tells us row 4 is different. 
# This is correct, but our "top" row (ie our newest value) has changed

# The waldo package does a slightly better job in showing this positional difference
library(waldo)
compare(
  feb,
  jan
)
#> `attr(old, 'row.names')`: 1 2 3 4
#> `attr(new, 'row.names')`: 1 2 3  
#> 
#> old vs new
#>                  time value
#> - old[1, ] 2024-02-01  1.75
#>   old[2, ] 2024-01-01  0.45
#>   old[3, ] 2023-12-01  0.33
#>   old[4, ] 2023-11-01  0.24
#> 
#> `old$time`: "2024-02-01" "2024-01-01" "2023-12-01" "2023-11-01"
#> `new$time`:              "2024-01-01" "2023-12-01" "2023-11-01"
#> 
#> `old$value`: 1.75 0.45 0.33 0.24
#> `new$value`:      0.45 0.33 0.24
# But we can't use its output

# Dplyr's setdiff is useful to extract these differences
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
setdiff(
  feb,
  jan
)
#>         time value
#> 1 2024-02-01  1.75

# And intersect is useful to get an object to for the "old" data
intersect(
  feb,
  jan
)
#>         time value
#> 1 2024-01-01  0.45
#> 2 2023-12-01  0.33
#> 3 2023-11-01  0.24

# We expect the new row to be different, but we want to compare old values separately 
# In March an additional row appears again, but a previous value changes
setdiff(
  mar,
  feb
)
#>         time value
#> 1 2024-03-01  2.22
#> 2 2023-12-01  1.33

# Now a second value is extracted, but this is new and old data together.

# A way to circumvent this is to use the unique identifyer (in this case `time`)
anti_join(
  mar,
  feb,
  by = "time"
)
#>         time value
#> 1 2024-03-01  2.22

# This extracts the "new" value, without also returning the changed "old" value
# ie the time in March but not in Feb
anti_join(
  mar,
  feb,
  by = "time"
)
#>         time value
#> 1 2024-03-01  2.22

# This extract the rows where time in March matches Feb
mar_old <- semi_join(
  mar,
  feb,
  by = "time"
)

# This is the principle butterfly is built on:
butterfly(
  feb,
  jan,
  datetime_variable = "time"
)
#> ✔ No differences
```

## Relevant packages and functions

The butterfly package was created for a specific use case of handling
continuously updating/overwritten time-series data, where previous
values may change without notice. There are other R packages and
functions which handle object comparison, which may suit your specific
needs better:

- [waldo](https://github.com/r-lib/waldo)
- [diffdf](https://github.com/gowerc/diffdf)

Other functions include `all.equal()` or
[dplyr](https://github.com/tidyverse/dplyr)’s `setdiff()`
