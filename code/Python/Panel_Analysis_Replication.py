"""
Panel_Analysis_Replication.py
=================================================================
ESG Performance and Financial Outcomes:
A Comparative Analysis of U.S. FinTech and Traditional Financial Institutions

Authors: Nawres Sedghiani, Burak Doğan
Bahçeşehir University, 2026

Python replication of the panel regression results reported in
Tables 6 and 7 of the manuscript. Coefficient estimates should
match the R primary analysis to within rounding.

Required input:  raw Bloomberg/S&P pulls in ../../data/raw/
Output:          regression results in ../../data/processed/
=================================================================
"""

import os
import numpy as np
import pandas as pd
from linearmodels.panel import PooledOLS, PanelOLS, RandomEffects
import statsmodels.api as sm
from statsmodels.stats.outliers_influence import variance_inflation_factor

# ---------- 0. Paths ----------
DATA_RAW = "../../data/raw"
DATA_PROCESSED = "../../data/processed"
OUTPUT = "../../output"
os.makedirs(DATA_PROCESSED, exist_ok=True)
os.makedirs(OUTPUT, exist_ok=True)

# ---------- 1. Load raw data ----------
# TODO: replace placeholder filenames with your actual Bloomberg pulls
financials = pd.read_csv(os.path.join(DATA_RAW, "firm_financials_quarterly.csv"))
esg_pct    = pd.read_csv(os.path.join(DATA_RAW, "bloomberg_esg_quarterly.csv"))
esg_rank   = pd.read_csv(os.path.join(DATA_RAW, "spglobal_esg_rank_quarterly.csv"))
fintech    = pd.read_csv(os.path.join(DATA_RAW, "fintech_classification.csv"))

# ---------- 2. Construct panel ----------
panel = (
    financials
    .merge(esg_pct,  on=["firm_id", "quarter"], how="left")
    .merge(esg_rank, on=["firm_id", "quarter"], how="left")
    .merge(fintech,  on="firm_id", how="left")
)

panel["Average_ESG"]   = (panel["ESG_Percentile"] + panel["ESG_Rank"]) / 2
panel["ESG_x_FinTech"] = panel["Average_ESG"] * panel["FinTech"]
panel["log_MarketCap"] = np.log(panel["MarketCap"])
panel["Debt_Assets"]   = panel["Total_Debt"] / panel["Total_Assets"]


def winsorize(s: pd.Series, p=(0.01, 0.99)) -> pd.Series:
    lo, hi = s.quantile(p[0]), s.quantile(p[1])
    return s.clip(lower=lo, upper=hi)


panel["ROA_w"] = winsorize(panel["ROA"])
panel["ROE_w"] = winsorize(panel["ROE"])
panel["PB_w"]  = winsorize(panel["PB_Ratio"])

panel = panel.set_index(["firm_id", "quarter"])
panel.to_csv(os.path.join(DATA_PROCESSED, "panel_dataset_analysis.csv"))

# ---------- 3. VIF diagnostics ----------
X_vif = sm.add_constant(
    panel[["Average_ESG", "FinTech", "ESG_x_FinTech",
           "log_MarketCap", "Debt_Assets"]].dropna()
)
vif_table = pd.DataFrame({
    "variable": X_vif.columns,
    "VIF": [variance_inflation_factor(X_vif.values, i)
            for i in range(X_vif.shape[1])]
})
print("\n--- VIF ---")
print(vif_table.to_string(index=False))

# ---------- 4. Main regressions (Table 6) ----------
exog_vars = ["Average_ESG", "FinTech", "ESG_x_FinTech",
             "log_MarketCap", "Debt_Assets"]


def run_pooled(dv: str):
    df = panel[[dv] + exog_vars].dropna()
    y = df[dv]
    X = sm.add_constant(df[exog_vars])
    model = PooledOLS(y, X)
    return model.fit(cov_type="clustered", cluster_entity=True)


print("\n========== Model 1: ROA ==========")
res_roa = run_pooled("ROA_w"); print(res_roa)
print("\n========== Model 2: ROE ==========")
res_roe = run_pooled("ROE_w"); print(res_roe)
print("\n========== Model 3: P/B ==========")
res_pb  = run_pooled("PB_w");  print(res_pb)

# ---------- 5. Save coefficient tables ----------
def to_dict(res, model_name: str):
    return {
        "model": model_name,
        **{f"{p}_coef": res.params[p] for p in res.params.index},
        **{f"{p}_se":   res.std_errors[p] for p in res.std_errors.index},
        **{f"{p}_pval": res.pvalues[p] for p in res.pvalues.index},
        "n_obs": int(res.nobs),
        "r2":    float(res.rsquared),
    }


coef_table = pd.DataFrame([
    to_dict(res_roa, "ROA"),
    to_dict(res_roe, "ROE"),
    to_dict(res_pb,  "PB"),
])
coef_table.to_csv(os.path.join(DATA_PROCESSED, "regression_results.csv"),
                  index=False)

# ---------- 6. Robustness checks (Table 7 — ROA) ----------
# TODO: implement the four ROA specifications:
#       (1) Baseline, (2) +Leverage, (3) Winsorized DV, (4) Non-clustered SEs

print("\nDone. Outputs saved to:", DATA_PROCESSED)
