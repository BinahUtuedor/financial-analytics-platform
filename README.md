# 🌐 End-to-End Financial Analytics Platform

## 📌 Overview

The **End-to-End Financial Analytics Platform** is a production-oriented data engineering and analytics project designed to demonstrate modern financial data pipelines and analytics workflows.

The platform ingests financial data from external APIs, validates and stores it in a cloud data warehouse, transforms it using analytics engineering best practices, and ultimately delivers actionable insights through executive dashboards.

The implementation follows a **phase-based approach**, allowing the platform to evolve gradually from a lean MVP into a fully containerised, production-grade architecture.

---

## 🏗️ Solution Architecture

```text
# 🌐 End-to-End Financial Analytics Platform

                         ┌─────────────────────┐
                         │  Financial APIs     │
                         └─────────┬───────────┘
                                   │
                        ┌─────────────────────┐
                        │   DOCKER LAYER      │
                        │ (All services run   │
                        │  in containers)     │
                        └─────────┬───────────┘
                                   │
                        Python API Producers
                                   │
                                   ▼
                              Kafka Topics
                                   │
                    ┌──────────────┴──────────────┐
                    │   CDC (Debezium)            │
                    └──────────────┬──────────────┘
                                   │
                 Operational DB (PostgreSQL/MySQL)
                                   │
                                   ▼
                     Spark Structured Streaming
                                   │
                                   ▼
              Google Cloud Storage (Bronze/Silver/Gold)
                                   │
                         Great Expectations
                                   │
                                   ▼
                        BigQuery Data Warehouse
                                   │
                                   ▼
                                  dbt
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

## 🚀 Supporting Infrastructure

### 🔄 CI/CD (GitHub Actions)

* Unit testing
* Integration testing
* Build validation
* dbt execution
* Deployment automation

### ☁️ Infrastructure as Code (Terraform)

* GCP provisioning
* Optional AWS support

### 📈 Monitoring & Observability

* Prometheus
* Grafana
* Alerting
* Dashboard visualisation

---

# 🥇 Build Strategy

## 🟢 PHASE 1 — Lean Build (No Docker)

Python API ingestion → BigQuery → dbt → Power BI

## 🟡 PHASE 2 — Streaming Foundations

Kafka → Spark → Google Cloud Storage

## 🟠 PHASE 3 — Complex Data Systems

Debezium, Airflow, Spark Structured Streaming

## 🔵 PHASE 4 — Containerisation

Dockerise all stabilised services.

## 🔴 PHASE 5 — CI/CD Automation

Automated tests, dbt runs, release pipelines.

---

# 🔑 Stage 1 Prerequisites & Cloud Setup

## Step 1: Get an Alpha Vantage API Key

Register and save:

```env
ALPHA_VANTAGE_API_KEY=YOUR_KEY
```

## Step 2: Get a Finnhub API Key

Register and save:

```env
FINNHUB_API_KEY=YOUR_KEY
```

## Step 3–9: Google Cloud Setup

* Create GCP Project
* Enable BigQuery API
* Create dataset: financial_raw
* Create Service Account
* Assign:
  * BigQuery Data Editor
  * BigQuery Job User
* Download JSON key
* Save:

```text
credentials/gcp-key.json
```

## Step 10: Configure .env

```env
ALPHA_VANTAGE_API_KEY=YOUR_KEY
FINNHUB_API_KEY=YOUR_KEY
GCP_PROJECT_ID=your-project-id
BIGQUERY_DATASET=financial_raw
GOOGLE_APPLICATION_CREDENTIALS=credentials/gcp-key.json
```

## Step 11: Verify Setup

```python
from google.cloud import bigquery

client = bigquery.Client()
print(client.project)

datasets = list(client.list_datasets())

for ds in datasets:
    print(ds.dataset_id)
```

---

# 📂 Stage 1 Folder Structure

```text
financial_analytics_platform/
│
├── data/
│   └── extracts/
├── outputs/
├── src/
│   ├── config/
│   │   └── settings.py
│   ├── extract/
│   │   ├── alpha_vantage.py
│   │   └── finnhub.py
│   ├── load/
│   │   └── bigquery_loader.py
│   ├── utils/
│   │   ├── logger.py
│   │   └── validators.py
│   └── main.py
├── tests/
│   ├── test_extract.py
│   └── test_validators.py
├── requirements.txt
├── .env
├── .gitignore
└── README.md
```

---

# ⚙️ Stage 1 Implementation Guide

## requirements.txt

```text
pandas
requests
google-cloud-bigquery
python-dotenv
pyarrow
pytest
```

## src/config/settings.py

```python
import os
from dotenv import load_dotenv

load_dotenv()

ALPHA_VANTAGE_API_KEY = os.getenv("ALPHA_VANTAGE_API_KEY")
FINNHUB_API_KEY = os.getenv("FINNHUB_API_KEY")
GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID")
BIGQUERY_DATASET = os.getenv("BIGQUERY_DATASET")
```

## src/utils/logger.py

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

logger = logging.getLogger(__name__)
```

## src/utils/validators.py

```python
import pandas as pd

def validate_dataframe(df):
    if df.empty:
        raise ValueError("Extracted dataframe is empty.")
    return True
```

## src/extract/alpha_vantage.py

```python
# Original extractor code preserved.
```

## src/extract/finnhub.py

```python
# Original extractor code preserved.
```

## src/load/bigquery_loader.py

```python
# Original loader code preserved.
```

## src/main.py

```python
# Original pipeline orchestration preserved.
```

---

# 🧪 Tests

## tests/test_validators.py

```python
# Original validator tests preserved.
```

## tests/test_extract.py

```python
# Original extractor tests preserved.
```

---

# ▶️ Execute the Pipeline

```bash
pytest
python -m src.main
```

---

# 🎯 Stage 1 Outcome

* 📥 Extract financial data
* ☁️ Load into BigQuery
* 🧪 Validate and test
* 📊 Prepare for dbt
* 📈 Enable executive dashboards

Foundation for streaming, orchestration, Docker, and CI/CD.
