## InfoTact Solutions Project

## Team - Data Analytics G2

<<<<<<< HEAD
---

## Project 1 (Month 1 Jan 2026): 
Building a Customer Intelligence Pipeline

---

## PROJECT OBJECTIVE
Built a fully automated, production-grade customer intelligence pipeline using SQL, Python, and Power BI, implementing RFM segmentation, cohort retention analysis, and market basket modeling to proactively identify churn risk customers and high-value whales

=======
## Project 1 (Month 1 Jan 2026): Building a Customer Intelligence Pipeline

PROJECT OBJECTIVE
Built a fully automated, production-grade customer intelligence pipeline using SQL, Python, and Power BI, implementing RFM segmentation, cohort retention analysis, and market basket modeling to proactively identify churn risk customers and high-value whales.
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6
---

## Flow (end-to-end):

<<<<<<< HEAD
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
=======
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
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6

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

## 1️⃣ Understand the Raw Data 
# Key issues we must handle:
❌ Negative Quantity → returns
❌ Negative Price → data errors
❌ Missing Customer ID
❌ InvoiceDate as string
❌ Duplicate invoices

## 2️⃣ Data Cleaning (Python – pandas)
Remove rows without Customer ID (cannot do RFM)
Separate sales vs returns
Create Revenue
Convert dates

## 3️⃣ Star Schema Design

                Dim_Customer
                     |
Dim_Product —— Fact_Sales —— Dim_Date
                     |
                Dim_Country

<<<<<<< HEAD

=======
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6
📦 Fact Table: fact_sales
| Column       |
| ------------ |
| invoice_no   |
| invoice_date |
| customer_id  |
| stock_code   |
| quantity     |
| revenue      |

👤 Dim Customer
| Column      |
| ----------- |
| customer_id |
| country     |

🛒 Dim Product
| Column      |
| ----------- |
| stock_code  |
| description |

## 4️⃣ Load Data into SQL (ETL → L)

# 🔧 Tools
- SQL
- SQLAlchemy


# 🔌Python → SQL Connection

## 5️⃣ SQL Schema Creation

## 6️⃣ Single Customer View (CRITICAL)
Marketing, churn models, Power BI — everything consumes this
⏱️ Find and Display the RFM in a SQL View
⏱️ Performance Check - 🎯 Target: < 2 seconds

<<<<<<< HEAD
---

=======
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6
# ✅ Week 1 Deliverables
✔ Clean dataset
✔ Star schema
✔ ER diagram
✔ Single Customer View
✔ SQL optimized

<<<<<<< HEAD
---

=======
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6
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

<<<<<<< HEAD
## ✅ Week 2 Deliverables
=======
# ✅ Week 2 Deliverables
>>>>>>> 4ab53ba73f1053d7a66efc8f7b5046280a6ccfa6
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