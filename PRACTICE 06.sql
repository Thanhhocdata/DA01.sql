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
SELECT
TO_CHAR(trans_date,'yyyy-mm') AS month,  
country,
count(id) AS trans_count,
SUM(CASE 
WHEN state = 'approved' THEN 1 ELSE 0
END) AS approved_count,
SUM(amount) AS trans_total_amount,  
SUM(CASE
WHEN state = 'approved' THEN amount ELSE 0
END) AS approved_total_amount 
FROM Transactions
GROUP BY month,country
EX7
SELECT a.product_id, a.year AS first_year, a.quantity, price 
FROM Sales AS a
JOIN Product AS b 
ON a.product_id =b.product_id 
WHERE year = 
(SELECT MIN(YEAR) 
FROM Sales
WHERE product_id = a.product_id
GROUP BY product_id)
EX8
SELECT customer_id
FROM Customer AS a
JOIN Product AS b
ON a.product_key =b.product_key 
GROUP BY customer_id
HAVING COUNT(DISTINCT(a.product_key)) = (SELECT count(product_key) FROM Product)
EX9
SELECT a.employee_id 
FROM Employees AS a
LEFT JOIN Employees AS b 
ON a.manager_id = b.employee_id  
WHERE a.salary < 30000 AND a.manager_id IS NOT NULL AND b.employee_id  IS NULL
ORDER BY employee_id 
EX10 Bài này trung với EX1 hay sao í anh ạ
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
EX11
WITH 
tb1 AS 
(SELECT a.name AS results  
FROM Users AS a
JOIN MovieRating AS b
ON a.user_id = b.user_id
GROUP BY a.name
ORDER BY COUNT (rating) DESC, results
LIMIT 1),
tb2 AS     
(SELECT 
b.title
FROM MovieRating AS a
JOIN Movies AS b
ON a.movie_id=b.movie_id      
WHERE EXTRACT (YEAR FROM created_at) =2020 AND EXTRACT (MONTH FROM created_at) =2
GROUP BY b.title
ORDER BY AVG (rating) DESC ,b.title
LIMIT 1)
SELECT * FROM tb1
UNION ALL
SELECT * FROM tb2 
EX12
WITH 
NUM_OF_YOUR_FRIEND_REQUEST_ACCEPTED_BY_PEOPLE AS
(SELECT requester_id,
COUNT (accepter_id) AS num 
FROM RequestAccepted 
GROUP BY requester_id),
NUM_OF_YOU_ACCEPTED_FRIEND_REQUEST AS
(SELECT accepter_id,
COUNT(accepter_id) AS num
FROM RequestAccepted 
GROUP BY accepter_id),
Request_id_user_has_friend AS
(SELECT COALESCE (a.requester_id,accepter_id ) AS id,
COALESCE(a.num,0) + COALESCE(b.num,0) AS num  
FROM NUM_OF_YOUR_FRIEND_REQUEST_ACCEPTED_BY_PEOPLE AS a
FULL JOIN NUM_OF_YOU_ACCEPTED_FRIEND_REQUEST AS b
ON a.requester_id = b.accepter_id
ORDER BY num),
accepter_id_user_has_friend AS
(SELECT 
COALESCE (a.requester_id,accepter_id ) AS id,
COALESCE(a.num,0) + COALESCE(b.num,0) AS num  
FROM NUM_OF_YOUR_FRIEND_REQUEST_ACCEPTED_BY_PEOPLE AS a
FULL JOIN NUM_OF_YOU_ACCEPTED_FRIEND_REQUEST AS b
ON a.requester_id = b.accepter_id
)
SELECT * FROM accepter_id_user_has_friend
UNION
SELECT * FROM Request_id_user_has_friend
ORDER BY num DESC
LIMIT 1 


 
