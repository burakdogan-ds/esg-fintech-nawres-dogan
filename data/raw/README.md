# `data/raw/` — Bloomberg / S&P Global raw pulls (not committed)

This directory holds the **raw, licensed data** required to reproduce the analysis. **Files here are explicitly excluded from version control via `.gitignore`** because Bloomberg and S&P Global terms of service prohibit redistribution.

## What goes here (locally)

After pulling the variables described in `docs/Variable_Definitions_Codebook.md` from the Bloomberg Terminal, save the following files in this folder:

| Filename | Description | Source |
|---|---|---|
| `bloomberg_prices_daily.csv` | Daily closing prices for all sample firms, 2021–2025 | Bloomberg Terminal |
| `bloomberg_marketcap_daily.csv` | Daily market capitalization for all firms | Bloomberg Terminal |
| `bloomberg_esg_quarterly.csv` | ESG Score Percentile (quarterly) | Bloomberg Terminal |
| `spglobal_esg_rank_quarterly.csv` | S&P Global ESG Rank (quarterly) | S&P Global / Bloomberg |
| `firm_financials_quarterly.csv` | ROA, ROE, P/B, Total Debt, Total Assets | Bloomberg Terminal |
| `fintech_classification.csv` | Firm-level FinTech / non-FinTech indicator | Authors' classification based on Bloomberg FinTech indices |
| `risk_free_rate_daily.csv` | Daily 3-month T-bill rate (proxy for $R_f$) | FRED / Bloomberg |

## Reminder

**Do not commit these files.** The `.gitignore` rule excludes everything in this folder except the placeholder and this README. If you accidentally stage a raw file, GitHub will refuse to display it in the public repository, but local clones could still leak it — always check `git status` before commits.
