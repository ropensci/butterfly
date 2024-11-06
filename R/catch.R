#' Catch: return dataframe containing only rows that have changed
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries), and returns a new dataframe
#' which contains only rows that have changed compared to previous data. It will
#' not return any new rows.
#'
#' The underlying functionality is handled by `create_object_list()`.
#'
#' @param df_current data.frame, the newest/current version of dataset x.
#' @param df_previous data.frame, the old version of dataset,
#' for example x - t1.
#' @param datetime_variable character, which variable to use as unique ID to
#' join `df_current` and `df_previous`. Usually a "datetime" variable.
#'
#' @returns A dataframe which contains only rows of `df_current` that have
#' changes from `df_previous`, but without new rows. Also returns a waldo
#' object as in `loupe()`.
#'
#' @seealso [loupe()]
#' @seealso [create_object_list()]
#'
#' @examples
#' df_caught <- butterfly::catch(
#'   butterflycount$march,
#'   butterflycount$february,
#'   datetime_variable = "time"
#' )
#'
#' df_caught
#'
#' @export
catch <- function(df_current, df_previous, datetime_variable) {
  butterfly_object_list <- create_object_list(
    df_current,
    df_previous,
    datetime_variable
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
