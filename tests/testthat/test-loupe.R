test_that("TRUE is returned when equal", {
  expect_true(
    loupe(
      butterflycount$february,
      butterflycount$january,
      datetime_variable = "time"
    )
  )
})

test_that("FALSE is returned when NOT equal", {
  expect_false(
    loupe(
      butterflycount$march,
      butterflycount$february,
      datetime_variable = "time"
    )
  )
})
