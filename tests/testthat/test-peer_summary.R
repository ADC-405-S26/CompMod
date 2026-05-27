test_that("peer_summary returns correct structure and values", {
  comps  <- calc_multiples(valuation_data)
  result <- peer_summary(comps)

expect_s3_class(result, "data.frame")

expect_equal(nrow(result), 5)

expect_named(result, c("multiple", "mean", "median", "min", "max"))
  ev_ebitda_row <- result[result$multiple == "EV.EBITDA", ]
  expect_true(ev_ebitda_row$median >= ev_ebitda_row$min)
  expect_true(ev_ebitda_row$median <= ev_ebitda_row$max)})

test_that("peer_summary handles NA values and custom multiples", {
  comps <- calc_multiples(valuation_data)

  comps$EV.EBITDA[1] <- NA
  result_rm <- peer_summary(comps, multiples = "EV.EBITDA", na.rm = TRUE)
  expect_true(is.finite(result_rm$mean))

  result_no_rm <- peer_summary(comps, multiples = "EV.EBITDA", na.rm = FALSE)
  expect_true(is.na(result_no_rm$mean))

  result_custom <- peer_summary(comps, multiples = c("EV.Revenue", "P.E"))
  expect_equal(nrow(result_custom), 2)
  expect_equal(result_custom$multiple, c("EV.Revenue", "P.E"))})

test_that("peer_summary assertions catch invalid inputs", {comps <- calc_multiples(valuation_data)
  expect_error(peer_summary("not_a_df"),
    "Assertion on 'data' failed")

expect_error(
  peer_summary(comps, multiples = c("EV.EBITDA", "FakeMultiple")),
  "not found in 'data'")
expect_error(
  peer_summary(comps, na.rm = "yes"),
  "Assertion on 'na.rm' failed")})
