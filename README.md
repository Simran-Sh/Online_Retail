## InfoTact Solutions Project

## Team - Data Analytics G2

---

## Project 1 (Month 1 Jan 2026): 
Building a Customer Intelligence Pipeline

---

## PROJECT OBJECTIVE
Built a fully automated, production-grade customer intelligence pipeline using SQL, Python, and Power BI, implementing RFM segmentation, cohort retention analysis, and market basket modeling to proactively identify churn risk customers and high-value whales

---

## Flow (end-to-end):

Raw Kaggle CSV <br>
   ↓  <br>
Data Cleaning & Modeling (Python)  <br>
   ↓  <br>
Star Schema in SQL (Fact + Dimensions)  <br>
   ↓  <br>
Single Customer View (SQL View)  <br>
   ↓  <br>
Advanced Analytics (Python: RFM, Cohorts, Market Basket)  <br>
   ↓  <br>
Power BI Dashboards (with RLS)  <br>
   ↓  <br>
Automation & Executive Output  <br>

---

## 🧰 Tools Stack (Industry-Standard)
| Layer         | Tool                            | Why                    |
| ------------- | ------------------------------- | ---------------------- |
| Storage       | SQL Server (SSMS 22)            | Scalable analytics DB  |
| ETL           | Python (pandas, SQLAlchemy)     | Robust transformations |
| Analytics     | Python (NumPy, mlxtend)         | RFM, Cohorts, Apriori  |
| Visualization | Power BI                        | Enterprise dashboards  |
| Automation    | Task Scheduler / Cron           | Hands-free pipeline    |

---

# WEEK 1 — Data Engineering & Schema Design

🎯 Goal
Convert raw transactional logs into a clean, trusted, analytics-ready data with an optimized star schema and create a Single Customer View that downstream analytics can trust and query in < 2 seconds.

---

## 1️⃣ Understand the Raw Data 

## Key issues we must handle:
❌ Negative Quantity → returns
❌ Negative Price → data errors
❌ Missing Customer ID i.e found "2,43,007"
❌ InvoiceDate as string
❌ Duplicate invoices

## 2️⃣ Data Cleaning (Python – pandas)
- **Handle Missing Customer IDs**
   Removed rows without Customer ID (cannot do RFM) and also Converted float → int for speed

- **Handle Returns & Invalid Data**
   Filtering out returns & corrupt rows for small table and faster aggregations

- **Create Revenue**
   Creating derived metric i.e Monetary (M in RFM), leads to faster SQL queries

- **Convert dates**
  Converts string → datetime for Recency calculation, Time-based indexing, Partitioning, otherwise SQL queries become slow and RFM Recency becomes impossible

---

## 3️⃣ Load Data into SQL (ETL → L)

# 🔧 Tools
- SQL 
- SQLAlchemy


# 🔌Python → SQL Connection
SQLAlchemy Creates DB connection and handles Transactions, Data typing, Bulk inserts faster than row-by-row inserts

**Points to Note:**
   - Even though SSMS works, Python does NOT automatically inherit SSMS drivers. Hence import pyodbc and call **pyodbc.drivers()**
   - SSMS bundles its own drivers and Python relies on system ODBC registry
   - SQLAlchemy wraps pyodbc and Root cause is always lower-level ODBC
   - This matters in production, since CI/CD servers often don’t have drivers

# Load Fact Table into SQL
Used Pandas "to_SQL" function to load cleaned data into SQL with "chunksize" method to prevent memory crashes and "replace" to ensure idempotency. 
Here for performance perpective, the Chunked inserts = stable loads

---

## 4️⃣ Star Schema Design

Followed a pragmatic **star-schema design** Country was modeled as a customer attribute because it had no independent hierarchies, and Date attributes were derived dynamically since the use case didn’t require a full calendar dimension.”

                Dim_Customer (CustomerID, Country)
                     |
Dim_Product —— Fact_Sales 
                     

# 📦 Fact Table: fact_sales
| Column       |
| ------------ |
| invoice_no   |
| invoice_date |
| customer_id  |
| stock_code   |
| quantity     |
| revenue      |

# 👤 Dim Customer
| Column      |
| ----------- |
| customer_id |
| country     |

# 🛒 Dim Product
| Column      |
| ----------- |
| stock_code  |
| description |

---

## 5️⃣ Indexing
Created Indexes (Clustered and Non Clustered) to speedup joins and filters and for RFM and Cohorts rely on date and customer
This indexing will specifically reduce the query time from seconds to milliseconds. Without indexes, Full table scans will take place

| Index       | Enables             |
| ----------- | ------------------- |
| CustomerID  | RFM, churn analysis |
| InvoiceDate | Cohorts, recency    |
| Invoice     | Frequency accuracy  |

---

## 6️⃣ Single Customer View (CRITICAL)
View creates a Logical abstraction with No data duplication

## 🔥 Customer 360 View
1️⃣ Single Source of Truth per Customer
   - One row per customer
   - Eliminates duplicate or conflicting customer metrics
   - Ensures all teams use the same definitions for frequency, spend, and activity

2️⃣ Foundation for RFM & Churn Analysis
   - Frequency → number of unique purchase events
   - Monetary → total revenue generated
   - LastPurchaseDate → anchor for recency calculation

👉 These raw metrics are stable, auditable, and reusable

