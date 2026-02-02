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

/*
=====================================
| Create "Customer Dimension Table" |
=====================================
*/

--- Remove the table,if it already exists to avoid errors
DROP TABLE IF EXISTS dim_customer;

SELECT DISTINCT 
	CustomerID = [Customer ID],
	Country
INTO dim_customer
FROM fact_sales_raw;
GO

/*
====================================
| Create "Product Dimension Table" |
====================================
*/
SELECT DISTINCT
	StockCode,
	Description
INTO dim_product
FROM fact_sales_raw;
GO

/*
==================
| Create Indexes |
==================
*/

CREATE CLUSTERED INDEX idx_fact_customer
ON fact_sales (CustomerID);
GO

CREATE NONCLUSTERED INDEX idx_fact_date
ON fact_sales (InvoiceDate);
GO

CREATE NONCLUSTERED INDEX idx_fact_invoice
ON fact_sales (Invoice); -- error
GO

/*
===========================
| BUILD Customer 360 View |
===========================
*/
CREATE VIEW vw_customer_360
AS
SELECT 
	c.CustomerID,
	c.Country
FROM fact_sales f
JOIN dim_customer c
	ON f.CustomerID = c.CustomerID
GROUP BY 
	c.CustomerID,
	c.Country;
GO

/*
=============================
| ⏱️ Performance Validation |
=============================
*/
SET STATISTICS TIME ON;
SELECT * FROM vw_customer_360;
GO

SET STATISTICS TIME ON;
SELECT COUNT(*) FROM fact_sales;
GO

