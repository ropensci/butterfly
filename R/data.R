#' Butterfly count dummy data
#'
#' A completely fictional dataset of monthly butterfly counts
#'
#' @format ## `butterflycount`
#' A list with 4 dataframes (january, february, march, april) containing 3 columns, and 3 + n_month rows:
#' \describe{
#'   \item{time}{The date on which the imaginary count took place, in yyyy-mm-dd format}
#'   \item{count}{Number of fictional butterflies counted}
#'   \item{species}{Butterfly species name, only appears in april}
#'   ...
#' }
"butterflycount"

#' Forest precipitation dummy data
#'
#' A completely fictional dataset of daily precipitation
#'
#' @format ## `butterflycount`
#' A list with 2 dataframes (january, february) containing 2 columns,
#' and 6 rows. February intentionally resets to 1970-01-01
#' \describe{
#'   \item{time}{The date on which the imaginary rainfall was measured took
#'   place, in yyyy-mm-dd format}
#'   \item{rainfall_mm}{Rainfall in mm}
#'   ...
#' }
"forestprecipitation"
