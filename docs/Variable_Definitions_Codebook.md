# Variable Definitions and Codebook

This document specifies all variables used in the empirical analysis, their data sources, units, and any transformations applied prior to estimation.

## 1. Sample

- **Period:** 2021-01-01 to 2025-09-30 (964 active trading days; 21 quarterly periods).
- **Universe:**
  - **FinTech cohort:** Constituents of 10 specialized FinTech indices on Bloomberg (UBXXFINT, MLFINTEC, BIGLFPVP, JP2PMT, BEFAP, BFPAT, FGFBIP, SOLFINT, BFNQ, BEFFP).
  - **Non-FinTech / Traditional cohort:** Constituents of the S&P 500 Index (SPX) excluding firms also classified as FinTech.
- **Final panel:** 608 firms, 21 quarterly observations each (unbalanced where data unavailable).

## 2. Dependent Variables (winsorized at 1st / 99th percentile)

| Variable | Definition | Bloomberg Field | Unit |
|---|---|---|---|
| `ROA` | Return on Assets | `RETURN_ON_ASSET` | % |
| `ROE` | Return on Common Equity | `RETURN_COM_EQY` | % |
| `PB_Ratio` | Price-to-Book Ratio (Market-to-Book) | `PX_TO_BOOK_RATIO` | ratio |

## 3. Independent and Moderating Variables

| Variable | Definition | Source | Construction |
|---|---|---|---|
| `ESG_Percentile` | Bloomberg ESG Score Percentile | Bloomberg | 0–100 scale; higher = better |
| `ESG_Rank` | S&P Global ESG Rank | S&P Global via Bloomberg | 0–100 scale; higher = better |
| `Average_ESG` | Composite ESG measure | Authors | (`ESG_Percentile` + `ESG_Rank`) / 2 |
| `FinTech` | FinTech classification dummy | Authors | 1 if firm appears in any of the 10 FinTech indices listed above; 0 otherwise |
| `ESG_x_FinTech` | Interaction term | Authors | `Average_ESG` × `FinTech` |

## 4. Control Variables

| Variable | Definition | Bloomberg Field | Transformation |
|---|---|---|---|
| `MarketCap` | Market capitalization | `CUR_MKT_CAP` | Log-transformed: `ln(MarketCap)` |
| `Debt_Assets` | Total Debt / Total Assets | `BS_TOT_LIAB2` / `BS_TOT_ASSET` | Ratio, %, or proportion |

## 5. Risk-Free Rate

| Variable | Definition | Source |
|---|---|---|
| `R_f` | Daily 3-month U.S. Treasury bill yield | FRED series `DTB3`, divided by 252 to obtain a daily rate |

## 6. Index Construction Variables

For each portfolio (EW and MCW), constructed daily for 2021–2025:

- **Daily log return:** `r_t = ln(p_t / p_{t-1})`
- **EW portfolio return:** simple average of constituent log returns.
- **MCW portfolio return:** market-cap-weighted average using lagged market cap as weights.
- **Cumulative return:** `cumprod(1 + r_t) - 1`.
- **Sharpe ratio (quarterly):** `(R_p - R_f) / σ_p`, where σ_p is the quarterly std. dev. of daily portfolio returns.
- **Treynor ratio (quarterly):** `(R_p - R_f) / β_p`, where β_p is estimated via OLS regression of portfolio returns on SPX returns over the quarter.

## 7. Treatment of Missing Data

- Firms with fewer than 4 quarters of valid ESG data are excluded.
- For continuous variables, observations missing the dependent variable are dropped (listwise).
- The panel is unbalanced; total firm-quarter observations: 12,670 (ROA), 12,147 (ROE), 12,198 (P/B).

## 8. Winsorization

All three dependent variables are winsorized at the 1st and 99th percentiles to handle extreme outliers (notably, raw P/B reaches >34,000 and ROE ranges from -2,763 to +2,065 prior to treatment).
