test_that("returns dataframe", {
  df_timelines <- butterfly::group_timelines(
    forestprecipitation$january,
    datetime_variable = "time",
    expected_lag = 1
  )

  expect_s3_class(
    df_timelines,
    "data.frame"
  )

  expect_named(
    df_timelines,
    c(
      "time",
      "rainfall_mm",
      "timelag",
      "timeline_group"
    )
  )
})

test_that("returns expected number of sequences", {
  df_timelines <- butterfly::group_timelines(
    forestprecipitation$january,
    datetime_variable = "time",
    expected_lag = 1
  )

  expect_equal(
    length(
      unique(
        df_timelines$timeline_group
      )
    ),
    1
  )

  df_reset <- butterfly::group_timelines(
    forestprecipitation$february,
    datetime_variable = "time",
    expected_lag = 1
  )

  expect_equal(
    length(
      unique(
        df_reset$timeline_group
      )
    ),
    2
  )
})
