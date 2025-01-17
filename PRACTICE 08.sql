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
