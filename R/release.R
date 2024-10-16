#' Release: return current dataframe without changed old rows
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries), and returns a new dataframe
#' which contains the new rows (if present) but matched rows which contain
#' changes from previous data will be dropped.
#'
#' @param df_current data.frame, the newest/current version of dataset x.
#' @param df_previous data.frame, the old version of dataset, for example x - t1.
#' @param datetime_variable string, which variable to use as unique ID to join `df_current` and `df_previous`. Usually a "datetime" variable.
#'
#' @export
release <- function(df_current, df_previous, datetime_variable) {

  # Check input is as expected
  stopifnot("`df_current` must be a data.frame" = is.data.frame(df_current))
  stopifnot("`df_previous` must be a data.frame" = is.data.frame(df_previous))

  # Check if `datetime_variable` is in both `df_current` and `df_previous`
  if (!datetime_variable %in% names(df_current) || !datetime_variable %in% names(df_previous)){
    stop(
      "`datetime_variable` must be present in both `df_current` and `df_previous`"
    )
  }

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

  if (nrow(df_current_new_rows) == 0) {
    warning(
      "There are no new rows. Check '",
      deparse(substitute(df_current)),
      "' is your most recent data, and '",
      deparse(substitute(df_previous)),
      "' is your previous data."
    )
  } else {
    # Tell the user which rows are new, regardless of previous data changing
    cli::cat_line(
      paste0(
        "The following rows are new in '",
        deparse(substitute(df_current)),
        "': "
      ),
      col = "green"
    )
    cli::cat_print(
      df_current_new_rows
    )
  }

  # Return a simple message if there are no changes in previous data
  if (length(waldo_object) == 0) {
    warning(
      "There are no differences between current and previous data. Returning object identical to: ",
      deparse(substitute(df_current))
    )

    df_release <- df_current

  } else {
    # Return detailed breakdown and warning if previous data have changed.
    if (length(waldo_object) > 0) {
      cli::cat_line()

      cli::cat_bullet(
        "The following rows have changed from the previous data, and will be dropped: ",
        bullet = "info",
        col = "orange",
        bullet_col = "orange"
      )

      cli::cat_print(
        waldo_object
        )

      # By using an inner join, we drop any row which does not match in
      # df_previous.
      df_current_without_changed_rows <- suppressMessages(
        dplyr::inner_join(
          df_current_without_new_row,
          df_previous
        )
      )

      # Using inner_join does mean that the new rows will need to be added
      # back in.
      df_release <- dplyr::bind_rows(
        df_current_new_rows,
        df_current_without_changed_rows
      )
    }
  }
  return(df_release)
}
