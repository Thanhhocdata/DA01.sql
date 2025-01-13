EX1
SELECT b.CONTINENT, 
Floor(AVG(a.population))
FROM CITY AS a
LEFT JOIN COUNTRY AS b
ON a.COUNTRYCODE = b.CODE
WHERE b.CONTINENT IS NOT NULL
GROUP BY b.CONTINENT
EX2
SELECT
ROUND(
CAST (SUM(
CASE
WHEN signup_action = 'Confirmed' THEN 1 ELSE 0
END) AS DECIMAL (10,2))
/ CAST(COUNT(signup_action) AS DECIMAL (10,2)),2)
AS signup_action
FROM emails AS a
LEFT JOIN texts AS b
ON a.email_id =b.email_id
EX3
SELECT 
a.age_bucket,
ROUND(
CAST(
SUM(
CASE
WHEN b.activity_type = 'send' THEN time_spent ELSE 0
END) AS DECIMAL (10,2))/ CAST(SUM(time_spent) AS DECIMAL (10,2))
*100,2)
AS send_perc,
ROUND(
CAST(
SUM(
CASE
WHEN b.activity_type = 'open' THEN time_spent ELSE 0
END) AS DECIMAL (10,2))/ CAST(SUM(time_spent) AS DECIMAL (10,2))
*100,2)
AS open_perc
FROM age_breakdown AS a
JOIN activities AS b 
ON a.user_id = b.user_id
WHERE activity_type IN ('open','send')
GROUP BY age_bucket
EX4
SELECT a.customer_id
FROM customer_contracts AS a
JOIN products AS b 
ON a.product_id=b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category) =3
ORDER BY a.customer_id
EX5
