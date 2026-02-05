# InfoTact Solutions Project  
## Team — Data Analytics G2

---

## 📌 Project 1 (Jan 2026)
### Building a Customer Intelligence Pipeline

---

## 🎯 Project Objective
Build a fully automated, production-grade customer intelligence pipeline using **SQL, Python, and Power BI**, implementing:

- RFM segmentation  
- Cohort retention analysis  
- Market basket modeling
      - using  Association Rule Mining (Apriori/FP-Growth algorithms)

The system to proactively identify **churn-risk customers** and **high-value whales**, enabling faster and more informed business decisions.

---

## 🔄 End-to-End Pipeline Architecture

```
Raw CSV (Kaggle)
      ↓
Python ETL (Cleaning + Feature Engineering)
      ↓
SQL Server (Fact + Dimensions + Views)
      ↓
Python Analytics (RFM Engine)
      ↓
Analytical Tables (customer_360, cohort_table, mba_rules)
      ↓
Power BI Dashboards
```

---

## 🧰 Industry-Standard Tech Stack

| Layer | Tool | Purpose |
|--------|--------|------------|
| Storage | SQL Server (SSMS 22) | Scalable analytics warehouse |
| ETL | Python (pandas, SQLAlchemy) | Robust transformations |
| Analytics | Python (NumPy, mlxtend) | RFM modeling |
| Visualization | Power BI | Executive dashboards |
| Automation | Task Scheduler / Cron | Hands-free pipeline |

---

# 🚀 WEEK 1 — Data Engineering & Schema Design

## 🎯 Goal
Convert raw transactional logs into **clean, trusted, analytics-ready data** using an optimized star schema and create a **Single Customer View** capable of supporting sub-2-second analytical queries.

---

## 🔍 Understanding the Raw Data

### Key Issues Identified
- Negative Quantity → Returns  
- Negative Price → Data errors  
- Missing Customer IDs (~243K rows)  
- InvoiceDate stored as string  
- Duplicate invoices  

---

## 🧹 Data Cleaning (Python – pandas)

### ✔ Handle Missing Customer IDs
- Removed rows without Customer ID (required for RFM)  
- Converted float → int for performance  

### ✔ Handle Returns & Invalid Data
Filtered corrupt rows to enable faster aggregations.

### ✔ Create Revenue
Derived **Monetary (M in RFM)** to accelerate downstream SQL queries.

### ✔ Convert Dates
String → datetime conversion enables:

- Recency calculation  
- Time-based indexing  
- Partitioning  
- Faster SQL queries  

---

## 🔌 Load Data into SQL (ETL → Load)

### Tools Used
- SQL Server  
- SQLAlchemy  

SQLAlchemy manages connections, transactions, data typing, and bulk inserts.

**Production Insight:**  
Python does NOT inherit SSMS drivers automatically — validating ODBC drivers is critical for CI/CD environments.

---

### 📦 Fact Table Loading
Used Pandas `to_sql()` with:

- `chunksize` → Prevent memory crashes  
- `replace` → Ensure idempotency  

Chunked inserts resulted in stable and scalable loads.

---

## ⭐ Star Schema Design

Adopted a pragmatic star schema:

- Country modeled as a customer attribute  
- Date derived dynamically (no full calendar dimension required)

```
Dim_Customer ──┐
               ├── Fact_Sales
Dim_Product ───┘
```

---

### 📊 Fact Table — `fact_sales`

| Column |
|------------|
| invoice_no |
| invoice_date |
| customer_id |
| stock_code |
| quantity |
| revenue |

---

### 👤 Dim Customer

| Column |
|-----------|
| customer_id |
| country |

---

### 🛒 Dim Product

| Column |
|-------------|
| stock_code |
| description |

---

## ⚡ Indexing Strategy

Indexes reduce query time from **seconds → milliseconds.**

| Index | Enables |
|-----------|-------------|
| CustomerID | RFM, churn analysis |
| InvoiceDate | Recency calculations |
| Invoice | Frequency accuracy |

Without indexes → full table scans.

---

## 🔥 Single Customer View (Customer 360)

### Why It Matters

✅ **Single Source of Truth**
- One row per customer  
- Eliminates metric inconsistencies  

✅ **Foundation for RFM**
- Frequency → purchase events  
- Monetary → total revenue  
- LastPurchaseDate → recency anchor  

## 🧠 RFM Calculation

| Metric     | Meaning                  |
|------------|--------------------------|
| Recency    | Days since last purchase |
| Frequency  | Number of invoices       |
| Monetary   | Total revenue            |


✅ **Optimized for Analytics**
- Built on indexed fact tables  
- Lightweight SQL aggregations  
- Supports Python + Power BI pipelines  

---

## ✅ Week 1 Deliverables

- Cleaned transactional dataset  
- Controlled ETL into SQL Server  
- Star schema + ER diagram  
- fact & dimension tables
- Sanity check for all tables
- Issues fixed for failed integrity in data
- Performance-ready indexes  
- Customer 360 View with RFM ⭐  

