% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/catch.R
\name{catch}
\alias{catch}
\title{Catch: return dataframe containing only rows that have changed}
\usage{
catch(df_current, df_previous, datetime_variable, ...)
}
\arguments{
\item{df_current}{data.frame, the newest/current version of dataset x.}

\item{df_previous}{data.frame, the old version of dataset,
for example x - t1.}

\item{datetime_variable}{string, which variable to use as unique ID to join
\code{df_current} and \code{df_previous}. Usually a "datetime" variable.}

\item{...}{Other \code{waldo::compare()} arguments can be supplied here, such as
\code{tolerance} or \code{max_diffs}. See \code{?waldo::compare()} for a full list.}
}
\value{
A dataframe which contains only rows of \code{df_current} that have
changes from \code{df_previous}, but without new rows. Also returns a waldo
object as in \code{loupe()}.
}
\description{
This function matches two dataframe objects by their unique identifier
(usually "time" or "datetime in a timeseries), and returns a new dataframe
which contains only rows that have changed compared to previous data. It will
not return any new rows.
}
\details{
The underlying functionality is handled by \code{create_object_list()}.
}
\examples{
# Returning only matched rows which contain changes
df_caught <- butterfly::catch(
  butterflycount$march, # New or current dataset
  butterflycount$february, # Previous version you are comparing it to
  datetime_variable = "time" # Unique ID variable they have in common
)

df_caught

}
\seealso{
\code{\link[=loupe]{loupe()}}

\code{\link[=create_object_list]{create_object_list()}}
}
