
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CompMod

<!-- badges: start -->

<!-- badges: end -->

CompMod is an R package for comparable company analysis (comps). It
helps with reading valuation data from Excel, computing trading
multiples, and summarizing peer group statistics.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("ADC-405-S26/CompMod")
```

## Examples

``` r
library(CompMod)
```

#### Read a valuation Excel file

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

#### Compute trading multiples

``` r
comps <- calc_multiples(valuation_data)
comps[, c("Company.Name", "EV.Revenue", "EV.EBITDA", "P.E")]
#> # A tibble: 15 × 4
#>    Company.Name     EV.Revenue EV.EBITDA   P.E
#>    <chr>                 <dbl>     <dbl> <dbl>
#>  1 Xylo Dynamics         2.37       9.82  14.0
#>  2 Dogwood Systems       1.73       9.37  12.6
#>  3 NovaGrid              1.83      11.9   18.1
#>  4 BlueFox Software      1.09      10.4   12.6
#>  5 TitanCloud            4.02      14.1   20.3
#>  6 Apex Data             0.885     11.5   12.7
#>  7 Quantum Byte          1.79      13.4   20.1
#>  8 Orion Tech            2.32      10.8   15.8
#>  9 Falcon AI             5.93      18.8   27.4
#> 10 EchoSoft              0.758     11.5   12.1
#> 11 MetroLink             1.90      12.9   18.6
#> 12 Zenith Networks       2.59      13.3   19.5
#> 13 PixelWorks            1.21      14.1   18.1
#> 14 RapidWare             1.66      14.1   19.5
#> 15 SkyVault              2.21      12.6   18.7
```

#### Summarise the peer group

``` r
peer_summary(comps)
#> # A tibble: 5 × 5
#>   multiple        mean median     min    max
#>   <chr>          <dbl>  <dbl>   <dbl>  <dbl>
#> 1 EV.Revenue     2.15   1.83   0.758   5.93 
#> 2 EV.EBITDA     12.6   12.6    9.37   18.8  
#> 3 P.E           17.4   18.1   12.1    27.4  
#> 4 Price.Sales    1.82   1.51   0.430   5.61 
#> 5 EBITDA.Margin  0.167  0.155  0.0657  0.316
```

#### Read a valuation Excel file

``` r
# install.packages("writexl")
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
