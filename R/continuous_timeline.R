#' get_continuous_timelines: check if a timeseries is continuous
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
#' @returns A data.frame, identical to `df_current`, but with extra columns
#' `timeline_group`, which assigns a number to each continuous sets of
#' data and `timelag` which specifies the time lags between rows.
#'
#' @examples
#' # This example contains no differences with previous data
#' # Our datetime column is formatted YYYY-MM-DD, and we expect an observation
#' # every month, therefore our expected lag is 31 (days).
#' butterfly::get_continuous_timelines(
#'   butterflycount$april,
#'   datetime_variable = "time",
#'   expected_lag = 31
#'   direction = "descending"
#' )
#'
#' @export
group_timelines <- function(
    df_current,
    datetime_variable,
    expected_lag = 1,
    direction = c("ascending", "descending")
) {
  stopifnot("`df_current` must be a data.frame" = is.data.frame(df_current))

  # Check if `datetime_variable` is in `df_current`
  if (!datetime_variable %in% names(df_current)) {
    cli::cli_abort(
      "`datetime_variable` must be present in `df_current`"
    )
  }
  # A direction multiplier will allow checking of expected lag difference
  # in both ascending and descending datasets, without reordering or changing
  # the dataset itself
  if (direction == "ascending") {
    direction_multiplier <- 1
  } else if (direction == "descending") {
    direction_multiplier <- -1
  }

  # Check if datetime_variable can be used by lag
  if (
    inherits(
      df_current[[datetime_variable]],
      c("POSIXct", "POSIXlt", "POSIXt", "Date")
    ) == FALSE
  ) {
    df_current[[datetime_variable]] <- as.POSIXlt(
      df_current[[datetime_variable]]
    )
  }

  # Obtain distinct sequences of continuous measurement
  df_timeline <- df_current |>
    dplyr::mutate(
      timelag = (time - dplyr::lag(time, 1)) * direction_multiplier
    ) |>
    dplyr::mutate(
      timeline_group1 = dplyr::case_when(
        # Include negative timelag, for example if a sensor cpu shuts down
        # It can return to its original date (e.g. 1970-01-01 or when it was
        # deployed)
        is.na(timelag) |
          timelag > expected_lag  ~ 1 |
          timelag < -expected_lag,
        TRUE ~ 2
      )
    ) |>
    dplyr::mutate(
      timeline_group = cumsum(timeline_group1 == 1)
    ) |>
    dplyr::select(
      -timeline_group
    )

  return(df_timeline)
}
