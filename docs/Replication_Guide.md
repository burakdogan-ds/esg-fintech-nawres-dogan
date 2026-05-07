# Replication Guide

Step-by-step instructions to reproduce all empirical results in the paper.

## Prerequisites

### Software
- **R** ≥ 4.2 (with packages: `plm`, `lmtest`, `sandwich`, `car`, `dplyr`, `readr`, `readxl`)
- **Python** ≥ 3.10 (see `code/Python/requirements.txt`)
- **LaTeX** distribution (TeX Live, MiKTeX, or Overleaf) to compile the manuscript

### Data access
- Active **Bloomberg Terminal** subscription with ESG fields enabled
- Access to **S&P Global ESG** data through Bloomberg or directly

## Step 1 — Pull raw data from Bloomberg

Using the Bloomberg Excel API or the `Rblpapi` / `xbbg` libraries, pull the variables listed in `Variable_Definitions_Codebook.md` for:

- All S&P 500 constituents over 2021-01-01 to 2025-09-30
- All constituents of the 10 FinTech indices (UBXXFINT, MLFINTEC, BIGLFPVP, JP2PMT, BEFAP, BFPAT, FGFBIP, SOLFINT, BFNQ, BEFFP) over the same window

Save the resulting CSVs in `data/raw/` with the filenames specified in `data/raw/README.md`.

## Step 2 — Run the analysis

### Option A: R (primary)

```r
# From the repository root
setwd("code/R")
source("Panel_Analysis.R")
```

This script will:
1. Load and merge raw data from `../../data/raw/`
2. Construct the composite ESG variable and FinTech dummy
3. Build EW and MCW portfolio indices
4. Compute descriptive statistics, Sharpe and Treynor ratios (Tables 1, 3, 5)
5. Run paired t-tests on daily returns (Table 4)
6. Run Pearson correlation matrices (Table 2)
7. Estimate the panel regressions (Table 6) with cluster-robust SEs and winsorized DVs
8. Run the four robustness specifications (Table 7)
9. Save outputs to `../../data/processed/` and `../../output/`

### Option B: Python (replication)

```bash
cd code/Python
pip install -r requirements.txt
python Panel_Analysis_Replication.py
```

The Python script reproduces the regression results from Tables 6 and 7 using `linearmodels` and `statsmodels`. Coefficient estimates should match the R output to within rounding.

## Step 3 — Compile the manuscript

```bash
cd manuscript
pdflatex manuscript_combined.tex
pdflatex manuscript_combined.tex   # second pass for cross-references
```

Or upload `manuscript_combined.tex` to Overleaf.

## Expected runtime

- Data pull: 30–60 minutes (Bloomberg-side bottleneck)
- R script (full pipeline): ~5–10 minutes on a modern laptop
- Python regression replication: ~2 minutes
- LaTeX compile: <30 seconds

## Troubleshooting

| Issue | Resolution |
|---|---|
| `lmodern.sty` not found | Install full TeX Live, or comment out `\usepackage{lmodern}` |
| `plm` package error in R | `install.packages(c("plm","lmtest","sandwich","car"))` |
| Bloomberg field returns blank | Some ESG fields require a separate ESG license; check with your institution's terminal |
| Coefficient differs from paper at the 4th decimal | Likely due to BLAS/LAPACK precision differences across operating systems; differences <1e-3 are expected |

## Citation

Please cite the manuscript and this replication package as indicated in `CITATION.cff`.
