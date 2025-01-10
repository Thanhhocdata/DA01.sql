EX1
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT (Name,3), ID ASC
EX2
SELECT user_id, 
UPPER(Left (name,1)) || LOWER(substring (name FROM 2 FOR 5)) AS Name
FROM Users
EX3
SELECT manufacturer,
'$'|| ROUND(SUM(total_sales)/1000000,0) ||' ' ||'million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC
EX4
SELECT 
EXTRACT (Month FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY product_id , EXTRACT (Month FROM submit_date)
ORDER BY EXTRACT (Month FROM submit_date),product_id 
EX5
SELECT sender_id,
COUNT (message_id) AS message_count
FROM messages
WHERE EXTRACT(YEAR FROM sent_date) = 2022 AND EXTRACT(MONTH FROM sent_date) = 8
GROUP BY sender_id
ORDER BY COUNT (message_id) DESC
LIMIT 2
EX6
SELECT tweet_id 
FROM TWEETS
WHERE LENGTH(content) > 15
EX7
SELECT  activity_date AS day, 
COUNT(DISTINCT user_id ) AS active_users 
FROM Activity
WHERE  activity_date BETWEEN '2019-06-27' AND '2019-07-27'
GROUP BY activity_date
EX8
SELECT  activity_date AS day, 
COUNT(DISTINCT user_id ) AS active_users 
FROM Activity
WHERE  activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date
EX9
