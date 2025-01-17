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
WITH a AS
(SELECT player_id,event_date,
LEAD (event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS next_event_date
FROM Activity) ,
b as (SELECT a.player_id,
 EXTRACT(YEAR FROM next_event_date)*365 +EXTRACT(MONTH FROM next_event_date)*30 +EXTRACT(DAY FROM next_event_date)-EXTRACT(YEAR FROM event_date)*365 -EXTRACT(MONTH FROM event_date)*30-EXTRACT(DAY FROM event_date) AS fraction 
FROM a)
SELECT 
ROUND((SELECT COUNT (player_id ) FROM b WHERE fraction =1)*1.00/
COUNT (DISTINCT b.player_id)*1.00,2) AS fraction 
FROM b
