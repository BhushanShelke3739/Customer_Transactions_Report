# Customer_Transactions_Report

This project explores a Customer Transactions Dataset containing demographic and behavioral data, with insights generated through SQL reporting and a Power BI dashboard.

## Dataset Overview

The dataset consists of the following columns:

| Column | Description |
|--------|-------------|
| Customer_ID | Unique identifier for each customer |
| Age | Age of the customer |
| Annual_Income | Customer's yearly income (in currency units) |
| Spending_Score | Spending behavior score (higher is better) |
| Purchase_Frequency | Number of purchases made in a period |
| Transaction_Amount | Average transaction value |

## SQL Reporting Highlights

The SQL report covers:

### Data Quality Checks
- Missing value detection in key fields (Age, Income, Scores, etc.)
- Identifying invalid values (negative incomes or transaction amounts)

### Customer Segmentation
- By Age Groups: Teens, 20s, 30s, 40s, 50s, 60+
- By Income Groups: Low, Medium, High

### Behavioral & Value Analysis
- Top Spenders based on transaction amounts
- Spending Score Distribution in ranges of 10
- Purchase Frequency Trends and its relation to average transaction amounts and spending scores
- High Frequency vs High Transaction Customers segmentation
- Estimated Customer Annual Value (based on frequency × transaction value)

### Customer Tiers:
- Platinum: > 3000 value
- Gold: 1500 - 3000
- Silver: 500 - 1500

### Data Anomalies
- Customers with missing or invalid data, zero purchase frequency with non-zero transactions, and other potential issues.

## Power BI Dashboard

![image](https://github.com/user-attachments/assets/c323edf0-2044-4bbb-bf64-5abe83b167bd)

![ct report2](https://github.com/user-attachments/assets/5d696e0f-0890-4508-9965-faa2c2571aa4)


In addition to SQL reporting, a Power BI Dashboard was built to visualize:
- Customer demographic distributions
- Income and spending score trends
- High-value customer segments
- Purchase frequency and transaction behavior breakdowns
- Key anomalies and data quality issues

## Summary

This project showcases an end-to-end workflow:
1. Data Exploration & Cleaning
2. SQL-based Analysis & Segmentation
3. Behavioral Insights
4. Power BI Visualization
