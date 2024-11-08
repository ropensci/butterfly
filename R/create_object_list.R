#' create_object_list: creates a list of objects used in all butterfly functions
#'
#' This function creates a list of objects which is used by all of `loupe()`,
#' `catch()` and `release()`.
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries).
#'
#' It informs the user of new (unmatched) rows which have appeared, and then
#' returns a `waldo::compare()` call to give a detailed breakdown of changes.
#'
#' The main assumption is that `df_current` and `df_previous` are a newer and
#' older versions of the same data, and that the `datetime_variable` variable
#' name always remains the same. Elsewhere new columns can of appear, and these
#' will be returned in the report.
#'
#' @param df_current data.frame, the newest/current version of dataset x.
#' @param df_previous data.frame, the old version of dataset,
#' for example x - t1.
#' @param datetime_variable string, which variable to use as unique ID to join
#'  `df_current` and `df_previous`. Usually a "datetime" variable.
#' @param ... Other `waldo::compare()` arguments can be supplied here, such as
#'  `tolerance` or `max_diffs`. See `?waldo::compare()` for a full list.
#'
#' @returns A list containing boolean where TRUE indicates no changes to
#' previous data and FALSE indicates unexpected changes, a dataframe of
#' the current data without new rows and a dataframe of new rows only
#'
#' @examples
#' butterfly_object_list <- butterfly::create_object_list(
#'   butterflycount$february, # New or current dataset
#'   butterflycount$january, # Previous version you are comparing to
#'   datetime_variable = "time" # Unique ID variable they have in common
#' )
#'
#' butterfly_object_list
#'
#' # You can pass other `waldo::compare()` options such as tolerance here
#' butterfly_object_list <- butterfly::create_object_list(
#'   butterflycount$march, # New or current dataset
#'   butterflycount$february, # Previous version you are comparing it to
#'   datetime_variable = "time", # Unique ID variable they have in common
#'   tolerance = 2
#' )
#'
#' butterfly_object_list
#'
#' @export
create_object_list <- function(
    df_current,
    df_previous,
    datetime_variable,
    ...
) {
  # Check input is as expected
  stopifnot("`df_current` must be a data.frame" = is.data.frame(df_current))
  stopifnot("`df_previous` must be a data.frame" = is.data.frame(df_previous))

  # Check if `datetime_variable` is in both `df_current` and `df_previous`
  if (
    !datetime_variable %in% names(df_current)
    ||
    !datetime_variable %in% names(df_previous)
  ) {
    cli::cli_abort(
      "`datetime_variable` must be present in `df_current` and `df_previous`"
    )
  }

  # Initialise list for objects used by `loupe()`, `catch()` and `release()`
  list_butterfly <- list(
    "waldo_object" = character(),
    "df_current_without_new_row" = data.frame(),
    "df_current_new_rows" = data.frame()
  )

  # Using semi_join to extract rows with matching datetime_variables
  # (ie previously generated data)
  df_current_without_new_row <- dplyr::semi_join(
    df_current,
    df_previous,
    by = datetime_variable
  )

  # Obtaining the new rows to provide in feedback
  df_current_new_rows <- dplyr::anti_join(
    df_current,
    df_previous,
    by = datetime_variable
  )

  # Compare the current data with the previous data, without "new" values
  waldo_object <- waldo::compare(
    df_current_without_new_row,
    df_previous,
    ...
  )

  # Creating a feedback message depending on the waldo object's output
  # First checking if there are new rows at all:
  if (nrow(df_current_new_rows) == 0) {
    cli::cat_bullet(
      "There are no new rows. Check '",
      deparse(substitute(df_current)),
      "' is your most recent data, and '",
      deparse(substitute(df_previous)),
      "' is your previous data. If comparing directly, try waldo::compare().",
      bullet = "info",
      col = "orange",
      bullet_col = "orange"
    )

    cli::cli_abort(
      "No new rows: stopping process."
    )
  } else {
    # Tell the user which rows are new, regardless of previous data changing
    cli::cat_line(
      "The following rows are new in '",
      deparse(substitute(df_current)),
      "': ",
      col = "green"
    )
    cli::cat_print(
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

    butterfly_status <- TRUE

  } else {
    # Return detailed breakdown and warning if previous data have changed.
    if (length(waldo_object) > 0) {
      cli::cat_line()

      cli::cat_bullet(
        "The following values have changes from the previous data.",
        bullet = "info",
        col = "orange",
        bullet_col = "orange"
      )

      cli::cat_print(
        waldo_object
      )

      butterfly_status <- FALSE

    }
  }

  # Populate list with objects
  list_butterfly <- list(
    butterfly_status = butterfly_status,
    df_current_without_new_row = df_current_without_new_row,
    df_current_new_rows = df_current_new_rows
  )

  return(list_butterfly)
}
