valuation_data <- readxl::read_excel("data-raw/valuation_data.xlsx")

## standardise column names to be R-safe
names(valuation_data) <- make.names(names(valuation_data), unique = TRUE)

usethis::use_data(valuation_data, overwrite = TRUE)
