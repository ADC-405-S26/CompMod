test_that("read_valuation_excel reads a valid Excel file correctly", {tmp <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(valuation_data, tmp)

result <- read_valuation_excel(tmp)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 15)

expected_cols <- c(
    "Company.Name", "Ticker", "Sector",
    "Share.Price", "Shares.Outstanding", "Market.Capitalization",
    "Net.Debt", "Enterprise.Value", "Revenue..LTM.",
    "EBITDA", "Net.Income", "EPS",
    "Revenue.Growth.YoY", "EBITDA.Margin",
    "P.E", "EV.Revenue", "EV.EBITDA")
expect_true(all(expected_cols %in% names(result)))})

test_that("read_valuation_excel handles edge cases gracefully", {
  expect_error(
    read_valuation_excel("nonexistent_file.xlsx"),
    "File not found")

tmp_csv <- tempfile(fileext = ".csv")
 write.csv(data.frame(x = 1), tmp_csv, row.names = FALSE)
  expect_error(
    read_valuation_excel(tmp_csv),
    "Excel file")

  bad_df  <- data.frame(Company.Name = "TestCo", Ticker = "TST")
  tmp_bad <- tempfile(fileext = ".xlsx")
  writexl::write_xlsx(bad_df, tmp_bad)
  expect_error(read_valuation_excel(tmp_bad),
    "required columns are missing" )})

test_that("read_valuation_excel assertions catch invalid inputs", {expect_error(read_valuation_excel(123),
  "Assertion on 'path' failed")

  expect_error(
    read_valuation_excel(c("file1.xlsx", "file2.xlsx")),
    "Assertion on 'path' failed")})
