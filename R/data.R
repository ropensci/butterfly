#' Butterfly count dummy data
#'
#' A completely fictional dataset of monthly butterfly counts
#'
#' @format ## `butterflycount`
#' A list with 5 dataframes (january, february, march, april, may) containing
#' 3 columns, and 3 + n_month rows:
#' \describe{
#'   \item{time}{The date on which the imaginary count took place,
#'   in yyyy-mm-dd format}
#'   \item{count}{Number of fictional butterflies counted}
#'   \item{species}{Butterfly species name, only appears in april}
#'   ...
#' }
"butterflycount"

#' Forest precipitation dummy data
#'
#' A completely fictional dataset of daily precipitation
#'
#' @format ## `forestprecipitation`
#' A list with 2 dataframes (january, february) containing 2 columns,
#' and 6 rows. February intentionally resets to 1970-01-01
#' \describe{
#'   \item{time}{The date on which the imaginary rainfall was measured took
#'   place, in yyyy-mm-dd format}
#'   \item{rainfall_mm}{Rainfall in mm}
#'   ...
#' }
"forestprecipitation"

#' Butterfly count messy data
#'
#' A version of butterflycount made messy using the messy package. This dataset
#' is only used for testing purposes
#'
#' @format ## `butterflymess`
#' A list with 5 dataframes (january, february, march, april, may) containing
#' 3 columns, and 3 + n_month rows:
#' \describe{
#'  \item{time}{The date on which the imaginary, and messy, count took place,
#'  in yyyy-mm-dd format}
#'  \item{count}{Number of fictional butterflies counted}
#'  \item{species}{Butterfly species name, only appears in april}
#'  ...
#' }
"butterflymess"
