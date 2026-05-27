# Read and validate a valuation Excel file

Reads a standardized comparable company analysis Excel file and returns
a clean tibble. The function validates that all required columns are
present and that key numeric columns contain non-negative values,
ensuring the data is ready for downstream analysis.

## Usage

``` r
read_valuation_excel(path, sheet = 1)
```

## Arguments

- path:

  A length-one character string giving the path to the `.xlsx` file.

- sheet:

  A length-one character string or positive integer specifying which
  sheet to read. Defaults to `1` (the first sheet).

## Value

A tibble with one row per company. Column names are standardized using
[`make.names()`](https://rdrr.io/r/base/make.names.html) so they are
safe to use in R expressions.

## Examples

``` r
tmp <- tempfile(fileext = ".xlsx")
writexl::write_xlsx(valuation_data, tmp)
df <- read_valuation_excel(tmp)
head(df)
#> # A tibble: 6 × 18
#>   Company.Name     Ticker Sector     Share.Price Shares.Outstanding
#>   <chr>            <chr>  <chr>            <dbl>              <dbl>
#> 1 Xylo Dynamics    XYZ    Technology        48.2                500
#> 2 Dogwood Systems  DOG    Technology        36.8                450
#> 3 NovaGrid         NVG    Technology        29.6                600
#> 4 BlueFox Software BFX    Technology        22.4                400
#> 5 TitanCloud       TCL    Technology        62.2                700
#> 6 Apex Data        APX    Technology        18.8                350
#> # ℹ 13 more variables: Market.Capitalization <dbl>, Net.Debt <dbl>,
#> #   Enterprise.Value <dbl>, Revenue..LTM. <dbl>, EBITDA <dbl>,
#> #   Net.Income <dbl>, EPS <dbl>, Revenue.Growth.YoY <dbl>, EBITDA.Margin <dbl>,
#> #   P.E <dbl>, EV.Revenue <dbl>, EV.EBITDA <dbl>, Net.Income.Margin <dbl>
```
