test_that("calc_multiples computes correct multiple values", {result <- calc_multiples(valuation_data)

expect_equal(result$EV.Revenue,valuation_data$Enterprise.Value / valuation_data$Revenue..LTM.,
  tolerance = 1e-6)

expect_equal(result$EV.EBITDA,valuation_data$Enterprise.Value / valuation_data$EBITDA,tolerance = 1e-6)

expect_equal(result$EBITDA.Margin,
  valuation_data$EBITDA / valuation_data$Revenue..LTM.,
  tolerance = 1e-6)})

test_that("calc_multiples handles edge cases correctly", {df_zero <- valuation_data
  df_zero$EBITDA[1] <- 0
  expect_warning(calc_multiples(df_zero), "zero")

  result_zero <- suppressWarnings(calc_multiples(df_zero))
  expect_true(is.infinite(result_zero$EV.EBITDA[1]) || is.nan(result_zero$EV.EBITDA[1]))

df_na <- valuation_data
df_na$Revenue..LTM.[1] <- NA
result_na <- calc_multiples(df_na)
expect_true(is.na(result_na$EV.Revenue[1]))})

test_that("calc_multiples assertions catch invalid inputs", {
  expect_error(calc_multiples(list(a = 1, b = 2)),
    "Assertion on 'data' failed")

expect_error(calc_multiples(data.frame()),
  "Assertion on 'data' failed")

expect_error(calc_multiples(data.frame(Company.Name = "TestCo", Ticker = "TST")),
  "required columns are missing")})
