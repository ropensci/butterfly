#' Loupe: compare new and old data in continuously updated timeseries
#'
#' A loupe is a simple, small magnification device used to examine small details
#' more closely.
#'
#' This function is intended to aid in the verification of continually
#' updating timeseries data where we expect new values but want to ensure
#' previous values remains unchanged.
#'
#' This function matches two dataframe objects by their unique identifier
#' (usually "time" or "datetime in a timeseries).
#'
#' It informs the user of new (unmatched) rows which have appeared, and then
#' returns a `waldo::compare()` call to give a detailed breakdown of changes. If
#' you are not familiar with `waldo::compare()`, this is an expanded and more
#' verbose function similar to base R's `all.equal()`.
#' 
#' `loupe()` will then return TRUE if there are not changes to previous data,
#' or FALSE if there are unexpected changes. If you want to extract changes as
#' a dataframe, use `catch()`, or if you want to drop them, use `release()`.
#'
#' The main assumption is that `df_current` and `df_previous` are a newer and
#' older versions of the same data, and that the `datetime_variable` variable
#' name always remains the same. Elsewhere new columns can of appear, and these
#' will be returned in the report.
#'
#' The underlying functionality is handled by `create_object_list()`.
#'
#' @inheritParams create_object_list
#'
#' @returns A boolean where TRUE indicates no changes to previous data and
#' FALSE indicates unexpected changes.
#'
#' @seealso [create_object_list()]
#'
#' @examples
#' # Checking two dataframes for changes
#' # Returning TRUE (no changes) or FALSE (changes)
#' # This example contains no differences with previous data
#' butterfly::loupe(
#'   butterflycount$february, # New or current dataset
#'   butterflycount$january, # Previous version you are comparing it to
#'   datetime_variable = "time" # Unique ID variable they have in common
#' )
#'
#' # This example does contain differences with previous data
#' butterfly::loupe(
#'   butterflycount$march,
#'   butterflycount$february,
#'   datetime_variable = "time"
#' )
#'
#' @export
loupe <- function(df_current, df_previous, datetime_variable, ...) {
  butterfly_object_list <- create_object_list(
    df_current,
    df_previous,
    datetime_variable,
    ...
  )

  return(butterfly_object_list$butterfly_status)

}
