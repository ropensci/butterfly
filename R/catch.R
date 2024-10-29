#' Catch: return dataframe containing only rows that have changed
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries), and returns a new dataframe
#' which contains only rows that have changed compared to previous data. It will
#' not return any new rows.
#'
#' The underlying functionality is handled by `create_object_list()`.
#'
#' @inheritParams create_object_list
#'
#' @returns A dataframe which contains only rows of `df_current` that have changes from `df_previous`, but without new rows.
#' also returns a waldo object as in `loupe()`.
#'
#' @seealso [loupe()]
#' @seealso [create_object_list()]
#'
#' @examples
#' # Returning only matched rows which contain changes
#' df_caught <- butterfly::catch(
#'   butterflycount$march, # This is your new or current dataset
#'   butterflycount$february, # This is the previous version you are comparing it to
#'   datetime_variable = "time" # This is the unique ID variable they have in common
#' )
#'
#' df_caught
#'
#' @export
catch <- function(df_current, df_previous, datetime_variable, ...) {
  butterfly_object_list <- create_object_list(
    df_current,
    df_previous,
    datetime_variable,
    ...
    )

  # By using an inner join, we drop any row which does not match in
  # df_previous.
  df_rows_changed_from_previous <- suppressMessages(
    dplyr::anti_join(
      butterfly_object_list$df_current_without_new_row,
      df_previous
    )
  )

  cli::cat_line()

  cli::cat_bullet(
    "Only these rows are returned.",
    bullet = "info",
    col = "orange",
    bullet_col = "orange"
  )

  return(df_rows_changed_from_previous)
}
