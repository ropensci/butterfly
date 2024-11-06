#' group_timelines: check if a timeseries is continuous
#'
#' If after using `timeline()` you have established a timeseries is not
#' continuous, or if you are working with data where you expect distinct
#' sequences or events, you can use `group_timelines()` to extract and
#' classify different distinct continuous chunks of your data.
#'
#' We attempt to do this without sorting, or changing the data for a couple
#' of reasons:
#'
#' 1. There are no difference in dates:
#' Some instruments might record dates that appear identical,
#' but are still in chronological order. For example, high-frequency data
#' in fractional seconds. This is a rare use case though.
#'
#' 2. Dates are generally ascending/descending, but the instrument has
#' returned to origin. Probably more common, and will results in a
#' non-continuous dataset, however the records are still in chronological order
#' This is something we would like to discover. This is accounted for in the
#' logic in case_when().
#'
#' @param df_current data.frame, the newest/current version of dataset x.
#' @param datetime_variable string, the "datetime" variable that should be
#' checked for continuity.
#' @param expected_lag numeric, the acceptable difference between timestep for
#' a timeseries to be classed as continuous. Any difference greater than
#' `expected_lag` will indicate a timeseries is not continuous. Default is 1.
#' The smallest units of measurement present in the column will be used. In a
#' column formatted YYYY-MM-DD day will be used.
#'
#' @returns A data.frame, identical to `df_current`, but with extra columns
#' `timeline_group`, which assigns a number to each continuous sets of
#' data and `timelag` which specifies the time lags between rows.
#'
#' @examples
#' butterfly::group_timelines(
#'   forestprecipitation$january,
#'   datetime_variable = "time",
#'   expected_lag = 1
#' )
#'
#' @importFrom rlang .data
#'
#' @export
group_timelines <- function(
    df_current,
    datetime_variable,
    expected_lag = 1
) {
  stopifnot("`df_current` must be a data.frame" = is.data.frame(df_current))
  stopifnot("`expected_lag` must be numeric" = is.numeric(expected_lag))

  # Check if `datetime_variable` is in `df_current`
  if (!datetime_variable %in% names(df_current)) {
    cli::cli_abort(
      "`datetime_variable` must be present in `df_current`"
    )
  }

  # Check if datetime_variable can be used by lag
  if (
    inherits(
      df_current[[datetime_variable]],
      c("POSIXct", "POSIXlt", "POSIXt", "Date")
    ) == FALSE
  ) {
    cli::cli_abort(
      "`datetime_variable` must be class of POSIXct, POSIXlt, POSIXt, Date"
    )
  }

  # Obtain distinct sequences of continuous measurement
  df_timeline <- df_current |>
    dplyr::mutate(
      timelag = (
        .data[[datetime_variable]] - dplyr::lag(
          .data[[datetime_variable]],
          1
        )
      )
    ) |>
    dplyr::mutate(
      timeline_group1 = dplyr::case_when(
        # Include negative timelag, for example if a sensor cpu shuts down
        # It can return to its original date (e.g. 1970-01-01 or when it was
        # deployed)
        is.na(timelag) | timelag > expected_lag | timelag < -expected_lag ~ 1,
        TRUE ~ 2
      )
    ) |>
    dplyr::mutate(
      timeline_group = cumsum(.data$timeline_group1 == 1)
    ) |>
    dplyr::select(
      -"timeline_group1"
    )

  return(df_timeline)
}
