# 🌐 End-to-End Financial Analytics Platform

## 📌 Overview

The **End-to-End Financial Analytics Platform** is a production-oriented Data Engineering and Analytics Engineering project designed to demonstrate modern cloud-native financial data pipelines.

The platform ingests financial market and company data from external APIs, validates and loads the data into Google BigQuery, transforms it using dbt, and prepares trusted analytical datasets for reporting, forecasting, and executive dashboards.

The project follows a phased implementation strategy, allowing it to evolve from a lightweight MVP into a fully containerised, streaming-enabled enterprise data platform.

---

# 🏗️ Solution Architecture

```text
                         ┌─────────────────────┐
                         │  Financial APIs     │
                         │ Alpha Vantage       │
                         │ Finnhub             │
                         └─────────┬───────────┘
                                   │
                        ┌─────────────────────┐
                        │   DOCKER LAYER      │
                        │ (Future Phase)      │
                        └─────────┬───────────┘
                                   │
                         Python Data Pipeline
                                   │
                                   ▼
                         BigQuery Raw Layer
                           financial_raw
                                   │
                                   ▼
                                 dbt
                                   │
                        Analytics Engineering
                                   │
                                   ▼
                      BigQuery Analytics Layer
                        financial_analytics
                                   │
                 ┌─────────────────┴─────────────────┐
                 ▼                                   ▼
     Financial Forecasting                 Financial Risk Models
                 │                                   │
                 └─────────────────┬─────────────────┘
                                   ▼
                              Power BI
                                   │
                                   ▼
                       Executive Dashboards
```

---

# 🚀 Project Objectives

The platform demonstrates:

* Python-based data ingestion
* API integration
* Cloud data warehousing
* Analytics engineering using dbt
* Data quality testing
* Financial analytics modelling
* CI/CD readiness
* Enterprise data architecture patterns

---

# 🛠 Technology Stack

## Data Ingestion

* Python
* Requests
* Pandas

## Cloud Platform

* Google Cloud Platform (GCP)
* BigQuery

## Analytics Engineering

* dbt Core
* dbt BigQuery Adapter

## Testing

* Pytest
* dbt Tests

## Reporting

* Power BI

## Future Enhancements

* Kafka
* Spark Structured Streaming
* Airflow
* Terraform
* Docker
* Great Expectations
* Prometheus
* Grafana

---

# 🥇 Build Strategy

## 🟢 PHASE 1 — Lean Build

Python → BigQuery → dbt → Power BI

## 🟡 PHASE 2 — Streaming Foundations

Kafka → Spark → Cloud Storage

## 🟠 PHASE 3 — Enterprise Data Engineering

Airflow, Debezium, CDC Pipelines

## 🔵 PHASE 4 — Containerisation

Dockerise all services

## 🔴 PHASE 5 — CI/CD & Production Readiness

GitHub Actions
Infrastructure as Code
Monitoring and Alerting

---

# 🔑 Stage 1 Prerequisites & Cloud Setup

## Step 1: Obtain API Keys

### Alpha Vantage

Register and obtain an API key.

```env
ALPHA_VANTAGE_API_KEY=YOUR_KEY
```

### Finnhub

Register and obtain an API key.

```env
FINNHUB_API_KEY=YOUR_KEY
```

---

## Step 2: Google Cloud Setup

Create a Google Cloud Project.

Enable:

* BigQuery API

Create dataset:

```text
financial_raw
```

Create a Service Account and assign:

* BigQuery Data Editor
* BigQuery Job User

Download the JSON key and save:

```text
credentials/gcp-key.json
```

---

## Step 3: Configure Environment Variables

Create a `.env` file.

```env
ALPHA_VANTAGE_API_KEY=YOUR_KEY
FINNHUB_API_KEY=YOUR_KEY

GCP_PROJECT_ID=crested-talon-499420-r9
BIGQUERY_DATASET=financial_raw

GOOGLE_APPLICATION_CREDENTIALS=credentials/gcp-key.json
```

---

## Step 4: Verify BigQuery Connectivity

