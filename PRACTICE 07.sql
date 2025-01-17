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
WITH a AS
(SELECT 
transaction_id,merchant_id,credit_card_id,amount,transaction_timestamp,
EXTRACT (HOUR FROM transaction_timestamp)*60+EXTRACT (MINUTE FROM transaction_timestamp) AS TIME_MINUTE,
LAG(EXTRACT (HOUR FROM transaction_timestamp)*60+EXTRACT (MINUTE FROM transaction_timestamp)) OVER (PARTITION BY merchant_id,credit_card_id,amount ORDER BY transaction_timestamp) AS PREVIOUS_TIME_MINUTE
FROM transactions)
SELECT COUNT(*) AS payment_count
FROM a
WHERE (TIME_MINUTE - PREVIOUS_TIME_MINUTE) <=10
EX7
WITH a AS
(SELECT 
category,product,
SUM(spend) OVER (PARTITION BY product) AS total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) =2022),
b AS
(SELECT DISTINCT*,
DENSE_RANK () OVER (PARTITION BY a.category ORDER BY a.total_spend DESC) AS rank
FROM a
)
SELECT b.category,b.product,b.total_spend 
FROM b
WHERE b.rank <= 2
ORDER BY category,total_spend DESC
EX8
--top những bài hát xuất hiện nhiều nhất
WITH Top_10_appear  AS
(SELECT song_id,
COUNT(song_id) AS num_appear
FROM global_song_rank
WHERE rank <= 10
GROUP BY song_id
ORDER BY num_appear),
num_artist_appear_in_top_10 AS
(SELECT artists.artist_name,
SUM(num_appear) AS Total_num_appear
FROM Top_10_appear
JOIN songs 
ON songs.song_id = Top_10_appear.song_id
JOIN artists 
ON artists.artist_id=songs.artist_id
GROUP BY artists.artist_name
ORDER BY total_num_appear DESC),
Output AS
(SELECT *, 
DENSE_RANK() OVER (ORDER BY total_num_appear DESC) AS rank
FROM num_artist_appear_in_top_10)
SELECT Output.artist_name, rank 
FROM Output
WHERE rank <=5
