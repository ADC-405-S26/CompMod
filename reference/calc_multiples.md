# Calculate key valuation multiples for a peer group

Takes a data frame of comparable companies (as returned by
[`read_valuation_excel()`](https://adc-405-s26.github.io/CompMod/reference/read_valuation_excel.md))
and computes or re-derives the five core trading multiples used in
comparable company analysis: EV/Revenue, EV/EBITDA, P/E, Price/Sales,
and the EBITDA margin.

## Usage

``` r
calc_multiples(data)
```

## Arguments

- data:

  A data frame or tibble containing at minimum the columns
  `Company.Name`, `Ticker`, `Enterprise.Value`, `Revenue..LTM.`,
  `EBITDA`, `Market.Capitalization`, `Net.Income`, `EPS`, `Share.Price`,
  and `Shares.Outstanding`.

## Value

A tibble with the same rows as `data` plus five computed columns:

- `EV.Revenue`:

  Enterprise Value divided by LTM Revenue.

- `EV.EBITDA`:

  Enterprise Value divided by EBITDA.

- `P.E`:

  Share Price divided by EPS.

- `Price.Sales`:

  Market Capitalization divided by LTM Revenue.

- `EBITDA.Margin`:

  EBITDA divided by LTM Revenue.

## Examples

``` r
comps <- calc_multiples(valuation_data)
comps[, c("Company.Name", "EV.EBITDA", "EV.Revenue", "P.E")]
#> # A tibble: 15 × 4
#>    Company.Name     EV.EBITDA EV.Revenue   P.E
#>    <chr>                <dbl>      <dbl> <dbl>
#>  1 Xylo Dynamics         9.82      2.37   14.0
#>  2 Dogwood Systems       9.37      1.73   12.6
#>  3 NovaGrid             11.9       1.83   18.1
#>  4 BlueFox Software     10.4       1.09   12.6
#>  5 TitanCloud           14.1       4.02   20.3
#>  6 Apex Data            11.5       0.885  12.7
#>  7 Quantum Byte         13.4       1.79   20.1
#>  8 Orion Tech           10.8       2.32   15.8
#>  9 Falcon AI            18.8       5.93   27.4
#> 10 EchoSoft             11.5       0.758  12.1
#> 11 MetroLink            12.9       1.90   18.6
#> 12 Zenith Networks      13.3       2.59   19.5
#> 13 PixelWorks           14.1       1.21   18.1
#> 14 RapidWare            14.1       1.66   19.5
#> 15 SkyVault             12.6       2.21   18.7
```
