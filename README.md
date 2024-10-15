
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

<div class="figure">

<img src="man/figures/README-butterfly_diagram.png" alt="A nice image." width="50%" />
<p class="caption">
A nice image.
</p>

</div>

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
```

We can use `butterfly()` to check if our previous values have changed.

``` r
# Let's use butterfly() to check if our previous values have changed
# And if so, where this change occurred
butterfly(
  feb,
  jan,
  datetime_variable = "time"
)
#> The following rows are new in 'feb': 
#>         time value
#> 1 2024-02-01  1.75
#> ✔ And there are no differences with previous data.

butterfly(
  mar,
  feb,
  datetime_variable = "time"
)
#> The following rows are new in 'mar': 
#>         time value
#> 1 2024-03-01  2.22
#> 
#> ℹ But the following values have changes from the previous data:
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

`butterfly()` uses `dplyr::semi_join()` to match the timesteps of your
current dataframe, to the timesteps already present in the previous
dataframe. `waldo::compare()` is then used to compare these and return
the differences.

`butterfly()` follows the `waldo` philosophy of erring on the side of
providing too much information, rather than too little. It will give a
detailed feedback message on the status between two objects.

### Using butterfly for data wrangling

You might want to return changed rows as a dataframe, or drop them
altogether. For this `butterfly_catch()` and `butterfly_release()` are
provided.

Here, `butterfly_catch()` only returns rows which have **changed** from
the previous version. It will not return new rows.

``` r
df_caught <- butterfly_catch(
  mar,
  feb,
  datetime_variable = "time"
)
#> The following rows are new in 'mar': 
#>         time value
#> 1 2024-03-01  2.22
#> 
#> ℹ The following rows have changed from the previous data, and will be returned:
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

df_caught
#>         time value
#> 1 2023-12-01  1.33
```

Conversely, `butterfly_release()` drops all rows which had changed from
the previous version. Note it retains new rows, as these were expected.

``` r
df_released <- butterfly_release(
  mar,
  feb,
  datetime_variable = "time"
)
#> The following rows are new in 'mar': 
#>         time value
#> 1 2024-03-01  2.22
#> 
#> ℹ The following rows have changed from the previous data, and will be dropped:
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

df_released
#>         time value
#> 1 2024-03-01  2.22
#> 2 2024-02-01  1.75
#> 3 2024-01-01  0.45
#> 4 2023-11-01  0.24
```

## Relevant packages and functions

The butterfly package was created for a specific use case of handling
continuously updating/overwritten time-series data, where previous
values may change without notice.

There are other R packages and functions which handle object comparison,
which may suit your specific needs better:

- [waldo](https://github.com/r-lib/waldo)
- [diffdf](https://github.com/gowerc/diffdf)

Other functions include `all.equal()` or
[dplyr](https://github.com/tidyverse/dplyr)’s `setdiff()`

## Rationale

There are a lot of other data comparison and QA/QC packages out there,
why butterfly?

This package was originally developed to deal with
[ERA5](https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels?tab=documentation)’s
initial release data, ERA5T. ERA5T data for a month is overwritten with
the final ERA5 data two months after the month in question.

Usually ERA5 and ERA5T are identical, but occasionally an issue with
input data can (for example for [09/21 -
12/21](https://confluence.ecmwf.int/display/CKB/ERA5T+issue+in+snow+depth),
and
[07/24](https://forum.ecmwf.int/t/final-validated-era5-product-to-differ-from-era5t-in-july-2024/6685))
force a recalculation, meaning previously published data differs from
the final product.

When publishing ERA5-derived datasets, and minting it with a DOI, it is
possible to continuously append without invalidating that DOI. However,
recalculation would overwrite previously published data, thereby forcing
a new publication and DOI to be minted. We use the functionality in this
package to detect changes, stop data transfer and notify the user.

This package has intentionally been generalised to accommodate other,
but similar, use cases. Other examples could include a correction in
instrument calibration, compromised data transfer or unnoticed changes
in the parameterisation of a model.
