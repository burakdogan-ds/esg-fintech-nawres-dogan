# `data/processed/` — Aggregated, share-safe outputs

This folder contains processed and aggregated datasets generated from the raw Bloomberg / S&P data. These outputs are at a level of aggregation that **does not redistribute proprietary raw data**, and may be shared publicly.

## Suggested contents

| Filename | Description |
|---|---|
| `panel_dataset_anonymized.csv` | Firm-level quarterly panel with all regression variables. Firm IDs anonymized; raw price/market data removed. |
| `ESG_Portfolios.xlsx` | Equal-Weighted (EW) and Market-Cap-Weighted (MCW) ESG indices for benchmark and FinTech cohorts. |
| `Financial_Returns_Data.xlsx` | Daily log returns, cumulative returns, quarterly Sharpe and Treynor ratios for all indices (index-level only, not firm-level). |
| `regression_results.csv` | Coefficient estimates, standard errors, and p-values from all regression specifications reported in Tables 6 and 7. |

## Notes

- Firm identifiers should be replaced with anonymous IDs (e.g., `firm_0001`, `firm_0002`) where possible to further reduce re-identification risk.
- If your institution's licensing agreement permits sharing aggregated indices but not firm-level data, keep `panel_dataset_anonymized.csv` private and only share the index-level files.
- When in doubt, consult the Bloomberg Terminal license agreement or your institution's data steward before adding any file here.
