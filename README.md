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

The system proactively identifies **churn-risk customers** and **high-value whales**, enabling faster and more informed business decisions.

---

## 🔄 End-to-End Pipeline Flow

```
Raw Kaggle CSV
    ↓
Data Cleaning & Modeling (Python)
    ↓
Star Schema in SQL (Fact + Dimensions)
    ↓
Single Customer View (SQL View)
    ↓
Advanced Analytics (Python: RFM, Cohorts, Market Basket)
    ↓
Power BI Dashboards (with RLS)
    ↓
Automation & Executive Output
```

---

## 🧰 Industry-Standard Tech Stack

| Layer | Tool | Purpose |
|--------|--------|------------|
| Storage | SQL Server (SSMS 22) | Scalable analytics database |
| ETL | Python (pandas, SQLAlchemy) | Robust data transformations |
| Analytics | Python (NumPy, mlxtend) | RFM, Cohorts, Apriori |
| Visualization | Power BI | Enterprise dashboards |
| Automation | Task Scheduler / Cron | Hands-free pipeline |

---

# 🚀 WEEK 1 — Data Engineering & Schema Design

## 🎯 Goal
Convert raw transactional logs into **clean, trusted, analytics-ready data** using an optimized star schema and build a **Single Customer View** capable of supporting sub-2-second queries.

---

## 🔍 Understanding the Raw Data

### Key Issues Identified
- Negative Quantity → Returns  
- Negative Price → Data errors  
- Missing Customer IDs (~243,007 rows)  
- InvoiceDate stored as string  
- Duplicate invoices  

---

## 🧹 Data Cleaning (Python – pandas)

### ✔ Handle Missing Customer IDs
- Removed rows without Customer ID (required for RFM)
- Converted float → int for performance

### ✔ Handle Returns & Invalid Data
- Filtered corrupt rows to enable faster aggregations

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

SQLAlchemy manages:

- DB connections  
- Transactions  
- Data typing  
- Bulk inserts  

**Production Insight:**  
Python does NOT inherit SSMS drivers automatically — validating ODBC drivers is critical for CI/CD environments.

---

### 📦 Fact Table Loading
Used Pandas `to_sql()` with:

- `chunksize` → Prevent memory crashes  
- `replace` → Ensure idempotency  

Chunked inserts resulted in **stable and scalable loads.**

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
| InvoiceDate | Cohorts, recency |
| Invoice | Frequency accuracy |

Without indexes → full table scans.

---

## 🔥 Single Customer View (Customer 360)

### Why It Matters

✅ **Single Source of Truth**
- One row per customer  
- Eliminates metric inconsistencies  

✅ **Foundation for RFM & Churn**
- Frequency → purchase events  
- Monetary → total revenue  
- LastPurchaseDate → recency anchor  

✅ **Optimized for Analytics**
- Built on indexed fact tables  
- Lightweight SQL aggregations  
- Supports Python + Power BI pipelines  

---

## ✅ Week 1 Deliverables

- Cleaned transactional dataset  
- Controlled ETL into SQL Server  
- Star schema + ER diagram  
- Proper fact & dimension tables  
- Performance-ready indexes  
- Customer 360 View ⭐  

### Key Engineering Takeaway
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

## 🧠 RFM Calculation

| Metric | Meaning |
|------------|-------------------------|
| Recency | Days since last purchase |
| Frequency | Number of invoices |
| Monetary | Total revenue |

---

## 📊 Customer Segmentation
Segments include:

- Champions  
- Loyalists  
- At Risk  
- Hibernating  

Validated using revenue and recency distributions — **not assumptions.**

---

## 📈 Cohort Analysis
Monthly cohorts were used to track retention decay and long-term customer value.

✔ Defined acquisition cohorts  
✔ Built retention matrix  
✔ Generated high-impact visuals:
- Retention Heatmap  
- Retention Decay Curve  
- Cohort Size Trend  

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
Apriori’s exponential memory usage was controlled by:

- Frequency thresholds  
- Itemset limits  

Enabling scalable MBA.

---

## ✅ Week 2 Deliverables
- Accurate Recency  
- Reused Frequency & Monetary from SQL  
- RFM scoring (1–5)  
- Validated segments  
- Cohort analysis  
- Market basket rules  
- Statistical proof (Champions = highest LTV)

---

# 📊 WEEK 3 — Power BI Storytelling

🔐 Row-Level Security (RLS)

Dashboards designed to:

- Explain customer behavior  
- Surface churn risks & whales  
- Enable regional self-service  
- Deliver fast, trustworthy insights  

---

# ⚙️ WEEK 4 — Automation & Executive Handoff

### ✔ Automate ETL  
### ✔ Build Presentation Deck  
### ✔ Execute Full Pipeline Test  

Pipeline validation:

- Raw CSV → SQL  
- SQL → Python  
- Python → Power BI  
- Auto refresh enabled  

---
