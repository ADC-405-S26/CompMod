# Comparable company valuation dataset

A dataset containing financial metrics and valuation multiples for 15
fictional technology companies, designed to demonstrate the functions in
the CompMod package. The data follows the structure of a standard
comparable company analysis (comps) model as used in investment banking
and equity research.

## Usage

``` r
valuation_data
```

## Format

### `valuation_data`

A data frame with 15 rows and 18 columns:

- Company.Name:

  Name of the fictional company (character).

- Ticker:

  Stock ticker symbol (character).

- Sector:

  Industry sector — all companies are in Technology (character).

- Share.Price:

  Current share price in USD.

- Shares.Outstanding:

  Total shares outstanding in millions.

- Market.Capitalization:

  Market cap in millions USD.

- Net.Debt:

  Total debt minus cash in millions USD.

- Enterprise.Value:

  Enterprise value in millions USD.

- Revenue..LTM.:

  Last twelve months revenue in millions USD.

- EBITDA:

  Earnings before interest, taxes, depreciation and amortisation in
  millions USD.

- Net.Income:

  Net income in millions USD.

- EPS:

  Earnings per share in USD.

- Revenue.Growth.YoY:

  Year-over-year revenue growth rate as a decimal.

- EBITDA.Margin:

  EBITDA as a proportion of revenue.

- P.E:

  Price-to-earnings ratio.

- EV.Revenue:

  Enterprise Value divided by LTM Revenue.

- EV.EBITDA:

  Enterprise Value divided by EBITDA.

- Net.Income.Margin:

  Net Income as a proportion of revenue.
