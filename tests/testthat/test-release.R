test_that("warning when no new rows", {
  # And when the previous/current dfs have been swapped.
  expect_warning(
    release(
      butterflycount$january,
      butterflycount$february,
      datetime_variable = "time"
    )
  )
})

test_that("warning when there are no different rows to drop", {
  # This should occur when dfs are identical
  expect_warning(
    release(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    )
  )
})

test_that("correct message is fed back", {
  expect_output(
    release(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    ),
    "The following rows have changed from the previous data, and will be dropped:"
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
