EX1
WITH no_of_Dup_job AS
(SELECT company_id,title,description,
COUNT (*) AS count_dumplicate_job
FROM job_listings 
GROUP BY company_id,title,description)
SELECT 
SUM(CASE
WHEN count_dumplicate_job >= 2 THEN 1 ELSE 0
END) AS duplicate_companies
FROM no_of_Dup_job
EX2
WITH gross_2022 AS
(SELECT category,product,
SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT (YEAR FROM transaction_date )= 2022
GROUP BY category,product
ORDER BY category,total_spend),
tb1 AS
(SELECT *
FROM gross_2022
WHERE category ='appliance'
ORDER BY total_spend DESC
LIMIT 2),
tb2 AS
(SELECT *
FROM gross_2022
WHERE category ='electronics'
ORDER BY total_spend DESC
LIMIT 2)
SELECT * FROM tb1
UNION ALL
SELECT * FROM tb2
EX3
WITH num_call AS
(SELECT policy_holder_id,
COUNT(case_id) AS number_of_calls
FROM callers
GROUP BY policy_holder_id
ORDER BY policy_holder_id)
SELECT 
COUNT(*) AS policy_holder_count
FROM num_call
WHERE number_of_calls >= 3
EX4
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes  AS b
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY page_id
EX5
WITH user_active_in_7 AS
(SELECT * 
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 7 AND EXTRACT(YEAR FROM event_date) = 2022
ORDER BY user_id),
user_active_in_6 AS
(SELECT * 
FROM user_actions
WHERE EXTRACT(MONTH FROM event_date) = 6 AND EXTRACT(YEAR FROM event_date) = 2022
ORDER BY user_id)
SELECT EXTRACT(MONTH FROM b.event_date) AS month,
COUNT (DISTINCT(a.user_id)) AS monthly_active_users
FROM user_active_in_6 AS a
FULL JOIN user_active_in_7 AS b
ON a.user_id=b.user_id
WHERE a.event_date IS NOT NULL AND b.event_date IS NOT NULL
GROUP BY month
EX6
