#' Release: return current dataframe without changed old rows
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries), and returns a new dataframe
#' which contains the new rows (if present) but matched rows which contain
#' changes from previous data will be dropped.
#'
#' @inheritParams create_object_list
#' @param include_new boolean, should new rows be included? Default is TRUE.
#'
#' @returns A dataframe which contains only rows of `df_current` that have not changed from `df_previous`, and includes new rows.
#' also returns a waldo object as in `loupe()`.
#'
#' @seealso [loupe()]
#' @seealso [create_object_list()]
#'
#' @examples
#' # Dropping matched rows which contain changes, and returning unchanged rows
#' df_released <- butterfly::release(
#'   butterflycount$march, # This is your new or current dataset
#'   butterflycount$february, # This is the previous version you are comparing it to
#'   datetime_variable = "time", # This is the unique ID variable they have in common
#'   include_new = TRUE # Whether to include new rows or not, default is TRUE
#' )
#'
#' df_released
#'
#' @export
release <- function(df_current, df_previous, datetime_variable, include_new = TRUE, ...) {
  butterfly_object_list <- create_object_list(
    df_current,
    df_previous,
    datetime_variable,
    ...
  )

  if (butterfly_object_list$butterfly_status == TRUE){

    cli::cat_bullet(
      "There are no differences, so there are no rows to drop. Did you specify a tolerance that exceeds number of differences?",
      bullet = "info",
      col = "orange",
      bullet_col = "orange"
    )

  } else {
    # By using an inner join, we drop any row which does not match in
    # df_previous.
    df_current_without_changed_rows <- suppressMessages(
      dplyr::inner_join(
        butterfly_object_list$df_current_without_new_row,
        df_previous
      )
    )

    # Returng the dataframe with or without new rows added
    if (include_new == TRUE) {
      # Then we add the new rows back in and return the dataframe as such
      df_release <- dplyr::bind_rows(
        butterfly_object_list$df_current_new_rows,
        df_current_without_changed_rows
      )

      cli::cat_line()

      cli::cat_bullet(
        "These will be dropped, but new rows are included.",
        bullet = "info",
        col = "orange",
        bullet_col = "orange"
      )

      return(df_release)

    } else if (include_new == FALSE) {
      cli::cat_line()

      cli::cat_bullet(
        "These will be dropped, along with new rows.",
        bullet = "info",
        col = "orange",
        bullet_col = "orange"
      )

      # If new rows are not included, simply return the df without changed rows
      return(df_current_without_changed_rows)
    }
  }
}
