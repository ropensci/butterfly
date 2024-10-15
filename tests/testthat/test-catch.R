test_that("warning when no new rows", {
  # And when the previous/current dfs have been swapped.
  expect_warning(
    catch(
      butterflycount$january,
      butterflycount$february,
      datetime_variable = "time"
    )
  )
})

test_that("error when rows are identical", {
  # This should occur when dfs are identical
  expect_error(
    # Suppressing warning, as this is also given (see above)
    suppressWarnings(
      catch(
        butterflycount$january,
        butterflycount$january,
        datetime_variable = "time"
      )
    )
  )
})

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
    "The following rows have changed from the previous data, and will be returned:"
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