```python
from google.cloud import bigquery

client = bigquery.Client()

print(client.project)

datasets = list(client.list_datasets())

for ds in datasets:
    print(ds.dataset_id)
```

---

# 📂 Project Structure

```text
financial_analytics_platform/
│
├── data/
│   └── extracts/
│
├── outputs/
│
├── src/
│   ├── config/
│   │   └── settings.py
│   │
│   ├── extract/
│   │   ├── alpha_vantage.py
│   │   └── finnhub.py
│   │
│   ├── load/
│   │   └── bigquery_loader.py
│   │
│   ├── utils/
│   │   ├── logger.py
│   │   └── validators.py
│   │
│   └── main.py
│
├── tests/
│   ├── test_extract.py
│   └── test_validators.py
│
├── financial_dbt/
│   ├── analyses/
│   ├── macros/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_stock_prices.sql
│   │   │   ├── stg_company_profiles.sql
│   │   │   ├── schema.yml
│   │   │   └── sources.yml
│   │   │
│   │   └── mart/
│   │       └── fact_stock_performance.sql
│   │
│   ├── seeds/
│   ├── snapshots/
│   ├── tests/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   └── README.md
│
├── logs/
│   └── dbt.log
│
├── requirements.txt
├── .env
├── .gitignore
└── README.md
```

---

# ⚙️ Stage 1 Data Pipeline

## Data Sources

### Alpha Vantage

Provides:

* Daily stock prices
* Trading volume
* Historical market data

### Finnhub

Provides:

* Company metadata
* Industry classifications
* Market capitalisation

---

## Pipeline Flow

```text
Alpha Vantage API
        │
        ▼
Stock Prices Data
        │
        ▼
Validation
        │
        ▼
BigQuery financial_raw.stock_prices

Finnhub API
        │
        ▼
Company Profiles
        │
        ▼
Validation
        │
        ▼
BigQuery financial_raw.company_profiles
```

---

# 🧪 Testing Framework

## Run Unit Tests

```bash
pytest
```

### Included Tests

#### test_extract.py

Validates successful extraction from Alpha Vantage.

#### test_validators.py

Validates:

* Non-empty datasets pass validation
* Empty datasets raise exceptions

---

# 📊 Analytics Engineering Layer (dbt)

## Purpose

The Analytics Engineering layer transforms raw financial data into trusted analytical datasets.

Benefits include:

* Centralised business logic
* Data quality enforcement
* Reusable analytical models
* Data lineage documentation

---

# 🏗 Analytics Architecture

```text
BigQuery
│
├── financial_raw
│   ├── stock_prices
│   └── company_profiles
│
└── financial_analytics
    │
    ├── stg_stock_prices
    ├── stg_company_profiles
    │
    └── fact_stock_performance
```

---

# ⚙️ Configure dbt

Install:

```bash
pip install dbt-bigquery
```

Initialise project:

```bash
dbt init financial_dbt
```

---

## profiles.yml

```yaml
financial_dbt:
  outputs:
    dev:
      dataset: financial_analytics
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: C:\Users\docto\OneDrive\Dokumente\Coding\financial-analytics-platform\credentials\gcp-key.json
      location: EU
      method: service-account
      priority: interactive
      project: crested-talon-499420-r9
      threads: 4
      type: bigquery

  target: dev
```

---

# 📂 Source Configuration

## sources.yml

```yaml
version: 2

sources:
  - name: financial_raw
    database: crested-talon-499420-r9
    schema: financial_raw

    tables:
      - name: stock_prices

      - name: company_profiles
```

---

# 🔄 Staging Models

## stg_stock_prices.sql

```sql
SELECT
    symbol,
    DATE(date) AS trading_date,
    CAST(open AS FLOAT64) AS open_price,
    CAST(high AS FLOAT64) AS high_price,
    CAST(low AS FLOAT64) AS low_price,
    CAST(close AS FLOAT64) AS close_price,
    CAST(volume AS INT64) AS volume

FROM {{ source('financial_raw', 'stock_prices') }}
```

---

## stg_company_profiles.sql

```sql
SELECT
    ticker,
    name,
    exchange,
    finnhubIndustry,
    marketCapitalization

FROM {{ source('financial_raw', 'company_profiles') }}
```

