# 📊 Retail Customer Analytics Platform  
**End-to-End ETL, RFM Segmentation, Cohort Analysis & Market Basket Analysis**

---

## 📌 Project Objective

A national retail chain faced **customer churn and limited visibility into customer value**.  
The goal of this project was to build a **scalable, automated analytics system** to:

- Identify **high-value customers (Whales)**
- Detect **churn-risk customers**
- Track **retention behavior over time**
- Discover **product bundling opportunities**

The project demonstrates mastery over the **full data lifecycle**:
**Extraction → Transformation → Loading → Analytics → Visualization → Automation**

---

## 🏗️ System Architecture Overview
Raw Retail Transactions (CSV)
↓
Python ETL & Feature Engineering
↓
SQL Server (Star Schema + Analytics Tables)
↓
Python Analytics
• RFM Segmentation
• Cohort Retention
• Market Basket Analysis
↓
SQL Persisted Outputs
↓
Power BI Dashboards


---

## 🛠️ Tools & Technologies

- **Python** (pandas, numpy, sqlalchemy, mlxtend)
- **SQL Server (SSMS)** – Data modeling & persistence
- **Power BI** – Visualization & storytelling
- **Windows Task Scheduler** – Automation
- **GitHub** – Version control & documentation

---

## 📁 Data Source

- Online Retail transactional dataset (Kaggle)
- ~1M transaction records
- Columns include:
  - Invoice, StockCode, Description
  - Quantity, Price
  - CustomerID, Country, InvoiceDate

---

# 📅 WEEK-WISE IMPLEMENTATION

---

## 🟢 Week 1 — Data Engineering & Schema Design

### Objectives
- Clean raw transaction data
- Build a scalable **Star Schema**
- Create a **Single Customer View**

### Key Steps
- Removed invalid records:
  - NULL Customer IDs
  - Negative quantities (returns)
- Created SQL tables:
  - `fact_sales`
  - `dim_customer`
  - `dim_product`
- Built `customer_360_view` using SQL joins
- Validated schema with ER-style relationships
- Performed sanity checks:
  - Row counts
  - Duplicate customers
  - Revenue reconciliation

### Challenges & Solutions
- **Duplicate customers across rows**
  → Used `ROW_NUMBER()` to retain latest customer attributes  
- **Performance concerns**
  → Indexed key analytical columns


=========================

---

## 🛠️ Tech Stack

- **Python**: pandas, numpy, sqlalchemy, mlxtend
- **SQL Server (SSMS)**: Fact & Dimension modeling
- **Power BI**: Interactive dashboards
- **Windows Task Scheduler**: Automation
- **GitHub**: Documentation & versioning

---

## 📁 Dataset Summary

- Source: Online Retail dataset (Kaggle)
- Size: ~1,067,000 raw records
- Key columns:
  - `Invoice`, `StockCode`, `Description`
  - `Quantity`, `Price`
  - `CustomerID`, `Country`, `InvoiceDate`

---

# 📅 WEEK 1 — DATA ENGINEERING & MODELING

## 🎯 Goal
Create a **clean, analytics-ready data model** using SQL Server.

---

## 🔹 Step 1: Raw Data Cleaning (Python)

Actions performed:
- Removed records with `CustomerID IS NULL`
- Removed negative quantities (returns)
- Created `Revenue = Quantity × Price`

**Result**
- Raw rows: ~1,067,000
- Cleaned rows: ~805,000

This ensured **accurate revenue and customer metrics**.

---

## 🔹 Step 2: Load Clean Data into SQL

Loaded cleaned dataset into:
```sql
dbo.fact_sales_raw

---

## 🔹 Step 3: Star Schema Design
Fact Table
fact_sales
- Invoice
- InvoiceDate
- CustomerID
- ProductID
- Quantity
- Revenue

Dimension Tables
dim_customer (CustomerID, Country)
dim_product  (ProductID, Description)

Star Schema for 
Faster aggregations
Clean separation of facts vs attributes
Power BI friendly

---

## 🟢 Week 2 — Analytical Core (Python)

### Objectives
- Segment customers using **RFM**
- Perform **Cohort Retention Analysis**
- Discover **product affinities** using MBA

---

### 🔹 RFM Segmentation
- Calculated:
  - **Recency**: Days since last purchase
  - **Frequency**: Number of invoices
  - **Monetary**: Total revenue
- Assigned RFM scores (1–5)
- Created customer segments:
  - Champions
  - Loyalists
   - Potential Loyalists
  - At Risk
  - Hibernating

Validation
Champions showed highest average revenue and frequency
At-risk customers had low recency and declining spend

---

### 🔹 Cohort Analysis
- Defined **CohortMonth** as first purchase month
- Calculated **CohortIndex** (months since acquisition)
- Counted active customers per cohort
- Computed **RetentionRate**
- Built cohort retention table for visualization

---

### 🔹 Market Basket Analysis(MBA)
- Built Invoice × Product binary matrix
- Applied **Apriori** with:
  - Frequency filtering
  - Memory optimization
  - Itemset length constraints
- Generated association rules:
  - Support
  - Confidence
  - Lift
- Persisted results as `mba_rules` table

---
***Key Insight***
    - High-lift rules often revealed duplicate or synonym product descriptions, highlighting upstream data quality issues.

--- 

### Challenges & Solutions
- **MemoryError in Apriori**
  → Reduced product space + limited itemset length  
- **Duplicate product descriptions**
  → Interpreted high-lift rules as data quality insight
- Added clustered index on lift for performance.

---

## 🟢 Week 3 — Power BI Dashboard & Storytelling

### Objectives
- Translate analytics into **business insights**
- Build **executive-ready dashboards**

---

### Dashboards Created

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

### Design Principles
- Minimal visuals, maximum insight
- Business-oriented titles
- Clear filtering and interaction
- Standalone analytical tables (no forced joins)

---

## 🟢 Week 4 — Automation & Handoff

### Objectives
- Make the solution **fully automated**
- Prepare **handoff documentation**

---

### Automation
- Consolidated Python logic into `rfm_pipeline.py`
- Implemented:
  - Modular ETL functions
  - Logging & error handling
- Scheduled execution using **Windows Task Scheduler**
- Power BI refresh aligned with ETL completion

---

### Production Outputs
- `customer_360_view`
- `cohort_table`
- `mba_rules`

All persisted in SQL Server for BI consumption.

---

## 📦 Deliverables

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
- Reduces manual reporting effort

---

## 🧠 Key Learnings

- Importance of dimensional modeling
- Handling real-world data quality issues
- Scaling analytical algorithms
- Bridging analytics with business storytelling
- Building production-ready data pipelines

---

## 🚀 Future Enhancements

- Replace Apriori with FP-Growth for scalability
- Add customer lifetime value (CLV) modeling
- Integrate email campaign response data
- Deploy pipeline using Airflow or Azure Data Factory

---

## 👤 Author

**Simran Sharma**  
Data Analytics | SQL | Python | Power BI  
End-to-End Analytics & Business Intelligence

