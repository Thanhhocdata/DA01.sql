EX1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2 = 0
EX2
SELECT 
COUNT(CITY)-COUNT(DISTINCT CITY)
FROM STATION
EX3 (Để dành)
EX4
-- PHÂN TÍCH YÊU CẦU
  1. OUTPUT (Lấy từ bảng gốc/ Phải tạo ra)
  2. INPUT
  3. Lọc theo điều kiện nào 
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences) / Sum(order_occurrences) AS DECIMAL), 1)
FROM items_per_order
EX5
SELECT candidate_id FROM candidates
WHERE skill IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
EX6
SELECT user_id, 
DATE(max(post_date))- DATE(min(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id) >= 2
EX7
SELECT card_name, 
MAX(issued_amount)- MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC
EX8
SELECT manufacturer, 
COUNT(drug) AS drug_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs < 0
GROUP BY manufacturer
ORDER BY total_loss DESC
EX9: CHIA CHĂN HOẶC LẺ %2 = 0 HOẶC %2 != 0
SELECT * FROM Cinema
WHERE id%2 != 0 AND description != 'boring'
ORDER BY rating DESC
EX10
SELECT teacher_id,
COUNT (DISTINCT subject_id ) AS cnt
FROM Teacher
GROUP BY teacher_id
EX11
SELECT user_id, 
COUNT(DISTINCT follower_id ) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id
EX12
SELECT class   
FROM Courses
GROUP BY class
HAVING COUNT (student ) >= 5
