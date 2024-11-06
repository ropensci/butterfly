test_that("correct message is fed back", {
  expect_output(
    timeline(
      forestprecipitation$january,
      datetime_variable = "time",
      expected_lag = 1
    ),
    "There are no time lags which are greater than the expected lag"
  )
  expect_output(
    timeline(
      forestprecipitation$february,
      datetime_variable = "time",
      expected_lag = 1
    ),
    "There are time lags which are greater than the expected lag"
  )
})

test_that("correct message is fed back", {
  expect_true(
    timeline(
      forestprecipitation$january,
      datetime_variable = "time",
      expected_lag = 1
    )
  )
  expect_false(
    timeline(
      forestprecipitation$february,
      datetime_variable = "time",
      expected_lag = 1
    )
  )
})
