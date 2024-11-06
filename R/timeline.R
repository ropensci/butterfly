#' timeline: check if a timeseries is continuous
#'
#' A loupe is a simple, small magnification device used to examine small details
#' more closely.
#'
#' @param df_current data.frame, the newest/current version of dataset x.
#' @param datetime_variable string, the "datetime" variable that should be
#' checked for continuity.
#' @param expected_lag numeric, the acceptable difference between timestep for
#' a timeseries to be classed as continuous. Any difference greater than
#' `expected_lag` will indicate a timeseries is not continuous. Default is 1.
#' The smallest units of measurement present in the column will be used. For
#' example in a column formatted YYYY-MM, month will be used. In a column
#' formatted YYYY-MM-DD day will be used.
#' @param direction character, is this timeseries orderd by ascending or by
#' descending?
#'
#' @seealso [timeline_group()]
#'
#' @returns A boolean, TRUE if the timeseries is continuous, and FALSE if there
#' are more than one continuous timeseries within the dataset.
#'
#' @examples
#' # This example contains no differences with previous data
#' # Our datetime column is formatted YYYY-MM-DD, and we expect an observation
#' # every month, therefore our expected lag is 31 (days).
#' butterfly::is_continuous_timelines(
#'   butterflycount$april,
#'   datetime_variable = "time",
#'   expected_lag = 31
#'   direction = "descending"
#' )
#'
#' @export
timeline <- function(
    df_current,
    datetime_variable,
    expected_lag = 1,
    direction = c("ascending", "descending")
) {

  df_timelines <- group_timelines(
    df_current,
    datetime_variable,
    expected_lag,
    direction
  )

  if (length(unique(df_timelines$continuous_timeline)) < 1) {
    is_continuous <- TRUE
  } else if (length(unique(df_timelines$continuous_timeline)) > 1 ) {
    is_continuous <- FALSE

    cli::cat_bullet(
      "There are time lags which are greater than the expected lag: ",
      deparse(substitute(expected_lag)),
      ". This indicates the timeseries is not continuous.",
      bullet = "info",
      col = "orange",
      bullet_col = "orange"
    )
  }
}
