#' timeline: check if a timeseries is continuous
#'
#' Check if a timeseries is continuous. Even if a timeseries does not contain
#' obvious gaps, this does not automatically mean it is also continuous.
#'
#' Measuring instruments can have different behaviours when they fail. For
#' example, during power failure an internal clock could reset to "1970-01-01",
#' or the manufacturing date (say, "2021-01-01"). This leads to unpredictable
#' ways of checking if a dataset is continuous.
#'
#' The `group_timelines()` and `timeline()` functions attempt to give the user
#' control over how to check for continuity by providing an `expected_lag`. The
#' difference between timesteps in a dataset should not exceed the
#' `expected_lag`.
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
#'
#' @seealso [group_timelines()]
#'
#' @returns A boolean, TRUE if the timeseries is continuous, and FALSE if there
#' are more than one continuous timeseries within the dataset.
#'
#' @examples
#' # This example contains no differences with previous data
#' # Our datetime column is formatted YYYY-MM-DD, and we expect an observation
#' # every month, therefore our expected lag is 31 (days).
#' butterfly::timeline(
#'   butterflycount$april,
#'   datetime_variable = "time",
#'   expected_lag = 31
#' )
#'
#' @export
timeline <- function(
    df_current,
    datetime_variable,
    expected_lag = 1
) {

  df_timelines <- group_timelines(
    df_current,
    datetime_variable,
    expected_lag
  )

  if (length(unique(df_timelines$timeline_group)) == 1) {
    is_continuous <- TRUE

    cli::cat_bullet(
      "There are no time lags which are greater than the expected lag: ",
      deparse(substitute(expected_lag)),
      " ",
      units(df_timelines$timelag),
      ". By this measure, the timeseries is continuous.",
      bullet = "tick",
      col = "green",
      bullet_col = "green"
    )

  } else if (length(unique(df_timelines$timeline_group)) > 1 ) {
    is_continuous <- FALSE

    cli::cat_bullet(
      "There are time lags which are greater than the expected lag: ",
      deparse(substitute(expected_lag)),
      " ",
      units(df_timelines$timelag),
      ". This indicates the timeseries is not continuous. There are ",
      length(unique(df_timelines$timeline_group)),
      " distinct continuous sequences. Use `group_timelines()` to extract.",
      bullet = "info",
      col = "orange",
      bullet_col = "orange"
      )
  }

  return(is_continuous)
}


