import pandas as pd
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

csv_file = [f for f in os.listdir(BASE_DIR) if f.lower().endswith(".csv")][0]
df = pd.read_csv(os.path.join(BASE_DIR, csv_file))

print("Dataset loaded successfully")
print("Shape:", df.shape)

print("\n--- DATA INFO ---")
print(df.info())

print("\n--- FIRST 5 ROWS ---")
print(df.head())

print("\n--- MISSING VALUES ---")
print(df.isna().sum())

print("\n--- NUMERICAL SUMMARY ---")
print(df.describe())

print("\n--- TOP COUNTRIES ---")
print(df["Country"].value_counts().head(10))

print("\n--- TOP PRODUCTS (StockCode) ---")
print(df["StockCode"].value_counts().head(10))


df["Revenue"] = df["Quantity"] * df["UnitPrice"]

print("\n--- REVENUE COLUMN ADDED ---")
print(df[["Quantity", "UnitPrice", "Revenue"]].head())

print("\n--- REVENUE SUMMARY ---")
print(df["Revenue"].describe())

top_products_revenue = (
    df.groupby("StockCode")["Revenue"]
      .sum()
      .sort_values(ascending=False)
      .head(10)
)

print("\n--- TOP 10 PRODUCTS BY REVENUE ---")
print(top_products_revenue)

top_customers_revenue = (
    df.groupby("CustomerID")["Revenue"]
      .sum()
      .sort_values(ascending=False)
      .head(10)
)

print("\n--- TOP 10 CUSTOMERS BY REVENUE ---")
print(top_customers_revenue)

df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

print("\n--- INVOICE DATE CONVERTED ---")
print(df["InvoiceDate"].dtype)

df["YearMonth"] = df["InvoiceDate"].dt.to_period("M")

print("\n--- YEAR-MONTH COLUMN CREATED ---")
print(df[["InvoiceDate", "YearMonth"]].head())

monthly_revenue = (
    df.groupby("YearMonth")["Revenue"]
      .sum()
      .sort_index()
)

print("\n--- MONTHLY REVENUE TREND ---")
print(monthly_revenue)

monthly_orders = (
    df.groupby("YearMonth")["InvoiceNo"]
      .nunique()
      .sort_index()
)

print("\n--- MONTHLY NUMBER OF ORDERS ---")
print(monthly_orders)

negative_revenue_count = (df["Revenue"] < 0).sum()

print("\n--- NEGATIVE REVENUE COUNT ---")
print(negative_revenue_count)

df_positive = df[df["Revenue"] > 0].copy()

print("\n--- CLEAN DATASET (REVENUE > 0) ---")
print("Shape:", df_positive.shape)

monthly_revenue_clean = (
    df_positive.groupby("YearMonth")["Revenue"]
               .sum()
               .sort_index()
)

print("\n--- MONTHLY REVENUE (CLEAN DATA) ---")
print(monthly_revenue_clean)

top_products_revenue_clean = (
    df_positive.groupby("StockCode")["Revenue"]
               .sum()
               .sort_values(ascending=False)
               .head(10)
)

print("\n--- TOP 10 PRODUCTS BY REVENUE (CLEAN DATA) ---")
print(top_products_revenue_clean)

import matplotlib.pyplot as plt

plt.figure(figsize=(10, 5))
monthly_revenue_clean.plot()
plt.title("Monthly Revenue Trend")
plt.xlabel("Year-Month")
plt.ylabel("Revenue")
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 5))
top_products_revenue_clean.plot(kind="bar")
plt.title("Top 10 Products by Revenue")
plt.xlabel("StockCode")
plt.ylabel("Revenue")
plt.tight_layout()
plt.show()

top_customers_revenue_clean = (
    df_positive.groupby("CustomerID")["Revenue"]
               .sum()
               .sort_values(ascending=False)
               .head(10)
)

plt.figure(figsize=(10, 5))
top_customers_revenue_clean.plot(kind="bar")
plt.title("Top 10 Customers by Revenue")
plt.xlabel("CustomerID")
plt.ylabel("Revenue")
plt.tight_layout()
plt.show()

