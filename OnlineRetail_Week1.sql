/*
================================
| USE "DATATABSE" |
================================
*/

Use OnlineRetail;

/*
================================
| Create Optimized "Fact Table" |
================================
fact_sales grain is: 1 row = 1 product line on 1 invoice for 1 customer
One invoice → many rows, hence Frequency ≠ row count
*/
SELECT 
	Invoice,
	InvoiceDate,
	CustomerID =[Customer ID],
	StockCode,
	Quantity,
	Revenue
INTO fact_sales
FROM fact_sales_raw;
GO

SELECT
    Invoice,
    COUNT(*) AS duplicate_count
FROM fact_sales
GROUP BY
    Invoice
HAVING COUNT(*) > 1;

/*
=====================================
| Create "Customer Dimension Table" |
=====================================
Cust_Grain 1 row = 1 customer
*/

--- Remove the table,if it already exists to avoid errors
DROP TABLE IF EXISTS dim_customer;

--- Create structure 
CREATE TABLE dbo.dim_customer (
    CustomerID INT NOT NULL,
    Country    VARCHAR(50) NOT NULL,
    CONSTRAINT PK_dim_customer PRIMARY KEY (CustomerID)
);
GO

--- Insert data
INSERT INTO dim_customer (CustomerID, Country)
SELECT
    CustomerID,
    Country
FROM (
    SELECT
        CAST([Customer ID] AS INT) AS CustomerID,
        Country,
        ROW_NUMBER() OVER (
            PARTITION BY CAST([Customer ID] AS INT) -- Groups rows by customer
            ORDER BY InvoiceDate DESC 
        ) AS rn
    FROM dbo.fact_sales_raw
) t
WHERE rn = 1; 
---One row per customer Guaranteed no duplicates where same custID has diffent country
GO

/*
====================================
| Create "Product Dimension Table" |
====================================
Prod_Grain 1 row = 1 product
*/
DROP TABLE IF EXISTS dim_customer;GO

CREATE dim_product
    StockCode varchar(50) Primary Key,
    Description varchar(100)
FROM fact_sales_raw;
GO

SELECT 
    DISTINCT StockCode,
	Description
INTO dim_product
FROM fact_sales_raw;
GO

/*
============================================
| ⏱️ Validation Checks: COUNT SANITY CHECK|
===========================================
*/

---Row count consistency - HENCE must match
SELECT 
	COUNT(*) AS SALES_ROWS
FROM fact_sales;
GO

SELECT 
	COUNT(*) SALES_ROWS_RAW
FROM fact_sales_raw;
GO

--- Customer count sanity
SELECT 
	COUNT(DISTINCT CustomerID) 
FROM fact_sales; -- from fact table
GO

SELECT 
	COUNT(*) 
FROM dim_customer; -- from dimension table
GO


--- Product count sanity

SELECT 
	COUNT(DISTINCT StockCode) as factTableProductCount
FROM fact_sales; -- from fact table
GO

SELECT 
	COUNT(DISTINCT StockCode) AS DimTableProductCount, ---4,631 StockCodes
    COUNT(*) as DimTableRowsCount, --- 5,312 Total Rows
    COUNT(DISTINCT Description) as DimTableDescpCount ---5,267 Descriptions
FROM dim_product; -- from dimension table. Gives inconsistent code and hence sanity check failed 
GO

