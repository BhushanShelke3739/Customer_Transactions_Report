USE customer_transactions_db;

-- SQL Report for Customer Transactions data

-- Database Schema
--CREATE TABLE unclean_customer_data (
--    Customer_ID INT PRIMARY KEY,
--    Age FLOAT,
--    Annual_Income FLOAT,
--    Spending_Score FLOAT,
--    Purchase_Frequency INT,
--    Transaction_Amount FLOAT
--);

-- Missing values check
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Annual_Income IS NULL THEN 1 ELSE 0 END) AS missing_income,
    SUM(CASE WHEN Spending_Score IS NULL THEN 1 ELSE 0 END) AS missing_spending_score,
    SUM(CASE WHEN Purchase_Frequency IS NULL THEN 1 ELSE 0 END) AS missing_purchase_freq,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS missing_transaction_amount
FROM unclean_customer_data;

-- Invalid Value Check
SELECT COUNT(*) as negative_incomes
FROM unclean_customer_data
WHERE Annual_Income < 0;

SELECT COUNT(*) as negative_transactions
FROM unclean_customer_data
WHERE Transaction_Amount < 0;


-- Dividing customers into groups
-- Age groups
WITH customer_age_groups AS (
    SELECT
        CASE
            WHEN Age < 20 THEN 'Teen'
            WHEN Age BETWEEN 20 AND 29 THEN '20s'
            WHEN Age BETWEEN 30 AND 39 THEN '30s'
            WHEN Age BETWEEN 40 AND 49 THEN '40s'
            WHEN Age BETWEEN 50 AND 59 THEN '50s'
            WHEN Age >= 60 THEN '60+'
            ELSE 'Unknown'
        END AS age_group,
        Annual_Income,
        Spending_Score,
        Purchase_Frequency,
        Transaction_Amount
    FROM unclean_customer_data
)
SELECT
    age_group,
    COUNT(*) AS customer_count,
    AVG(Annual_Income) AS avg_income,
    AVG(Spending_Score) AS avg_spending_score,
    AVG(Purchase_Frequency) AS avg_purchase_freq,
    AVG(Transaction_Amount) AS avg_transaction_amount
FROM customer_age_groups
GROUP BY age_group
ORDER BY 
    CASE 
        WHEN age_group = 'Teen' THEN 1
        WHEN age_group = '20s' THEN 2
        WHEN age_group = '30s' THEN 3
        WHEN age_group = '40s' THEN 4
        WHEN age_group = '50s' THEN 5
        WHEN age_group = '60+' THEN 6
        ELSE 7
    END;

-- Income Groups
WITH customer_income_groups as(
	SELECT
		CASE
			WHEN Annual_Income < 30000 THEN 'Low'
			WHEN Annual_Income BETWEEN 30000 AND 60000 THEN 'Medium'
			WHEN Annual_Income > 60000 THEN 'High'
			ELSE 'Unknown'
		END AS income_segment,
		Annual_Income,
		Spending_Score,
		Purchase_Frequency,
		Transaction_Amount
	FROM unclean_customer_data
)
SELECT
	 income_segment,
    COUNT(*) AS customer_count,
    AVG(Annual_Income) AS avg_income,
    AVG(Spending_Score) AS avg_spending_score,
    AVG(Purchase_Frequency) AS avg_purchase_freq,
    AVG(Transaction_Amount) AS avg_transaction_amount
FROM customer_income_groups
GROUP BY income_segment
ORDER BY 
    CASE 
        WHEN income_segment = 'Low' THEN 1
        WHEN income_segment = 'Medium' THEN 2
        WHEN income_segment = 'High' THEN 3
        ELSE 4
    END;

-- Spending Behaviour Analysis

-- Top Spenders
SELECT
	TOP 10 Customer_ID,
	Age,
	Annual_Income,
	Spending_Score,
	Purchase_Frequency,
	Transaction_Amount
FROM
	unclean_customer_data
ORDER BY Transaction_Amount DESC;

-- Spending Score Distribution
SELECT
	FLOOR(Spending_Score/10)*10 as score_range_start,
	FLOOR(Spending_Score/10)*10+9 as score_range_end,
	COUNT(*) as customer_count
FROM
	unclean_customer_data
GROUP BY FLOOR(Spending_Score/10)
ORDER BY score_range_start;

-- Purchase Frequency Analysis
SELECT
	Purchase_Frequency,
	COUNT(*) AS customer_count,
	AVG(Transaction_Amount) as avg_transaction_amount,
	AVG(Spending_Score) as avg_spending_score
FROM
	unclean_customer_data
GROUP BY Purchase_Frequency
ORDER BY Purchase_Frequency;

-- High frequency vs high transaction customers
WITH purchase_frequency_cte as(
	SELECT 
		CASE 
			WHEN Purchase_Frequency > 20 THEN 'High Frequency'
			WHEN Transaction_Amount > 150 THEN 'High Transaction'
			ELSE 'Regular'
		END AS customer_type,
		COUNT(*) AS customer_count,
		AVG(Annual_Income) AS avg_income,
		AVG(Spending_Score) AS avg_spending_score
	FROM unclean_customer_data
	WHERE Purchase_Frequency > 20 OR Transaction_Amount > 150
	 GROUP BY 
        CASE 
            WHEN Purchase_Frequency > 20 THEN 'High Frequency'
            WHEN Transaction_Amount > 150 THEN 'High Transaction'
            ELSE 'Regular'
        END)
SELECT customer_type, customer_count, avg_income, avg_spending_score
FROM purchase_frequency_cte
;

-- Customer Value Analysis
SELECT 
    TOP 20 Customer_ID,
    Annual_Income,
    Spending_Score,
    Purchase_Frequency,
    Transaction_Amount,
    (Transaction_Amount * Purchase_Frequency) AS estimated_annual_value
FROM unclean_customer_data
ORDER BY estimated_annual_value DESC
;

-- High Value Customer Segments
WITH cust_segments as(
	SELECT 
		CASE 
			WHEN (Transaction_Amount * Purchase_Frequency) > 3000 THEN 'Platinum'
			WHEN (Transaction_Amount * Purchase_Frequency) BETWEEN 1500 AND 3000 THEN 'Gold'
			WHEN (Transaction_Amount * Purchase_Frequency) BETWEEN 500 AND 1500 THEN 'Silver'
			ELSE 'Bronze'
		END AS customer_tier,
		Age,
		Annual_Income
	FROM unclean_customer_data)
SELECT customer_tier,COUNT(*) AS customer_count, AVG(Age) AS avg_age,
		AVG(Annual_Income) AS avg_income
FROM cust_segments
GROUP BY customer_tier
ORDER BY 
    CASE 
        WHEN customer_tier = 'Platinum' THEN 1
        WHEN customer_tier = 'Gold' THEN 2
        WHEN customer_tier = 'Silver' THEN 3
        ELSE 4
    END;


-- Customers with potential data issues
SELECT 
    Customer_ID,
    Age,
    Annual_Income,
    Spending_Score,
    Purchase_Frequency,
    Transaction_Amount
FROM unclean_customer_data
WHERE 
    Age IS NULL OR 
    Annual_Income < 0 OR 
    Transaction_Amount < 0 OR 
    Purchase_Frequency = 0 AND Transaction_Amount > 0
ORDER BY 
    CASE 
        WHEN Age IS NULL THEN 0
        WHEN Annual_Income < 0 THEN 1
        WHEN Transaction_Amount < 0 THEN 2
        ELSE 3
    END;