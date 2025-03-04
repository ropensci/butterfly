test_that("error when no new rows", {
  # This should occur when dfs are identical
  expect_error(
    create_object_list(
      butterflycount$january,
      butterflycount$january,
      datetime_variable = "time"
    )
  )
  # And when the previous/current dfs have been swapped.
  expect_error(
    create_object_list(
      butterflycount$january,
      butterflycount$february,
      datetime_variable = "time"
    )
  )
})

test_that("error when no datetime_variable not present in both dfs", {
  expect_error(
    create_object_list(
      butterflycount$january,
      butterflycount$february,
      datetime_variable = "foo"
    ),
    "`datetime_variable` must be present in `df_current` and `df_previous`"
  )
})

test_that("correct message is fed back", {
  expect_output(
    create_object_list(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    "The following rows are new in"
  )
  expect_output(
    create_object_list(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    "And there are no differences with previous data."
  )
  expect_output(
    create_object_list(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    ),
    "The following values have changes from the previous data."
  )
})

test_that("error when datetime is not in both objects", {
  expect_error(
    create_object_list(
      butterflycount$april,
      butterflycount$march,
      datetime_variable = "species"
    ),
    "`datetime_variable` must be present in `df_current` and `df_previous`"
  )
})

test_that("a list of three objects is returned", {
  expect_length(
    create_object_list(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    ),
    3
  )
})

test_that("comparison object is returned when not equal", {
  create_object_list_output <- create_object_list(
    butterflycount$march,
    butterflycount$february,
    datetime_variable = "time"
  )
  expect_gt(
    length(
      create_object_list_output
    ),
    0
  )
})

test_that("passing of additional waldo arguments works as expected", {
  # Adding a tolerance of 2 should now "ignore" the single change
  create_object_list_output <- create_object_list(
    butterflycount$march,
    butterflycount$february,
    datetime_variable = "time",
    tolerance = 2
  )

  testthat::expect_true(
    create_object_list_output$butterfly_status
  )
})

test_that("response is as expected with messy data", {
  # The messy data (butterflymess) is randomly generated
  # So we expect changes in the data
  create_object_list_output <- create_object_list(
    butterflymess$march,
    butterflymess$february,
    datetime_variable = "time"
  )

  testthat::expect_false(
    create_object_list_output$butterfly_status
  )
})

test_that("error when no new rows with messy data", {
  # This should occur when dfs are identical
  expect_error(
    create_object_list(
      butterflymess$january,
      butterflymess$january,
      datetime_variable = "time"
    )
  )
  # And when the previous/current dfs have been swapped.
  expect_error(
    create_object_list(
      butterflymess$january,
      butterflymess$february,
      datetime_variable = "time"
    )
  )
})

test_that("correct message is fed back with messy data", {
  expect_output(
    create_object_list(
      butterflymess$february,
      butterflymess$january,
      datetime_variable = "time"
    ),
    "The following rows are new in"
  )

  expect_output(
    create_object_list(
      butterflymess$march,
      butterflymess$february,
      datetime_variable = "time"
    ),
    "The following values have changes from the previous data."
  )
})
