#' Summarise peer group valuation multiples
#'
#' Computes descriptive statistics (mean, median, minimum, and maximum) for the
#' key trading multiples across a peer group of comparable companies. The
#' summary table is the core output of a comparable company analysis.
#'
#' @param data A data frame or tibble that contains the multiple columns to
#'   summarise. Typically the output of `calc_multiples()`.
#' @param multiples A character vector of column names to summarise. Defaults
#'   to `c("EV.Revenue", "EV.EBITDA", "P.E", "Price.Sales", "EBITDA.Margin")`.
#' @param na.rm Logical scalar. If `TRUE` (the default), `NA` values are
#'   removed before computing each statistic.
#'
#' @returns A tibble with one row per multiple and four statistic columns:
#'   \describe{
#'     \item{`multiple`}{Name of the valuation multiple.}
#'     \item{`mean`}{Arithmetic mean across the peer group.}
#'     \item{`median`}{Median across the peer group.}
#'     \item{`min`}{Minimum observed value.}
#'     \item{`max`}{Maximum observed value.}
#'   }
#'
#' @export
#'
#' @examples
#' comps <- calc_multiples(valuation_data)
#' peer_summary(comps)
#'
#' peer_summary(comps, multiples = c("EV.Revenue", "EV.EBITDA"))
peer_summary <- function(
    data,
    multiples = c("EV.Revenue", "EV.EBITDA", "P.E", "Price.Sales", "EBITDA.Margin"),
    na.rm = TRUE) {

  checkmate::assert_data_frame(data, min.rows = 1)
  checkmate::assert_character(multiples, min.len = 1, any.missing = FALSE)
  checkmate::assert_flag(na.rm)

  missing_cols <- setdiff(multiples, names(data))
  if (length(missing_cols) > 0) {
    stop(paste0(
      "The following columns are not found in 'data':\n  ",
      paste(missing_cols, collapse = ", "),
      "\nRun calc_multiples() first, or adjust the 'multiples' argument."
    ))
  }

  for (col in multiples) {
    if (!is.numeric(data[[col]])) {
      stop(paste0(
        "Column '", col, "' must be numeric but has class: ", class(data[[col]]), "."
      ))
    }
  }

  result <- lapply(multiples, function(m) {
    vals <- data[[m]]
    tibble::tibble(
      multiple = m,
      mean     = mean(vals,          na.rm = na.rm),
      median   = stats::median(vals, na.rm = na.rm),
      min      = min(vals,           na.rm = na.rm),
      max      = max(vals,           na.rm = na.rm)
    )
  })

  dplyr::bind_rows(result)
}
