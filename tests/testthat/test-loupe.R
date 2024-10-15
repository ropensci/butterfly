test_that("error when no new rows", {
  # This should occur when dfs are identical
  expect_error(
    loupe(
      butterflycount$january,
      butterflycount$january,
      datetime_variable = "time"
    )
  )
  # And when the previous/current dfs have been swapped.
  expect_error(
    loupe(
      butterflycount$january,
      butterflycount$february,
      datetime_variable = "time"
    )
  )
})

test_that("correct message is fed back", {
  expect_output(
    loupe(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    "The following rows are new in"
  )
  expect_output(
    loupe(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    "And there are no differences with previous data."
  )
  expect_output(
    loupe(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    ),
    "But the following values have changes from the previous data:"
  )
})

test_that("comparison object is not returned when equal", {
  expect_length(
    loupe(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    0
  )
})

test_that("comparison object is returned when not equal", {
  loupe_output <- loupe(
    butterflycount$march,
    butterflycount$february,
    datetime_variable = "time"
  )
  expect_gt(
    length(
      loupe_output
    ),
    0
  )
})
