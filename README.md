# NBIM-Analysis

Exploratory data analysis of the Norwegian Government Pension Fund Global (NBIM), covering portfolio holdings from 1998 to 2025.

The project is structured as a multi-stage analysis pipeline:

| Stage | Description | Status |
|---|---|---|
| 01 — Data Pipeline | Fetches holdings data from NBIM API and loads it into MySQL | Complete |
| 02 — EDA | Exploratory analysis of portfolio composition, geography, sectors, and concentration | Complete |
| 03 — Risk Analysis | Equity price data, return distributions, VaR/CVaR at position and portfolio level | Planned |

---

## Project Structure

```
nbim-analysis/
│
├── README.md
│
├── data/
│   └── .gitkeep                  # Data is stored locally in MySQL
│
├── 01_data_pipeline/
│   ├── 01_Setup.ipynb            # Fetches data from NBIM API and loads into MySQL
│   └── sql/
│       ├── 01_schema.sql         # Table definition
│       ├── 02_clean_equity.sql   # Standardises equity sector labels
│       ├── 03_clean_fi.sql       # Standardises fixed income sector labels
│       └── 99_reset.sql          # Wipes data for a clean re-load
│
├── 02_eda/
│   └── 02_EDA.ipynb              # Exploratory data analysis and visualisations
│
└── 03_risk/
    └── .gitkeep                  # Planned: VaR/CVaR analysis
```

---

## Data Source

Holdings data is fetched from NBIM's public investments API:

```
https://www.nbim.no/api/investments/v2/{date}.json
```

The dataset covers all equity and fixed income holdings reported at year-end from 1998 to 2025, totalling approximately 218,000 rows.

---

## Setup

### Prerequisites

- Python 3.10+
- MySQL 8.0+
- Jupyter Notebook

### Python dependencies

```bash
pip install pandas numpy mysql-connector-python matplotlib seaborn pycountry-convert requests
```

### Database

1. Create a MySQL database named `nbim`
2. Run `01_data_pipeline/sql/01_schema.sql` to create the holdings table
3. Set your database password as an environment variable:

```bash
# Windows
set NBIM_DB_PASSWORD=yourpassword

# macOS / Linux
export NBIM_DB_PASSWORD=yourpassword
```

4. Open `01_data_pipeline/01_Setup.ipynb` and update `DB_CONFIG` to use `os.environ.get("NBIM_DB_PASSWORD")`
5. Run `01_Setup.ipynb` to fetch data and load it into MySQL (~5–10 minutes)
6. Run `sql/02_clean_equity.sql` and `sql/03_clean_fi.sql` to standardise sector labels

---

## Stage 2 — EDA

`02_eda/02_EDA.ipynb` covers the following:

| Section | Description |
|---|---|
| Data Overview | Shape, dtypes, descriptive statistics |
| Portfolio Size | Total AUM in USD billions by asset class |
| Number of Holdings | Distinct companies held per year |
| Asset Class Allocation | Equity vs. Fixed Income weight over time |
| Geographic Exposure | Continent-level equity allocation over time |
| Equity Sector Exposure | GICS sector weights over time |
| Fixed Income Sector Exposure | Bond type weights over time |
| Portfolio Concentration | Top-10 share and HHI over time |

### Selected findings

- NBIM's equity allocation has grown from ~40% in 1998 to ~70% in recent years
- North America has overtaken Europe as the dominant geographic exposure
- Portfolio concentration declined steadily through 2016 before rising sharply — driven by the outperformance of a small number of US technology companies
- NVIDIA rose from outside the top-5 equity holdings in 2022 to the single largest position in 2025, with a weight of ~3.8%

---

## Stage 3 — Risk Analysis *(planned)*

The planned risk analysis will combine NBIM's position weights from stage 1 with historical equity price data to produce:

- Return distributions per holding and sector
- Value at Risk (VaR) and Conditional Value at Risk (CVaR) at position and portfolio level
- Comparison of realised risk across different market regimes (dot-com, GFC, COVID, rate hike cycle)

Price data will be sourced from Yahoo Finance via the `yfinance` library.

---

## Notes

- Sector data for early years (1998–2001) is sparse and should be interpreted with caution
- Fixed income sector labels have been harmonised across four categories: Corporate, Government, Government Related, and Securitized
- The 2025 data reflects holdings as of the most recent available year-end snapshot from the API

---

## License

This project is for educational and research purposes. Holdings data is publicly available via NBIM's investor relations website at [nbim.no](https://www.nbim.no).
