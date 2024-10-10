#' Butterfly: compare previous data in continuously updated timeseries
#'
#' This function compares two timeseries objects where we expect previous values
#' to be the same.
#'
#' This function is intended to aid in the QA/QC of continually updating
#' timeseries data where we expect new values, but want to ensure previous data
#' remains unchanged.
#'
#' @param df_current data.frame, most recent dataset n.
#' @param df_previous data.frame, the previoust dataset, ie n - 1.
#' @param datetime_variable string, which unique ID to use to join x and y. Usually "time".
#'
#' @export
butterfly <- function(df_current, df_previous, datetime_variable) {
  # Using semi_join to extract rows with matching datetime_variables
  # (ie previously generated data)
  df_current_without_new_row <- dplyr::semi_join(
    df_current,
    df_previous,
    by = datetime_variable
  )

  # Compare the current data with the previous data, without "new" values
  waldo::compare(
    df_current_without_new_row,
    df_previous
  )
}
