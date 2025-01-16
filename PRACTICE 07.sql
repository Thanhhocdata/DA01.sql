EX1
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) AS prev_year_spend,
ROUND((spend-LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date)) / LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) *100,2) AS yoy_rate
FROM user_transactions 
EX2

