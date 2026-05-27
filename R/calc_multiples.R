#' @importFrom rlang .data
NULL

#' Calculate key valuation multiples for a peer group
#'
#' Takes a data frame of comparable companies (as returned by
#' `read_valuation_excel()`) and computes or re-derives the five core trading
#' multiples used in comparable company analysis: EV/Revenue, EV/EBITDA, P/E,
#' Price/Sales, and the EBITDA margin.
#'
#' @param data A data frame or tibble containing at minimum the columns
#'   `Company.Name`, `Ticker`, `Enterprise.Value`, `Revenue..LTM.`, `EBITDA`,
#'   `Market.Capitalization`, `Net.Income`, `EPS`, `Share.Price`, and
#'   `Shares.Outstanding`.
#'
#' @returns A tibble with the same rows as `data` plus five computed columns:
#'   \describe{
#'     \item{`EV.Revenue`}{Enterprise Value divided by LTM Revenue.}
#'     \item{`EV.EBITDA`}{Enterprise Value divided by EBITDA.}
#'     \item{`P.E`}{Share Price divided by EPS.}
#'     \item{`Price.Sales`}{Market Capitalization divided by LTM Revenue.}
#'     \item{`EBITDA.Margin`}{EBITDA divided by LTM Revenue.}
#'   }
#'
#' @export
#'
#' @examples
#' comps <- calc_multiples(valuation_data)
#' comps[, c("Company.Name", "EV.EBITDA", "EV.Revenue", "P.E")]
calc_multiples <- function(data) {

  checkmate::assert_data_frame(data, min.rows = 1)

  required_cols <- c(
    "Company.Name", "Ticker",
    "Enterprise.Value", "Revenue..LTM.", "EBITDA",
    "Market.Capitalization", "Net.Income", "EPS",
    "Share.Price", "Shares.Outstanding"
  )

  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    stop(paste0(
      "The following required columns are missing from 'data':\n  ",
      paste(missing_cols, collapse = ", "),
      "\nDid you pass the output of read_valuation_excel()?")
    )
  }

  numeric_cols <- c(
    "Enterprise.Value", "Revenue..LTM.", "EBITDA",
    "Market.Capitalization", "Net.Income", "EPS",
    "Share.Price", "Shares.Outstanding"
  )

  for (col in numeric_cols) {
    if (!is.numeric(data[[col]])) {
      stop(paste0("Column '", col, "' must be numeric. Found class: ", class(data[[col]]), "."))
    }
  }

  df <- tibble::as_tibble(data)

  zero_rev  <- any(df$Revenue..LTM. == 0, na.rm = TRUE)
  zero_ebit <- any(df$EBITDA == 0, na.rm = TRUE)
  zero_eps  <- any(df$EPS == 0, na.rm = TRUE)

  if (zero_rev)  warning("One or more Revenue values are zero; EV/Revenue and Price/Sales will be Inf or NaN.")
  if (zero_ebit) warning("One or more EBITDA values are zero; EV/EBITDA will be Inf or NaN.")
  if (zero_eps)  warning("One or more EPS values are zero; P/E will be Inf or NaN.")

  df <- dplyr::mutate(
    df,
    EV.Revenue    = .data$Enterprise.Value      / .data$Revenue..LTM.,
    EV.EBITDA     = .data$Enterprise.Value      / .data$EBITDA,
    P.E           = .data$Share.Price           / .data$EPS,
    Price.Sales   = .data$Market.Capitalization / .data$Revenue..LTM.,
    EBITDA.Margin = .data$EBITDA                / .data$Revenue..LTM.
  )

  df
}