**Engineering Takeaway:**  
Resolved ODBC driver-level failures between Python and SQL Server by validating drivers, aligning SQLAlchemy connection strings, and enforcing encrypted authentication.

---

# 🚀 WEEK 2 — Analytical Core (RFM & Segmentation)

## 🎯 Business Goal
Build an automated **RFM segmentation engine** on top of the SQL-based Customer 360 view to identify:

- High-value customers (Whales)  
- Churn risks  
- Loyal segments  

**Input:** `dbo.vw_customer_360`  
**Output:** Customer-level RFM table with validated segments.

---

## 📊 Customer Segmentation
Segments include:

- Champions  
- Loyalists  
- At Risk  
- Hibernating  

Validated using revenue and recency distributions — not assumptions.

Implemented Market Basket Analysis by computing support, confidence, and lift metrics directly from a binary invoice–product matrix, equivalent to Apriori-based association rule mining.
---

## ✅ Week 2 Deliverables
- Accurate Recency  
- Reused Frequency & Monetary from SQL  
- RFM scoring (1–5)  
- Validated segments  
- Statistical proof (Champions = highest LTV)

---

# 📊 WEEK 3 — Advanced Customer Insights & Visualization

## 📈 Cohort Analysis
Customers were grouped by first purchase month to measure retention decay and long-term value.

- Defined **CohortMonth** as first purchase month
- Calculated **CohortIndex** (months since acquisition)
- Computed **RetentionRate**
- Built cohort retention table for visualization

Ready for Power BI integration.

---

## 🛒 Market Basket Analysis

Performed at **invoice (basket) level**, joining:

`fact_sales → dim_product`

because descriptive attributes belong in dimension tables.

### Vectorized Optimization

| Aspect | applymap (Old) | Vectorized (New) |
|------------|----------------|------------------|
| Speed | ❌ Slow | ⚡ Fast |
| Memory | ❌ Inefficient | ✅ Efficient |
| Pandas 2.x | ❌ Removed | ✅ Supported |
| Production | ❌ Not ideal | ✅ Best Practice |

---

## Apriori Optimization
## Generated association rules:
  - Support
  - Confidence
  - Lift
- Persisted results as `mba_rules` table

### Challenges & Solutions
- **MemoryError in Apriori**
  → Reduced product space + limited itemset length  
- **Duplicate product descriptions**
  → Interpreted high-lift rules as data quality insight

---

## Power BI Dashboard & Storytelling
- Translate analytics into **business insights**
- Build **executive-ready dashboards**
- 🔐 Row-Level Security (RLS)

**Dashboards designed to:**
- Explain customer behavior  
- Surface churn risks & whales  
- Enable regional self-service  
- Deliver fast, trustworthy insights  

---

## 📊 Dashboards to Build
#### 1️⃣ Executive Overview
- KPIs: Revenue, Orders, Customers, AOV
- Revenue trends over time
- Geographic revenue contribution

#### 2️⃣ Customer 360 / Churn View
- RFM segment distribution
- High-value customers (Whales)
- Churn-risk customer list

#### 3️⃣ Cohort Retention Analysis
- Heatmap matrix:
  - Rows: CohortMonth
  - Columns: CohortIndex
  - Values: RetentionRate
- KPI cards for early churn detection

#### 4️⃣ Market Basket Insights
- Product-to-product association table
- Lift & confidence filters
- Cross-sell recommendation slicers

---

## ✅ Week 3 Deliverables
- Cohort retention analysis  
- Market basket rules  
- Insight-ready analytical tables  
- Executive dashboards  

---

# ⚙️ WEEK 4 — Automation & Executive Handoff

### Automation
- Consolidated Python logic into `rfm_pipeline.py`
- **Implemented:**
  - Modular ETL functions
  - Logging & error handling
- Scheduled execution using **Windows Task Scheduler**
- Power BI refresh aligned with ETL completion 

Pipeline validation:

- Raw CSV → SQL  
- SQL → Python  
- Python → Power BI  
- Auto refresh enabled  

---

# PROJECT DELIVERABLES
- SQL Star Schema & Views
- Python analytics pipeline
- Automated ETL execution
- Power BI dashboards
- Executive-ready insights
- Full project documentation

---

## 🎯 Business Impact

- Enables **targeted retention strategies**
- Identifies **high-value customers**
- Improves **cross-sell and bundling decisions**
- Highlights **acquisition quality via cohorts**
- Reduces manual reporting effort - if the CSV can be some real data

---

## 🧠 Key Learnings

- Importance of dimensional modeling
- Handling real-world data quality issues
- Scaling analytical algorithms
- Bridging analytics with business storytelling
- Building production-ready data pipelines

---

## 👤 Author

Simran | Kartik | Dhritideep  - TeamWork
Data Analytics | SQL | Python | Power BI |
End-to-End Analytics & Business Intelligence
