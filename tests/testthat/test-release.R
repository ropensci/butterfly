test_that("correct message is fed back", {
  expect_output(
    release(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time",
      include_new = TRUE
    ),
    "These will be dropped, but new rows are included"
  )

  expect_output(
    release(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time",
      include_new = FALSE
    ),
    "These will be dropped, along with new rows"
  )
})

test_that("return dataframe with changed data", {
  df_release <- release(
    butterflycount$march,
    butterflycount$february,
    datetime_variable = "time"
  )

  expect_s3_class(
    df_release,
    "data.frame"
  )
})

test_that("return message when no differences", {
  expect_output(
    release(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time",
      tolerance = 2
    ),
    "There are no differences, so there are no rows to drop.
      Did you specify a tolerance that exceeds number of differences?"
  )
})
