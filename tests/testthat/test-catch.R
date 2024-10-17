test_that("correct message is fed back", {
  expect_output(
    catch(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    ),
    "The following rows are new in"
  )

  expect_output(
    catch(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    ),
    "Only these rows are returned"
  )
})

test_that("return dataframe with changed data", {
  df_caught <- catch(
    butterflycount$march,
    butterflycount$february,
    datetime_variable = "time"
  )

  expect_s3_class(
    df_caught,
    "data.frame"
  )
})
