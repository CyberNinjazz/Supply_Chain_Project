# Supply Chain Data Engineering Project

An end-to-end supply chain data engineering project using Python, PostgreSQL, SQL, and Power BI.

## Project Overview

This project demonstrates a data engineering workflow that transforms synthetic supply chain datasets into structured, validated data for business reporting and analysis.

The project covers data exploration, cleaning, relational database development, SQL analysis, and dashboard visualization.

## Technologies Used

- **Python / Pandas** — Data exploration and preparation
- **PostgreSQL** — Relational database and data storage
- **SQL** — Staging, validation, data loading, and reporting views
- **Power BI** — Interactive supply chain dashboard
- **Git / GitHub** — Version control and project documentation

## Data Pipeline

Raw CSV files → Python processing → Cleaned CSV files → PostgreSQL staging tables → Final relational tables → SQL reporting views → Power BI dashboard

The project begins with four raw datasets and produces five cleaned datasets, including order-item data.

## Dataset Overview

| Table | Records |
|---|---:|
| Customers | 30 |
| Products | 8 |
| Orders | 149 |
| Order Items | 148 |
| Shipments | 110 |

## Dashboard Results

The completed Power BI dashboard includes:

- **Total Orders:** 149
- **Recorded Order Value:** $37,645
- **On-Time Delivery Rate:** 55.96%
- **Pending Orders:** 26

These metrics provide visibility into order activity, shipment performance, and supply chain operations.

## Repository Structure

```text
Supply_Chain_Project/
├── data/
│   ├── raw/
│   └── cleaned/
├── scripts/
│   └── explore_data.py
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_staging_tables.sql
│   ├── 03_validate_staging.sql
│   ├── 04_load_final_tables.sql
│   ├── 05_supply_chain_analysis.sql
│   └── 06_reporting_views.sql
├── powerbi/
│   └── [Dashboard and supporting documentation]
├── .gitignore
└── README.md
```

## Project Highlights

- Explored and prepared synthetic supply chain datasets using Python.
- Developed PostgreSQL staging and final database tables.
- Validated data before loading it into the final relational model.
- Created SQL queries and reporting views for supply chain analysis.
- Built a Power BI dashboard to communicate operational KPIs.

## Data Source

Synthetic supply chain data used for educational and portfolio development.
