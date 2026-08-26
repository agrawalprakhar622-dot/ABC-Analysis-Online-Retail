# ABC-Analysis-Online-Retail
📊 ABC Analysis – Online Retail

SQL + Power BI | Data Analysis | Inventory Analysis

About the Project

I built this project to analyze an online retail dataset and understand how much each product contributes to the company's overall revenue.

The main goal was to use ABC Analysis to divide products into three categories based on their cumulative revenue contribution:

A: High-value products
B: Medium-value products
C: Lower-value products

I used MySQL for data cleaning and analysis and Power BI to build the final dashboard and present the findings.

🎯 What I Wanted to Find

The main questions I wanted to answer were:

Which products generate the most revenue?
How is revenue distributed across the product portfolio?
Which products should receive the most attention from an inventory perspective?
How can the analysis be presented in a way that is easy to understand?
🗃️ Dataset

The project uses the Online Retail II dataset, which contains more than 1 million transaction records from an online retail business.

Some of the main columns are:

Invoice
StockCode
Description
Quantity
InvoiceDate
Price
Customer_ID
Country

The original CSV file is not included in this repository because of its large size.

🔄 Project Workflow
Raw Data
   ↓
Import into MySQL
   ↓
Data Cleaning
   ↓
Duplicate Identification & Removal
   ↓
Product-Level Sales Analysis
   ↓
Revenue % & Cumulative Revenue %
   ↓
ABC Classification
   ↓
Power BI Dashboard
   ↓
Insights & Recommendations
🧹 Data Cleaning

I used MySQL to prepare the raw data before performing the ABC analysis.

The main steps were:

Converted quantity and price into appropriate numeric formats
Converted InvoiceDate into a date-time format
Removed unnecessary whitespace from product descriptions
Removed records with zero or negative quantities
Removed records with zero or negative prices
Checked for duplicate transactions
Removed duplicate records using SELECT DISTINCT
Performed validation checks on the cleaned data
📈 Product-Level Analysis

After cleaning the data, I grouped the transactions by StockCode and calculated:

Total quantity sold
Total revenue
Revenue percentage
Cumulative revenue percentage

Revenue was calculated as:

Revenue = Quantity × Price

I used SQL window functions to calculate the percentage of total revenue contributed by each product and the cumulative revenue percentage used for ABC classification.

🔤 ABC Classification

The products were classified using cumulative revenue contribution:

Category	Cumulative Revenue	Priority
A	Up to 80%	High
B	80% – 95%	Medium
C	Above 95%	Low
Results
Category	Products	Revenue Contribution
A	998	79.98%
B	1,269	15.01%
C	2,479	5.01%
🔎 Main Finding

The biggest takeaway from the analysis was that 998 products account for approximately 80% of total revenue.

On the other hand, Category C contains the largest number of products but contributes only about 5% of revenue.

📊 Power BI Dashboard

I used Power BI to turn the SQL analysis into an interactive dashboard.

The dashboard includes:

ABC category distribution
Revenue contribution by category
Product-level revenue analysis
Cumulative revenue analysis
A/B classification boundaries
Category-level comparison
Key business insights and recommendations
Main Dashboard




Insights Page




💡 Key Insights
Category A — High Priority

Category A contains 998 products but contributes 79.98% of total revenue.

These products have the biggest impact on overall revenue, so they should receive the most attention when managing inventory.

Possible actions:

Keep important A-category products well stocked
Monitor their demand regularly
Reduce the risk of stockouts
Category B — Moderate Priority

Category B contains 1,269 products and contributes 15.01% of revenue.

These products are not as critical as Category A, but their performance should still be monitored. Some products could potentially become more important if their sales increase.

 Category C — Low Revenue Contribution

Category C contains 2,479 products, making it the largest category by product count, but it contributes only 5.01% of revenue.

This suggests that inventory costs should be managed carefully for these products.

Possible actions:

Monitor slow-moving products
Avoid unnecessary overstocking
Review products with consistently low sales
🎯 Business Takeaway

The analysis shows that different products should be managed differently.

A simple approach would be:

A → High attention
B → Regular monitoring
C → Cost-conscious management

This allows the business to focus more resources on products that have the greatest impact on revenue.

🛠️ Tools Used
MySQL
SQL
Power BI
Skills Used
Data Cleaning
Data Transformation
SQL Aggregations
Window Functions
Revenue Analysis
ABC Classification
Data Visualization
Dashboard Development
Business Insights
📂 Repository Structure
ABC-Analysis-Online-Retail/
│
├── README.md
│
├── online_retail_analysis.sql
│
└── Dashboard/
    ├── online_retail_Dashboard.pbix
    ├── main_dashboard.png
    └── insights_page.png
    
📌 Final Takeaway

This project helped me practice the complete data analysis workflow — from raw transactional data and SQL cleaning to business analysis and Power BI visualization.

The main insight was simple:

A relatively small group of products generates the majority of revenue, so inventory management should prioritize products based on their actual business contribution.
