EX1
WITH a AS
(SELECT *,
RANK () OVER (PARTITION BY customer_id ORDER BY order_date) AS nth_purchase
FROM Delivery)
SELECT 
ROUND(SUM(CASE 
WHEN a.order_date =a.customer_pref_delivery_date THEN 1 
ELSE 0 END)*1.00 /COUNT (*)*1.00 *100,2) AS immediate_percentage 
FROM a
WHERE nth_purchase =1
EX2
--nth_log_in
WITH a AS
(SELECT player_id,event_date,
RANK () OVER (PARTITION BY player_id ORDER BY event_date) AS nth_log_in
FROM Activity),
--the_first_log_in
b1 AS
(SELECT a.player_id,a.event_date AS the_first_event_date
FROM  a
WHERE nth_log_in =1),
--the_second_log_in
b2 AS 
(SELECT a.player_id,a.event_date AS the_next_event_date
FROM  a
WHERE nth_log_in =2)
SELECT 
ROUND((SELECT COUNT(*)
FROM b1
JOIN b2
ON b1.player_id =b2.player_id 
WHERE b2.the_next_event_date-b1.the_first_event_date =1)*1.00
/count (DISTINCT player_id)*1.00,2) AS fraction  
FROM Activity
EX3
WITH b AS
(SELECT id,student,
CASE 
WHEN id%2=0 then id-1
WHEN id%2=1 then id+1
END AS change_seat
FROM seat)
select b.id,
COALESCE(a.student,b.student) AS student 
FROM b
LEFT JOIN Seat AS a
ON a.id=b.change_seat 