---

# 📈 Mart Layer

## fact_stock_performance.sql

```sql
SELECT
    p.symbol,
    c.name,
    p.trading_date,
    p.close_price,
    p.volume,

    AVG(p.close_price)
        OVER(
            PARTITION BY p.symbol
            ORDER BY p.trading_date
            ROWS BETWEEN 29 PRECEDING
            AND CURRENT ROW
        ) AS moving_avg_30d

FROM {{ ref('stg_stock_prices') }} p

LEFT JOIN {{ ref('stg_company_profiles') }} c
ON p.symbol = c.ticker
```

---

# 🧪 Data Quality Tests

## schema.yml

```yaml
version: 2

models:
  - name: stg_stock_prices

    columns:

      - name: symbol
        tests:
          - not_null

      - name: trading_date
        tests:
          - not_null
```

---

# ▶️ Running dbt

Validate configuration:

```bash
dbt debug
```

Build models:

```bash
dbt run
```

Run tests:

```bash
dbt test
```

Generate documentation:

```bash
dbt docs generate
```

Serve documentation:

```bash
dbt docs serve
```

---

# 🔍 Data Validation Queries

## Row Counts

### Stock Prices

```sql
SELECT
    symbol,
    COUNT(*) AS total_rows

FROM `crested-talon-499420-r9.financial_raw.stock_prices`

GROUP BY symbol
ORDER BY symbol;
```

---

### Company Profiles

```sql
SELECT
    ticker,
    COUNT(*) AS total_rows

FROM `crested-talon-499420-r9.financial_raw.company_profiles`

GROUP BY ticker
ORDER BY ticker;
```

---

## Duplicate Detection

```sql
SELECT
    symbol,
    date,
    COUNT(*) AS occurrences

FROM `crested-talon-499420-r9.financial_raw.stock_prices`

GROUP BY symbol, date

HAVING COUNT(*) > 1

ORDER BY symbol, date;
```

---

# 🚀 Running the Entire Platform

## Execute Unit Tests

```bash
pytest
```

## Run Ingestion Pipeline

```bash
python -m src.main
```

## Verify BigQuery Raw Layer

```text
financial_raw.stock_prices
financial_raw.company_profiles
```

## Execute Analytics Layer

```bash
cd financial_dbt

dbt run
dbt test
```

## Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

---

# 📈 Expected Outputs

## BigQuery Raw Dataset

```text
financial_raw.stock_prices
financial_raw.company_profiles
```

## BigQuery Analytics Dataset

```text
financial_analytics.stg_stock_prices
financial_analytics.stg_company_profiles
financial_analytics.fact_stock_performance
```

---

# 🎯 Stage 1 Deliverables

At completion of Stage 1 the platform delivers:

✅ API-based financial data ingestion

✅ Cloud-native BigQuery storage

✅ Automated validation

✅ Unit testing

✅ Analytics engineering with dbt

✅ Data quality testing

✅ Business-ready analytical models

✅ Data lineage documentation

✅ Foundation for Power BI dashboards

✅ Foundation for streaming architectures

---

# 📦 Version Control

Before moving to Stage 2 create a release tag.

```bash
git tag -a v1.0-stage1 -m "Stage 1 complete"

git push origin v1.0-stage1
```

This provides a stable checkpoint before introducing streaming technologies.

---

# 🔮 Stage 2 Roadmap

Stage 2 introduces real-time data processing.

```text
Financial APIs
        │
        ▼
      Kafka
        │
        ▼
Spark Streaming
        │
        ▼
Google Cloud Storage
        │
        ▼
BigQuery
        │
        ▼
dbt
        │
        ▼
Power BI
```

Planned technologies:

* Apache Kafka
* Apache Spark Structured Streaming
* Google Cloud Storage
* Incremental dbt Models
* Event-Driven Architecture
* Real-Time Financial Analytics

---

# 👤 Author

Utuedor Binah

ACCA | MSc Financial Technology | Executive MBA

Data Engineering • Financial Analytics • FinOps • Cloud Platforms

---

**Version:** v1.0-stage1
