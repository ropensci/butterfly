#' Loupe: compare previous data in continuously updated timeseries
#'
#' A loupe is a simple, small magnification device used to see small details
#' more closely.
#'
#' This function is intended to aid in the QA/QC of continually updating
#' timeseries data where we expect new values, but want to ensure previous data
#' remains unchanged.
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries).
#'
#' It informs the user of new (unmatched) rows which have appeared, and then
#' returns a `waldo::compare()` call to give a detailed breakdown of changes.
#'
#' The main assumption is that `df_current` and `df_previous` are a newer and
#' older versions of the same data, and that the `datetime_variable` name always
#' remains the same. Elsewhere new columns can of appear, and this will be
#' returned.
#'
#' @param df_current data.frame, most recent dataset n.
#' @param df_previous data.frame, the previous dataset, ie n - 1.
#' @param datetime_variable string, which unique ID to use to join df_current and df_previous. Usually a "datetime" variable.
#'
#' @export
loupe <- function(df_current, df_previous, datetime_variable) {
  # Using semi_join to extract rows with matching datetime_variables
  # (ie previously generated data)
  df_current_without_new_row <- dplyr::semi_join(
    df_current,
    df_previous,
    by = datetime_variable
  )

  # Compare the current data with the previous data, without "new" values
  waldo_object <- waldo::compare(
    df_current_without_new_row,
    df_previous
  )

  # Obtaining the new rows to provide in feedback
  df_current_new_rows <- dplyr::anti_join(
    df_current,
    df_previous,
    by = datetime_variable
  )

  # Creating a feedback message depending on the waldo object's output
  # First checking if there are new rows at all:
  if (nrow(df_current_new_rows) == 0) {
    stop(
      "There are no new rows. Check '",
      deparse(substitute(df_current)),
      "' is your most recent data, and '",
      deparse(substitute(df_previous)),
      "' is your previous data. If comparing like for like, try waldo::compare()."
    )
  } else {
    # Tell the user which rows are new, regardless of previous data changing
    cli::cat_line(
      "The following rows are new in '",
      deparse(substitute(df_current)),
      "': ",
      col = "green"
    )
    print(
      df_current_new_rows
    )
  }

  # Return a simple message if there are no changes in previous data
  if (length(waldo_object) == 0) {
    cli::cat_bullet(
      "And there are no differences with previous data.",
      bullet = "tick",
      col = "green",
      bullet_col = "green"
    )
  } else {
    # Return detailed breakdown and warning if previous data have changed.
    if (length(waldo_object) > 0) {
      cli::cat_line()

      cli::cat_bullet(
        "But the following values have changes from the previous data:",
        bullet = "info",
        col = "orange",
        bullet_col = "orange"
      )
      waldo_object
    }
  }
}
