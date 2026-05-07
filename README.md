# ESG Performance and Financial Outcomes: FinTech vs. Traditional Financial Institutions

Replication package for the manuscript:

> **Sedghiani, N. & Doğan, B.** (2026). *ESG Performance and Financial Outcomes: A Comparative Analysis of U.S. FinTech and Traditional Financial Institutions.* Working paper, Bahçeşehir University.

---

## Overview

This repository contains the LaTeX manuscript, replication code (R and Python), processed datasets, and documentation needed to reproduce all empirical results reported in the paper. The study uses a quarterly firm-level panel of U.S.-listed FinTech, non-FinTech, and S&P 500 reference firms over 2021–2025 to estimate the differential impact of ESG performance on financial outcomes (ROA, ROE, P/B ratio).

## Repository structure

```
esg-fintech-paper/
├── manuscript/                  LaTeX source of the paper
│   └── manuscript_combined.tex
├── code/
│   ├── R/                       R scripts (primary analysis)
│   │   └── Panel_Analysis.R
│   └── Python/                  Python replication
│       ├── Panel_Analysis_Replication.py
│       └── requirements.txt
├── data/
│   ├── processed/               Aggregated, share-safe outputs
│   └── raw/                     Bloomberg pulls — NOT included (gitignored)
├── docs/
│   ├── Variable_Definitions_Codebook.md
│   └── Replication_Guide.md
├── README.md
├── LICENSE
├── CITATION.cff
└── .gitignore
```

## Data availability and licensing

> ⚠️ **Important.** Raw input data are sourced from the Bloomberg Terminal and S&P Global under institutional license. Per Bloomberg's and S&P's terms of service, raw data **cannot be redistributed** through this repository. Consequently, only aggregated/processed datasets and replication code are provided publicly.

To fully reproduce the analysis, users must:
1. Have institutional access to the Bloomberg Terminal.
2. Pull the variables listed in `docs/Variable_Definitions_Codebook.md` for the firms and date range specified.
3. Place the resulting files in `data/raw/` (this folder is gitignored).
4. Run the scripts in `code/`.

Aggregated outputs (e.g., portfolio-level ESG indices, daily portfolio returns, regression coefficients) sufficient to verify reported tables are provided in `data/processed/` where licensing permits.

## Replication

See `docs/Replication_Guide.md` for full instructions.

**Quick start (R):**
```r
setwd("code/R")
source("Panel_Analysis.R")
```

**Quick start (Python):**
```bash
cd code/Python
pip install -r requirements.txt
python Panel_Analysis_Replication.py
```

## Citation

If you use this code or refer to the paper, please cite as indicated in `CITATION.cff`.

## License

- **Code** (everything under `code/`) is released under the **MIT License** (see `LICENSE`).
- **Documentation and manuscript text** are released under **CC BY 4.0**.
- **Data** are subject to the underlying Bloomberg / S&P Global licensing terms and are not redistributed.

## Contact

**Burak Doğan** (corresponding author)
Department of Economics, FEASS, Bahçeşehir University
Istanbul, Türkiye
✉ burak.dogan@bau.edu.tr

---

*Last updated: 2026.*
