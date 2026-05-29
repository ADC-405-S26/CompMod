# Introduction to CompMod

## Motivation

Comparable company analysis, commonly called comps, is one of the most
widely used valuation methods in investment banking and equity research.
The core idea is straightforward. If you want to estimate what a company
is worth, you look at how the market is currently pricing similar public
companies and apply those pricing ratios to your target. The logic is
that companies operating in the same industry with similar financial
profiles should trade at similar multiples.

In practice, building a comps model involves several repetitive and
error prone steps. An analyst must import raw financial data from Excel,
verify and recalculate valuation multiples from first principles, and
then summarize those multiples across the peer group to establish a
valuation range. Each of these steps takes time and introduces
opportunities for mistakes.

CompMod was built to handle exactly this workflow. It provides three
focused functions that take a raw Excel file of peer company data and
produce a clean, reproducible comps analysis in just a few lines of R
code.

## Installation

``` r

# install.packages("devtools")
devtools::install_github("ADC-405-S26/CompMod")
```

Load the package:

``` r

library(CompMod)
```

## The `valuation_data` dataset

CompMod ships with a built in dataset of 15 fictional technology
companies. Each company has the financial metrics needed to run a full
comps analysis. The dataset is designed to mirror the structure of a
real comparable company analysis model as used in investment banking and
equity research.

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

The dataset contains 15 companies and 18 columns. Those columns cover
share price, capital structure metrics like enterprise value and net
debt, and income statement items like revenue, EBITDA, net income, and
earnings per share.

## Step 1 — Read your Excel file with `read_valuation_excel()`

[`read_valuation_excel()`](https://adc-405-s26.github.io/CompMod/reference/read_valuation_excel.md)
is the entry point for any analysis using your own data. The function
does three things in sequence.

First it reads your Excel file into R using the readxl package. Second
it standardizes all column names so they are safe to work with in R. For
example a column called “Share Price” in your Excel file becomes
`Share.Price` in R. Third it validates the data by checking that all
required columns are present and that key financial columns contain
numeric values rather than text or blank cells.

This validation step is important. If your Excel file is missing a
required column or contains non-numeric entries in a financial field,
the function stops immediately and returns an error message that tells
you exactly what needs to be fixed. This means you catch data problems
before they silently affect your analysis downstream.

The required columns are: `Company.Name`, `Ticker`, `Sector`,
`Share.Price`, `Shares.Outstanding`, `Market.Capitalization`,
`Net.Debt`, `Enterprise.Value`, `Revenue..LTM.`, `EBITDA`, `Net.Income`,
`EPS`, `Revenue.Growth.YoY`, and `EBITDA.Margin`. Your Excel file must
follow this structure for the function to work correctly.

``` r

# install.packages("writexl")
tmp <- tempfile(fileext = ".xlsx")
writexl::write_xlsx(valuation_data, tmp)
df <- read_valuation_excel(tmp)
head(df)
```

## Step 2 — Compute multiples with `calc_multiples()`

[`calc_multiples()`](https://adc-405-s26.github.io/CompMod/reference/calc_multiples.md)
takes a validated data frame and calculates five core trading multiples
from the underlying financial data. Rather than pulling pre-calculated
values from your spreadsheet, the function derives each multiple
independently. This ensures the numbers are consistent and reproducible
regardless of what was entered in the original Excel file.

The five multiples and their formulas are:

| Multiple      | Formula                                      |
|---------------|----------------------------------------------|
| EV/Revenue    | Enterprise Value divided by LTM Revenue      |
| EV/EBITDA     | Enterprise Value divided by EBITDA           |
| P/E           | Share Price divided by EPS                   |
| Price/Sales   | Market Capitalization divided by LTM Revenue |
| EBITDA Margin | EBITDA divided by LTM Revenue                |

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

The function also handles edge cases. If any denominator value is zero
it returns a warning so you know which multiples may be unreliable. If a
value is missing the function propagates the NA rather than silently
dropping it.

## Step 3 — Summarise the peer group with `peer_summary()`

[`peer_summary()`](https://adc-405-s26.github.io/CompMod/reference/peer_summary.md)
takes the output of
[`calc_multiples()`](https://adc-405-s26.github.io/CompMod/reference/calc_multiples.md)
and condenses it into a summary table. For each multiple it returns the
mean, median, minimum, and maximum across the peer group. This summary
table is the core output of a comps analysis. An analyst uses the median
multiples to derive an implied valuation range for a target company.

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

You can also summarize a specific subset of multiples by passing a
character vector to the `multiples` argument:

``` r

peer_summary(comps, multiples = c("EV.Revenue", "EV.EBITDA"))
#> # A tibble: 2 × 5
#>   multiple    mean median   min   max
#>   <chr>      <dbl>  <dbl> <dbl> <dbl>
#> 1 EV.Revenue  2.15   1.83 0.758  5.93
#> 2 EV.EBITDA  12.6   12.6  9.37  18.8
```

By default the function removes NA values before computing each
statistic. You can change this behavior by setting `na.rm = FALSE` if
you want NA values to propagate through the summary.

## Putting it all together

The full workflow from raw Excel file to peer group summary takes three
lines of code:

``` r

library(CompMod)

df    <- read_valuation_excel("valuation_data.xlsx")
comps <- calc_multiples(df)
peer_summary(comps)
```

## Applying the results

Once you have the peer group summary you can apply the median multiples
to a target company’s financials to estimate its value. For example, if
the peer group median EV/EBITDA is 12.0x and your target company has
EBITDA of \$500 million, the implied enterprise value is \$6,000
million. From there you subtract net debt to get implied equity value,
then divide by shares outstanding to get an implied share price.

CompMod produces the peer group statistics that make this calculation
possible. The final step of applying those statistics to a specific
target is left to the analyst, since that judgment requires business
context that goes beyond what the data alone can provide.
