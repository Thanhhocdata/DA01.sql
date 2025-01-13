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
SELECT b.employee_id ,b.name,
COUNT(a.reports_to) AS reports_count,
CEILING(AVG(a.age)) AS average_age
FROM Employees AS a
LEFT JOIN  Employees AS b
ON a.reports_to =b.employee_id 
WHERE a.reports_to IS NOT NULL 
GROUP BY b.employee_id ,b.name
EX6
SELECT a.product_name,
SUM(b.unit) AS unit   
FROM Products AS a
LEFT JOIN Orders AS b 
ON a.product_id =b.product_id
WHERE EXTRACT(MONTH FROM b.order_date) =2 AND EXTRACT(YEAR FROM b.order_date) = 2020
GROUP BY a.product_name
HAVING unit >=100
EX7
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes AS b 
ON a.page_id=b.page_id
WHERE b.user_id	IS NULL
ORDER BY a.page_id
