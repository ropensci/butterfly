
<!-- README.md is generated from README.Rmd. Please edit that file -->

# butterfly <a href="https://thomaszwagerman.github.io/butterfly/"><img src="man/figures/logo.png" align="right" height="139" alt="butterfly website" /></a>

<!-- badges: start -->

[![R-CMD-check](https://github.com/thomaszwagerman/butterfly/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/thomaszwagerman/butterfly/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/thomaszwagerman/butterfly/branch/main/graph/badge.svg)](https://app.codecov.io/gh/thomaszwagerman/butterfly?branch=main)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of butterfly is to aid in the quality assurance of continually
updating and overwritten time-series data, where we expect new values
over time, but want to ensure previous data remains unchanged.

<img src="man/figures/README-butterfly_diagram.png" width="100%" />

Data previously recorded could change for a number of reasons, such as
discovery of an error in model code, a change in methodology or
instrument recalibration. Monitoring data sources for these changes is
not always possible.

Unnoticed changes in previous data could have unintended consequences,
such as invalidating DOIs, or altering future predictions if used as
input in forecasting models.

This package provides functionality that can be used as part of a data
pipeline, to check and flag changes to previous data to prevent changes
going unnoticed.

## Installation

You can install the development version of butterfly from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("thomaszwagerman/butterfly")
```

## Overview

The butterfly package contains the following:

- `butterfly::loupe()` - examines in detail whether previous values have
  changed, and returns TRUE/FALSE for no change/change.
- `butterfly::catch()` - returns rows which contain previously changed
  values in a dataframe.
- `butterfly::release()` - drops rows which contain previously changed
  values, and returns a dataframe containing new and unchanged rows.
- `butterfly::create_object_list()` - returns a list of objects required
  by all of `loupe()`, `catch()` and `release()`. Contains underlying
  functionality.
- `butterflycount` - a list of monthly dataframes, which contain
  fictional butterfly counts for a given date.

## Examples

This is a basic example which shows you how to use butterfly:

``` r
library(butterfly)

# Imagine a continually updated dataset that starts in January and is updated once a month
butterflycount$january
#>         time count
#> 1 2024-01-01    22
#> 2 2023-12-01    55
#> 3 2023-11-01    11

# In February an additional row appears, all previous data remains the same
butterflycount$february
#>         time count
#> 1 2024-02-01    17
#> 2 2024-01-01    22
#> 3 2023-12-01    55
#> 4 2023-11-01    11

# In March an additional row appears again
# ...but a previous value has unexpectedly changed
butterflycount$march
#>         time count
#> 1 2024-03-01    23
#> 2 2024-02-01    17
#> 3 2024-01-01    22
#> 4 2023-12-01    55
#> 5 2023-11-01    18
```

We can use `butterfly::loupe()` to examine in detail whether previous
values have changed.

``` r
butterfly::loupe(
  butterflycount$february,
  butterflycount$january,
  datetime_variable = "time"
)
#> The following rows are new in 'df_current': 
#>         time count
#> 1 2024-02-01    17
#> ✔ And there are no differences with previous data.
#> [1] TRUE

butterfly::loupe(
  butterflycount$march,
  butterflycount$february,
  datetime_variable = "time"
)
#> The following rows are new in 'df_current': 
#>         time count
#> 1 2024-03-01    23
#> 
#> ℹ The following values have changes from the previous data.
#> old vs new
#>            count
#>   old[1, ]    17
#>   old[2, ]    22
#>   old[3, ]    55
#> - old[4, ]    18
#> + new[4, ]    11
#> 
#> `old$count`: 17 22 55 18
#> `new$count`: 17 22 55 11
#> [1] FALSE
```

`butterfly::loupe()` uses `dplyr::semi_join()` to match the new and old
objects using a common unique identifier, which in a timeseries will be
the timestep. `waldo::compare()` is then used to compare these and
provide a detailed report of the differences.

`butterfly` follows the `waldo` philosophy of erring on the side of
providing too much information, rather than too little. It will give a
detailed feedback message on the status between two objects.

### Using butterfly for data wrangling

You might want to return changed rows as a dataframe, or drop them
altogether. For this `butterfly::catch()` and `butterfly::release()` are
provided.

Here, `butterfly::catch()` only returns rows which have **changed** from
the previous version. It will not return new rows.

``` r
df_caught <- butterfly::catch(
  butterflycount$march,
  butterflycount$february,
  datetime_variable = "time"
)
#> The following rows are new in 'df_current': 
#>         time count
#> 1 2024-03-01    23
#> 
#> ℹ The following values have changes from the previous data.
#> old vs new
#>            count
#>   old[1, ]    17
#>   old[2, ]    22
#>   old[3, ]    55
#> - old[4, ]    18
#> + new[4, ]    11
#> 
#> `old$count`: 17 22 55 18
#> `new$count`: 17 22 55 11
#> 
#> ℹ Only these rows are returned.

df_caught
#>         time count
#> 1 2023-11-01    18
```

Conversely, `butterfly::release()` drops all rows which had changed from
the previous version. Note it retains new rows, as these were expected.

``` r
df_released <- butterfly::release(
  butterflycount$march,
  butterflycount$february,
  datetime_variable = "time"
)
#> The following rows are new in 'df_current': 
#>         time count
#> 1 2024-03-01    23
#> 
#> ℹ The following values have changes from the previous data.
#> old vs new
#>            count
#>   old[1, ]    17
#>   old[2, ]    22
#>   old[3, ]    55
#> - old[4, ]    18
#> + new[4, ]    11
#> 
#> `old$count`: 17 22 55 18
#> `new$count`: 17 22 55 11
#> 
#> ℹ These will be dropped, but new rows are included.

df_released
#>         time count
#> 1 2024-03-01    23
#> 2 2024-02-01    17
#> 3 2024-01-01    22
#> 4 2023-12-01    55
```

## Relevant packages and functions

The butterfly package was created for a specific use case of handling
continuously updating/overwritten time-series data, where previous
values may change without notice.

There are other R packages and functions which handle object comparison,
which may suit your specific needs better:

- [waldo](https://github.com/r-lib/waldo)
- [diffdf](https://github.com/gowerc/diffdf)
- [assertr](https://github.com/tonyfischetti/assertr)
- [daquiri](https://github.com/ropensci/daiquiri/)

Other functions include `all.equal()` or
[dplyr](https://github.com/tidyverse/dplyr)’s `setdiff()`
