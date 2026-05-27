# Summarise peer group valuation multiples

Computes descriptive statistics (mean, median, minimum, and maximum) for
the key trading multiples across a peer group of comparable companies.
The summary table is the core output of a comparable company analysis.

## Usage

``` r
peer_summary(
  data,
  multiples = c("EV.Revenue", "EV.EBITDA", "P.E", "Price.Sales", "EBITDA.Margin"),
  na.rm = TRUE
)
```

## Arguments

- data:

  A data frame or tibble that contains the multiple columns to
  summarise. Typically the output of
  [`calc_multiples()`](https://adc-405-s26.github.io/CompMod/reference/calc_multiples.md).

- multiples:

  A character vector of column names to summarise. Defaults to
  `c("EV.Revenue", "EV.EBITDA", "P.E", "Price.Sales", "EBITDA.Margin")`.

- na.rm:

  Logical scalar. If `TRUE` (the default), `NA` values are removed
  before computing each statistic.

## Value

A tibble with one row per multiple and four statistic columns:

- `multiple`:

  Name of the valuation multiple.

- `mean`:

  Arithmetic mean across the peer group.

- `median`:

  Median across the peer group.

- `min`:

  Minimum observed value.

- `max`:

  Maximum observed value.

## Examples

``` r
comps <- calc_multiples(valuation_data)
peer_summary(comps)
#> # A tibble: 5 × 5
#>   multiple        mean median     min    max
#>   <chr>          <dbl>  <dbl>   <dbl>  <dbl>
#> 1 EV.Revenue     2.15   1.83   0.758   5.93 
#> 2 EV.EBITDA     12.6   12.6    9.37   18.8  
#> 3 P.E           17.4   18.1   12.1    27.4  
#> 4 Price.Sales    1.82   1.51   0.430   5.61 
#> 5 EBITDA.Margin  0.167  0.155  0.0657  0.316

peer_summary(comps, multiples = c("EV.Revenue", "EV.EBITDA"))
#> # A tibble: 2 × 5
#>   multiple    mean median   min   max
#>   <chr>      <dbl>  <dbl> <dbl> <dbl>
#> 1 EV.Revenue  2.15   1.83 0.758  5.93
#> 2 EV.EBITDA  12.6   12.6  9.37  18.8 
```
