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
This indexing will specifically reduce the query time from seconds to milliseconds

| Index       | Enables             |
| ----------- | ------------------- |
| CustomerID  | RFM, churn analysis |
| InvoiceDate | Cohorts, recency    |
| Invoice     | Frequency accuracy  |

---

## 6️⃣ Single Customer View (CRITICAL)

View creates a Logical abstraction with No data duplication

🔥 Customer 360 View


Marketing, churn models, Power BI — everything consumes this
⏱️ Find and Display the RFM in a SQL View
⏱️ Performance Check - 🎯 Target: < 2 seconds

---

# ✅ Week 1 Deliverables
✔ Clean Fact and Dim Tables
✔ Star schema
✔ ER diagram
✔ Indexed SQL model
✔ Single Customer 360 View
✔ SQL optimized

Week 1 TakeAway Points
- Debugged and resolved ODBC driver-level connection failures between Python and SQL Server Express by validating driver availability, aligning SQLAlchemy connection strings, and enforcing encrypted Windows authentication.”

| Operation | Speed         | Logged     | Keeps Structure|
| --------- | ------------- | ---------  | ---------------|
| DELETE    | ❌ Slow      | ✅ Yes     | ✅ Yes         |
| TRUNCATE  | ⚡ Very Fast | ❌ Minimal | ✅ Yes         |
| DROP      | ⚡ Instant   | ❌         | ❌ No          |


---

# WEEK 2 — Analytical Core (Python Intelligence)

## 1️⃣ RFM Calculation

🧠 Business Logic
| Metric    | Meaning                  |
| --------- | ------------------------ |
| Recency   | Days since last purchase |
| Frequency | Number of invoices       |
| Monetary  | Total revenue            |

## 2️⃣ RFM Scoring (1–5 Scale)\

## 3️⃣ Customer Segmentation (Business Mapping)

## 4️⃣ Market Basket Analysis (Apriori)

## ✅ Week 2 Deliverables
✔ RFM engine
✔ Segments validated
✔ Market basket rules
✔ Statistical proof (Champions highest LTV)

# WEEK 3 — Power BI Dashboard (Storytelling)
🔐 Row Level Security (RLS)

# WEEK 4 — Automation & Executive Handoff

## 1️⃣ Automate ETL

## 2️⃣ Presentation Deck

## 3️⃣ Full Pipeline Test

✔ Raw CSV → SQL
✔ SQL → Python
✔ Python → Power BI
✔ Auto refresh works