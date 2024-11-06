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
#' The `timeline_group()` and `timeline()` functions attempt to give the user
#' control over how to check for continuity by providing an `expected_lag`. The
#' difference between timesteps in a dataset should not exceed the
#' `expected_lag`.
#'
#' @inheritParams timeline_group
#'
#' @seealso [timeline_group()]
#'
#' @returns A boolean, TRUE if the timeseries is continuous, and FALSE if there
#' are more than one continuous timeseries within the dataset.
#'
#' @examples
#' # A nice continuous dataset should return TRUE
#' butterfly::timeline(
#'   forestprecipitation$january,
#'   datetime_variable = "time",
#'   expected_lag = 1
#' )
#'
#' # In February, our imaginary rain gauge's onboard computer had a failure.
#' # The timestamp was reset to 1970-01-01
#' butterfly::timeline(
#'   forestprecipitation$february,
#'   datetime_variable = "time",
#'   expected_lag = 1
#' )
#'
#' @export
timeline <- function(
    df_current,
    datetime_variable,
    expected_lag = 1
) {

  df_timelines <- timeline_group(
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
      " distinct continuous sequences. Use `timeline_group()` to extract.",
      bullet = "info",
      col = "orange",
      bullet_col = "orange"
      )
  }

  return(is_continuous)
}