3️⃣ Performance-Optimized for Analytics & Dashboards
   - Built on indexed fact tables
   - Lightweight aggregations in SQL
   - Fast enough for:
      - Python analytics
      - Power BI dashboards
      - Automated pipelines

---

# ✅ Week 1 Deliverables
✔ Cleaned raw transactional data
✔ Controlled ETL into SQL Server
✔ Star schema
✔ ER diagram
✔ Proper fact table with correct grain
✔ Proper dimension tables with enforced keys
✔ Performance-ready indexes
✔ Customer 360 View (single source of truth) ⭐

Week 1 TakeAway Points
- Debugged and resolved ODBC driver-level connection failures between Python and SQL Server Express by validating driver availability, aligning SQLAlchemy connection strings, and enforcing encrypted Windows authentication.”

| Operation | Speed         | Logged     | Keeps Structure|
| --------- | ------------- | ---------  | ---------------|
| DELETE    | ❌ Slow      | ✅ Yes     | ✅ Yes         |
| TRUNCATE  | ⚡ Very Fast | ❌ Minimal | ✅ Yes         |
| DROP      | ⚡ Instant   | ❌         | ❌ No          |

designed and implemented a production-ready star schema in SQL Server, enforced data integrity through constraints and window functions, and created a Customer 360 analytical view optimized for downstream RFM and churn analysis.

---

# WEEK 2 — Analytical Core (Python Intelligence - RFM & SEGMENTATION)

🎯 WEEK 2 BUSINESS GOAL
Build an RFM segmentation engine in Python on top of a SQL-based Customer 360 view, using quantile-based scoring and validating segment quality through revenue and recency distributions. Identify Whales (highest value customers) and Churn Risks in a repeatable, automated way, directly from SQL Server.

Input
✅ dbo.vw_customer_360 (trusted, clean)

Output
✅ Customer-level RFM table
✅ Segments: Champions, Loyalists, At Risk, Hibernating
✅ Validated with statistics (not vibes)

---

## STEP 1: CONNECT PYTHON TO SQL SERVER (READ-ONLY)

## STEP 2 — LOAD CUSTOMER 360 INTO PYTHON

## 1️⃣ RFM Calculation

🧠 Business Logic
| Metric    | Meaning                  |
| --------- | ------------------------ |
| Recency   | Days since last purchase |
| Frequency | Number of invoices       |
| Monetary  | Total revenue            |

## 2️⃣ RFM Scoring (1–5 Scale)

## 3️⃣ Customer Segmentation (Business Mapping)

## COHORT ANALYSIS
A cohort is a group of customers who made their first-ever purchase in the same time period (month or quarter).
We’ve used monthly cohorts (industry standard)

✔ Defined acquisition cohorts
✔ Calculated month-by-month retention
✔ Built cohort matrix (counts + %)
✔ Created 3 high-impact charts:
1️⃣ Retention Heatmap (most important)
2️⃣ Retention decay curve (trend over time)
3️⃣ Cohort Size Trend (context)
✔ Ready for Power BI cohort heatmap

I performed cohort-based retention analysis by grouping customers by first purchase month and tracking monthly activity decay, enabling long-term churn and LTV insights.

## 4️⃣ Market Basket Analysis (MBA)
MBA works at invoice (basket) level, not customer level.
**🎯 Basket grain**
1 row = 1 invoice
1 column = 1 product

---

For MARKET BASKET ANALYSIS, We need:
Invoice (basket)
Product (Description)
Quantity

So we join fact_sales → dim_product because in a star schema, descriptive attributes like product names live in dimension tables. The fact table stores only keys and metrics for performance

***basket_binary - applymap function***

| Aspect     | Old (`applymap`)     | New (vectorized)      |
| ---------- | -------------------- | --------------------- |
| Speed      | ❌ Slow (Python loop) | ⚡ Very fast (C-level) |
| Memory     | ❌ Inefficient        | ✅ Efficient           |
| Pandas 2.x | ❌ Removed            | ✅ Supported           |
| Production | ❌ Not ideal          | ✅ Best practice       |

"Implemented Market Basket Analysis using a vectorized binary invoice–product matrix, ensuring compatibility with pandas 2.x and improving performance over deprecated applymap usage"

## APRIORI
This is good for small datasets, but for us it did Multiple full scans of data and hence failed
Apriori has exponential memory complexity, so I constrained the item universe using frequency thresholds and limited itemset length, enabling scalable Market Basket Analysis.”

---


## ✅ Week 2 Deliverables
✔ Recency computed correctly
✔ Frequency & Monetary reused from SQL
✔ RFM scores (1–5)
✔ RFM engine
✔ Segments validated
✔ COHORT ANALYSIS
✔ Market basket rules
✔ Statistical proof (Champions highest LTV)

# WEEK 3 — Power BI Dashboard (Storytelling)
🔐 Row Level Security (RLS)

Goal is to build decision-ready dashboards that:
   - Explain customer behavior
   - Surface churn risks & whales
   - Allow regional managers to self-serve
   - Are fast, clean, and trustworthy

# WEEK 4 — Automation & Executive Handoff

## 1️⃣ Automate ETL

## 2️⃣ Presentation Deck

## 3️⃣ Full Pipeline Test

✔ Raw CSV → SQL
✔ SQL → Python
✔ Python → Power BI
✔ Auto refresh works