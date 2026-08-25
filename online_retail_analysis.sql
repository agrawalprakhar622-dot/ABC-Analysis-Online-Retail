-- ============================================================
-- ABC ANALYSIS - ONLINE RETAIL
-- SQL DATA CLEANING, ANALYSIS & CLASSIFICATION
-- ============================================================

create database abc_analysis;

use abc_analysis;

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT
    'ready' AS status;
    
CREATE TABLE online_retail_raw (
    Invoice VARCHAR(50),
    StockCode VARCHAR(50),
    Description TEXT,
    Quantity VARCHAR(50),
    InvoiceDate VARCHAR(50),
    Price VARCHAR(50),
    Customer_ID VARCHAR(50),
    Country VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail_II.csv'
INTO TABLE online_retail_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DESCRIBE online_retail_raw;

-- ============================================================
-- 1. DATA CLEANING
-- ============================================================

CREATE TABLE retail_clean AS
SELECT
    Invoice,
    StockCode,
    TRIM(Description) AS Description,
    CAST(Quantity AS SIGNED) AS Quantity,
    STR_TO_DATE(InvoiceDate, '%Y-%m-%d %H:%i:%s') AS InvoiceDate,
    CAST(Price AS DECIMAL(10,3)) AS Price,
    Customer_ID,
    Country
FROM online_retail_raw
WHERE CAST(Quantity AS SIGNED) > 0
  AND CAST(Price AS DECIMAL(10,3)) > 0;
  
SELECT COUNT(*) AS clean_rows
FROM retail_clean;

SELECT
    SUM(Quantity <= 0) AS invalid_quantity,
    SUM(Price <= 0) AS invalid_price,
    SUM(InvoiceDate IS NULL) AS invalid_dates,
    SUM(StockCode IS NULL) AS missing_stockcode
FROM retail_clean;

DESCRIBE retail_clean;

SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country,
    COUNT(*) AS duplicate_count
FROM retail_clean
GROUP BY
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 20;

SELECT
    COUNT(*) AS duplicate_groups,
    SUM(duplicate_count) AS rows_in_duplicate_groups,
    SUM(duplicate_count - 1) AS rows_to_remove
FROM (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country,
        COUNT(*) AS duplicate_count
    FROM retail_clean
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country
    HAVING COUNT(*) > 1
) AS duplicates;

-- ============================================================
-- 2. DUPLICATE REMOVAL
-- ============================================================

CREATE TABLE retail_final AS
SELECT DISTINCT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country
FROM retail_clean;

SELECT
    COUNT(*) AS duplicate_groups
FROM (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country,
        COUNT(*) AS duplicate_count
    FROM retail_final
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    (SELECT COUNT(*) FROM retail_clean) AS clean_rows,
    (SELECT COUNT(*) FROM retail_final) AS final_rows;

-- ============================================================
-- 3. PRODUCT-LEVEL SALES ANALYSIS
-- ============================================================ 

CREATE TABLE product_sales AS
SELECT
    StockCode,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Quantity * Price), 4) AS Total_Revenue,

    ROUND(
        SUM(Quantity * Price)
        / SUM(SUM(Quantity * Price)) OVER () * 100,
        4
    ) AS Revenue_Percentage,

    ROUND(
        SUM(SUM(Quantity * Price)) OVER (
            ORDER BY SUM(Quantity * Price) DESC
        )
        / SUM(SUM(Quantity * Price)) OVER () * 100,
        4
    ) AS Cumulative_Revenue_Percentage

FROM retail_final
GROUP BY StockCode;

SELECT *
FROM product_sales
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    MIN(Cumulative_Revenue_Percentage) AS minimum_cumulative,
    MAX(Cumulative_Revenue_Percentage) AS maximum_cumulative
FROM product_sales;

SELECT
    ROUND(SUM(Revenue_Percentage), 2) AS total_revenue_percentage
FROM product_sales;

-- ============================================================
-- 4. ABC CLASSIFICATION
-- ============================================================

CREATE TABLE abc_analysis AS
SELECT
    StockCode,
    Total_Quantity,
    Total_Revenue,
    Revenue_Percentage,
    Cumulative_Revenue_Percentage,
    CASE
        WHEN Cumulative_Revenue_Percentage <= 80 THEN 'A'
        WHEN Cumulative_Revenue_Percentage <= 95 THEN 'B'
        ELSE 'C'
    END AS ABC_Category
FROM product_sales;

SELECT ABC_Category, COUNT(*)
FROM abc_analysis
GROUP BY ABC_Category;

-- ============================================================
-- 5. FINAL ANALYSIS
-- ============================================================

SELECT
    ABC_Category,
    COUNT(*) AS Product_Count,
    ROUND(SUM(Total_Revenue), 2) AS Category_Revenue,
    ROUND(
        SUM(Total_Revenue)
        / (SELECT SUM(Total_Revenue) FROM abc_analysis)
        * 100,
        2
    ) AS Revenue_Percentage,
	ROUND(
        COUNT(*) / SUM(COUNT(*)) OVER () * 100,
        2
    ) AS product_percentage
FROM abc_analysis
GROUP BY ABC_Category
ORDER BY ABC_Category;

