#' Read and validate a valuation Excel file
#'
#' Reads a standardized comparable company analysis Excel file and returns a
#' clean tibble. The function validates that all required columns are present
#' and that key numeric columns contain non-negative values, ensuring the data
#' is ready for downstream analysis.
#'
#' @param path A length-one character string giving the path to the `.xlsx` file.
#' @param sheet A length-one character string or positive integer specifying
#'   which sheet to read. Defaults to `1` (the first sheet).
#'
#' @returns A tibble with one row per company. Column names are standardized
#'   using [make.names()] so they are safe to use in R expressions.
#'
#' @export
#'
#' @examples
#' tmp <- tempfile(fileext = ".xlsx")
#' writexl::write_xlsx(valuation_data, tmp)
#' df <- read_valuation_excel(tmp)
#' head(df)
read_valuation_excel <- function(path, sheet = 1) {

  checkmate::assert_string(path)
  checkmate::assert(
    checkmate::check_string(sheet),
    checkmate::check_count(sheet, positive = TRUE)
  )

  if (!file.exists(path)) {
    stop(paste0("File not found: '", path, "'. Please check the path and try again."))
  }

  ext <- tolower(tools::file_ext(path))
  if (!ext %in% c("xlsx", "xls")) {
    stop("'path' must point to an Excel file with extension .xlsx or .xls.")
  }

  raw <- readxl::read_excel(path, sheet = sheet)
  df  <- tibble::as_tibble(raw)

  names(df) <- make.names(names(df), unique = TRUE)

  required_cols <- c(
    "Company.Name", "Ticker", "Sector",
    "Share.Price", "Shares.Outstanding", "Market.Capitalization",
    "Net.Debt", "Enterprise.Value", "Revenue..LTM.",
    "EBITDA", "Net.Income", "EPS",
    "Revenue.Growth.YoY", "EBITDA.Margin",
    "P.E", "EV.Revenue", "EV.EBITDA"
  )

  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(paste0(
      "The following required columns are missing from the file:\n  ",
      paste(missing_cols, collapse = ", "),
      "\nPlease ensure the Excel file follows the CompMod template."
    ))
  }

  numeric_cols <- c(
    "Share.Price", "Shares.Outstanding", "Market.Capitalization",
    "Enterprise.Value", "Revenue..LTM.", "EBITDA", "Net.Income", "EPS"
  )

  for (col in numeric_cols) {
    if (!is.numeric(df[[col]])) {
      stop(paste0("Column '", col, "' must be numeric. Check for non-numeric entries in the Excel file."))
    }
    if (any(df[[col]] < 0, na.rm = TRUE)) {
      warning(paste0("Column '", col, "' contains negative values. Please verify the data."))
    }
  }

  df
}
