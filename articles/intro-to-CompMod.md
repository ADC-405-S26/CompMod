# Introduction to CompMod

## Motivation

Commonly called “comps,” Comparable company analysis is one of the most
widely used valuation methodologies in investment banking and equity
research. The idea is straightforward: if you want to know what a
private company or an acquisition target is worth, look at how the
market is pricing similar public companies and apply those multiples to
your target.

In practice, however, building a comps model involves several repetitive
steps: importing data from Excel, re-deriving multiples to verify them,
and computing peer group statistics (mean, median, min, max) to set a
valuation range. These steps are tedious, error-prone, and hard to
reproduce.

`CompMod` solves exactly this problem. It provides three focused
functions that turn a raw Excel file of peer company data into a clean,
reproducible comps analysis in just a few lines of R.

## Installation

``` r

# install.packages("devtools")
devtools::install_github("yourgithub/CompMod")
```

Load the package:

``` r

library(CompMod)
```

## The `valuation_data` dataset

`CompMod` ships with a built-in dataset of 15 fictional technology
companies, each with the financial metrics needed to run a comps
analysis.

``` r

head(valuation_data[, c("Company.Name", "Ticker", "Share.Price",
                         "Enterprise.Value", "Revenue..LTM.", "EBITDA")])
#>       Company.Name Ticker Share.Price Enterprise.Value Revenue..LTM. EBITDA
#> 1    Xylo Dynamics    XYZ       48.25          28000.0         11800   2850
#> 2  Dogwood Systems    DOG       36.80          20435.0         11800   2180
#> 3         NovaGrid    NVG       29.60          21635.0         11800   1825
#> 4 BlueFox Software    BFX       22.40          12835.0         11800   1240
#> 5       TitanCloud    TCL       62.15          47380.0         11800   3360
#> 6        Apex Data    APX       18.75          10437.5         11800    910
```

The dataset contains 15 companies and 18 columns covering share price,
capital structure metrics, income statement items, and pre-computed
multiples.

## Step 1 — Read your Excel file with `read_valuation_excel()`

In a real workflow you would load your own Excel file.
[`read_valuation_excel()`](https://adc-405-s26.github.io/CompMod/reference/read_valuation_excel.md)
reads the file, standardizes column names, and validates that all
required columns and numeric fields are present before any analysis
runs.

``` r

df <- read_valuation_excel("path/to/your/valuation_data.xlsx")
```

If the file is missing required columns, the function stops immediately
with a messages

## Step 2 — Compute multiples with `calc_multiples()`

[`calc_multiples()`](https://adc-405-s26.github.io/CompMod/reference/calc_multiples.md)
takes the data frame and computes five trading multiples from first
principles:

| Multiple      | Formula                                 |
|---------------|-----------------------------------------|
| EV/Revenue    | Enterprise Value divided by LTM Revenue |
| EV/EBITDA     | Enterprise Value divided by EBITDA      |
| P/E           | Share Price divided by EPS              |
| Price/Sales   | Market Cap divided by LTM Revenue       |
| EBITDA Margin | EBITDA divided by LTM Revenue           |

``` r

comps <- calc_multiples(valuation_data)
comps[, c("Company.Name", "EV.Revenue", "EV.EBITDA", "P.E", "EBITDA.Margin")]
#> # A tibble: 15 × 5
#>    Company.Name     EV.Revenue EV.EBITDA   P.E EBITDA.Margin
#>    <chr>                 <dbl>     <dbl> <dbl>         <dbl>
#>  1 Xylo Dynamics         2.37       9.82  14.0        0.242 
#>  2 Dogwood Systems       1.73       9.37  12.6        0.185 
#>  3 NovaGrid              1.83      11.9   18.1        0.155 
#>  4 BlueFox Software      1.09      10.4   12.6        0.105 
#>  5 TitanCloud            4.02      14.1   20.3        0.285 
#>  6 Apex Data             0.885     11.5   12.7        0.0771
#>  7 Quantum Byte          1.79      13.4   20.1        0.134 
#>  8 Orion Tech            2.32      10.8   15.8        0.214 
#>  9 Falcon AI             5.93      18.8   27.4        0.316 
#> 10 EchoSoft              0.758     11.5   12.1        0.0657
#> 11 MetroLink             1.90      12.9   18.6        0.147 
#> 12 Zenith Networks       2.59      13.3   19.5        0.195 
#> 13 PixelWorks            1.21      14.1   18.1        0.0856
#> 14 RapidWare             1.66      14.1   19.5        0.118 
#> 15 SkyVault              2.21      12.6   18.7        0.175
```

## Step 3 — Summarise the peer group with `peer_summary()`

The final step condenses the peer group multiples into a summary table
of mean, median, min, and max. This is what an analyst uses to derive an
implied valuation range for a target company.

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

You can also pass a custom subset of multiples:

``` r

peer_summary(comps, multiples = c("EV.Revenue", "EV.EBITDA"))
#> # A tibble: 2 × 5
#>   multiple    mean median   min   max
#>   <chr>      <dbl>  <dbl> <dbl> <dbl>
#> 1 EV.Revenue  2.15   1.83 0.758  5.93
#> 2 EV.EBITDA  12.6   12.6  9.37  18.8
```

## Putting it all together

Here is the full workflow from raw Excel to peer group summary in three
lines:

``` r

library(CompMod)

df    <- read_valuation_excel("valuation_data.xlsx")
comps <- calc_multiples(df)
peer_summary(comps)
```

## Applying the results

Once you have the peer group median multiples, you can apply them to a
target company’s financials. For example, if the peer group median
EV/EBITDA is *12.0x* and your target’s EBITDA is *\$500M*:

- Implied Enterprise Value = 12.0 x \$500M = **\$6,000M**
- Subtract Net Debt to get Implied Equity Value
- Divide by Shares Outstanding to get Implied Share Price

`CompMod` gives you the summary statistics — the final step of applying
them to a specific target is left to the analyst to ensure business
context is properly considered.
