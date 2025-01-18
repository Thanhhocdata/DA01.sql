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
EX4
-- TÌM visited_on thỏa mãn với MA7
WITH a AS
(SELECT visited_on,
SUM(amount) AS new_amount,
RANK() OVER (ORDER BY visited_on ) AS rank
FROM Customer
GROUP BY visited_on
ORDER BY visited_on),
d AS
(SELECT visited_on 
 From a
 WHERE rank -7 >=0),
-- Tìm amount 
b AS
(SELECT *,
SUM(new_amount) OVER (ORDER BY visited_on ) AS Cumulative_total_amount
FROM a),
c AS
(SELECT b.visited_on , 
b.cumulative_total_amount,
LAG(cumulative_total_amount,7) OVER (ORDER BY visited_on) AS pre_7_cumulative_total_amount
FROM b)
select c.visited_on,
cumulative_total_amount -COALESCE(pre_7_cumulative_total_amount,0) AS amount,
ROUND((cumulative_total_amount -COALESCE(pre_7_cumulative_total_amount,0))/7.00,2) AS average_amount 
From c
EX5
--Tìm tiv_2015 giống với người khác
WITH a AS
(SELECT pid,tiv_2016 
FROM Insurance
WHERE Tiv_2015 IN 
(SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015 
HAVING COUNT (tiv_2015) >1)),
--TÌM LAT_LON unique
b AS
(SELECT pid,         
CONCAT(lat, ', ', lon)  as latlon
FROM Insurance),
c AS
(SELECT b.pid 
FROM b
WHERE latlon IN 
(SELECT latlon 
FROM b
GROUP BY latlon 
HAVING COUNT (latlon) =1))
SELECT
ROUND(CAST(SUM(a.tiv_2016) AS DECIMAL(10,2)),2) AS tiv_2016
FROM a
JOIN c
ON a.pid =c.pid
EX6
WITH cte1 AS
(SELECT b.name AS Department, a.name AS Employee, a.salary AS Salary 
FROM Employee AS a
JOIN Department AS b
ON a.departmentId =b.id),
cte2 AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY Department ORDER BY SALARY DESC,Department) AS rank
FROM cte1)
SELECT Department,Employee,Salary 
FROM cte2
WHERE rank <=3
EX7
