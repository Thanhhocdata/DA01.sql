EX1
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) AS prev_year_spend,
ROUND((spend-LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date)) / LAG(spend) OVER (PARTITION BY product_id ORDER BY transaction_date) *100,2) AS yoy_rate
FROM user_transactions 
EX2
WITH a
AS
(SELECT card_name,
CONCAT(issue_month,'/',issue_year) AS DATE,
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY CONCAT(issue_month,'/',issue_year)) AS issued_amount
FROM monthly_cards_issued)
SELECT a.card_name, a.issued_amount
FROM a
GROUP BY a.card_name, a.issued_amount
ORDER BY a.issued_amount DESC
EX3
WITH a
AS
(SELECT user_id,spend,transaction_date,
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date)
FROM transactions
WHERE user_id IN (
SELECT user_id
FROM transactions
GROUP BY user_id
HAVING COUNT(user_id)>=3)
ORDER BY user_id,transaction_date)
SELECT a.user_id,a.spend,a.transaction_date
FROM a
WHERE rank =3
EX4
WITH a
AS(SELECT *,
RANK () OVER (PARTITION BY user_id ORDER BY transaction_date DESC)
FROM user_transactions
ORDER BY user_id)
SELECT a.transaction_date,a.user_id,
COUNT(a.product_id) AS purchase_count
FROM a
WHERE a.rank = 1
GROUP BY a.transaction_date,a.user_id
EX5
WITH 
a AS
(SELECT *,
Lag(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date) AS tc2,
Lag(tweet_count,2) OVER (PARTITION BY user_id ORDER BY tweet_date) AS tc3
FROM tweets
ORDER BY user_id,tweet_date)
SELECT user_id,tweet_date,
ROUND(CAST((a.tweet_count+COALESCE(a.tc2,0)+COALESCE(a.tc3,0)) AS DECIMAL (10,2))/
(CASE
WHEN a.tc2 IS NULL AND a.tc3 IS NULL THEN 1.00
WHEN a.tc3 IS NULL THEN 2.00
ELSE 3.00 END)
,2) AS rolling_avg_3d
FROM a 
EX6
