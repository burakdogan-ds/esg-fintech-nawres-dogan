# =====================================================================
#  Panel_Analysis.R
#  ESG Performance and Financial Outcomes:
#  A Comparative Analysis of U.S. FinTech and Traditional Financial Institutions
#
#  Authors: Nawres Sedghiani, Burak Doğan
#  Bahçeşehir University, 2026
#
#  This script reproduces all empirical results in the paper.
#  Required input: raw Bloomberg/S&P pulls in ../../data/raw/
#  Output: tables and figures saved to ../../output/
# =====================================================================

# ---------- 0. Setup ----------
rm(list = ls())
options(scipen = 999)

required_pkgs <- c("plm", "lmtest", "sandwich", "car",
                   "dplyr", "readr", "readxl", "tidyr",
                   "moments", "PerformanceAnalytics")
new_pkgs <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs)) install.packages(new_pkgs, dependencies = TRUE)
invisible(lapply(required_pkgs, library, character.only = TRUE))

# Paths (script assumed to be run from code/R/)
DATA_RAW       <- "../../data/raw"
DATA_PROCESSED <- "../../data/processed"
OUTPUT         <- "../../output"
dir.create(DATA_PROCESSED, showWarnings = FALSE, recursive = TRUE)
dir.create(OUTPUT, showWarnings = FALSE, recursive = TRUE)

# ---------- 1. Load raw data ----------
# TODO: Replace placeholder filenames with actual Bloomberg pulls.
#       See data/raw/README.md for the expected file list.

prices    <- read_csv(file.path(DATA_RAW, "bloomberg_prices_daily.csv"))
mcap      <- read_csv(file.path(DATA_RAW, "bloomberg_marketcap_daily.csv"))
esg_pct   <- read_csv(file.path(DATA_RAW, "bloomberg_esg_quarterly.csv"))
esg_rank  <- read_csv(file.path(DATA_RAW, "spglobal_esg_rank_quarterly.csv"))
financials<- read_csv(file.path(DATA_RAW, "firm_financials_quarterly.csv"))
fintech   <- read_csv(file.path(DATA_RAW, "fintech_classification.csv"))
rf        <- read_csv(file.path(DATA_RAW, "risk_free_rate_daily.csv"))

# ---------- 2. Construct composite ESG and FinTech dummy ----------
panel <- financials %>%
  left_join(esg_pct,  by = c("firm_id", "quarter")) %>%
  left_join(esg_rank, by = c("firm_id", "quarter")) %>%
  left_join(fintech,  by = "firm_id") %>%
  mutate(
    Average_ESG    = (ESG_Percentile + ESG_Rank) / 2,
    ESG_x_FinTech  = Average_ESG * FinTech,
    log_MarketCap  = log(MarketCap),
    Debt_Assets    = Total_Debt / Total_Assets
  )

# Winsorization at 1% / 99% for the three DVs
winsorize <- function(x, p = c(0.01, 0.99)) {
  q <- quantile(x, p, na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}

panel <- panel %>%
  mutate(
    ROA_w = winsorize(ROA),
    ROE_w = winsorize(ROE),
    PB_w  = winsorize(PB_Ratio)
  )

write_csv(panel, file.path(DATA_PROCESSED, "panel_dataset_analysis.csv"))

# ---------- 3. Daily log returns and portfolios ----------
# TODO: Compute daily log returns; aggregate into EW and MCW portfolios
#       for SPX, NonFinTech, and each FinTech index.
#       Save daily series to data/processed/Financial_Returns_Data.xlsx

# ---------- 4. Descriptive statistics, Sharpe, Treynor ----------
# TODO: Reproduce Tables 1, 3, 5 in the paper. Use moments::skewness, kurtosis.
#       Beta estimated via OLS of portfolio return on SPX return per quarter.

# ---------- 5. Hypothesis testing ----------
# TODO: Reproduce Table 4 (paired t-tests) and Pearson correlations (Table 2).

# ---------- 6. Multicollinearity diagnostics (VIF) ----------
vif_model <- lm(ROA_w ~ Average_ESG + FinTech + ESG_x_FinTech +
                  log_MarketCap + Debt_Assets, data = panel)
print(vif(vif_model))

# ---------- 7. Hausman test: FE vs RE ----------
fe_model <- plm(ROA_w ~ Average_ESG + FinTech + ESG_x_FinTech +
                  log_MarketCap + Debt_Assets,
                data = panel, index = c("firm_id", "quarter"),
                model = "within")
re_model <- plm(ROA_w ~ Average_ESG + FinTech + ESG_x_FinTech +
                  log_MarketCap + Debt_Assets,
                data = panel, index = c("firm_id", "quarter"),
                model = "random")
print(phtest(fe_model, re_model))

# ---------- 8. Main regressions (Table 6) ----------
formula_main <- function(dv) {
  reformulate(c("Average_ESG", "FinTech", "ESG_x_FinTech",
                "log_MarketCap", "Debt_Assets"), response = dv)
}

m1 <- plm(formula_main("ROA_w"), data = panel,
          index = c("firm_id", "quarter"), model = "pooling")
m2 <- plm(formula_main("ROE_w"), data = panel,
          index = c("firm_id", "quarter"), model = "pooling")
m3 <- plm(formula_main("PB_w"),  data = panel,
          index = c("firm_id", "quarter"), model = "pooling")

# Cluster-robust SEs at firm level
cl_se <- function(model) {
  coeftest(model, vcov. = vcovHC(model, type = "HC1", cluster = "group"))
}

cat("\n========== Model 1: ROA ==========\n"); print(cl_se(m1))
cat("\n========== Model 2: ROE ==========\n"); print(cl_se(m2))
cat("\n========== Model 3: P/B ==========\n"); print(cl_se(m3))

# ---------- 9. Robustness checks (Table 7) ----------
# TODO: Run the four ROA specifications:
#       (1) Baseline (no leverage, no winsorization)
#       (2) +Leverage
#       (3) Winsorized DV
#       (4) Non-clustered SEs (for comparison)

# ---------- 10. Save coefficient tables ----------
# TODO: Export Tables 6 and 7 to data/processed/regression_results.csv

cat("\nDone. Outputs saved to:", DATA_PROCESSED, "and", OUTPUT, "\n")
