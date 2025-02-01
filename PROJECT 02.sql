1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng ( Từ 1/2019-4/2022)
SELECT 
EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at) AS month_year,
COUNT (order_id) AS total_order,
COUNT(DISTINCT user_id) AS total_user
 FROM bigquery-public-data.thelook_ecommerce.orders
 GROUP BY month_year
 HAVING month_year BETWEEN '2019-01' AND '2022-04'
 ORDER BY month_year
2.  Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
WITH cte1 as
(SELECT 
EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at) AS month_year,
COUNT(DISTINCT user_id) AS distinct_users
 FROM bigquery-public-data.thelook_ecommerce.orders
 GROUP BY month_year
 HAVING month_year BETWEEN '2019-01' AND '2022-04'
 ORDER BY month_year),
 cte2 AS 
 (SELECT 
 EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at) AS month_year,
 SUM (sale_price)/COUNT(order_id) AS average_order_value
 FROM bigquery-public-data.thelook_ecommerce.order_items
 GROUP BY (month_year))
 SELECT cte1.month_year,cte1.distinct_users,cte2.average_order_value
  FROM cte1
 LEFT JOIN cte2
 ON cte1.month_year = cte2.month_year
 ORDER BY cte1.month_year
3.Nhóm khách hàng theo độ tuổi
WITH cte1 AS
(SELECT 
first_name,last_name,age,gender,
EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at) AS month_year,
DENSE_RANK  () OVER (PARTITION BY gender ORDER BY age) AS young_rank,
DENSE_RANK  () OVER (PARTITION BY gender ORDER BY age DESC) AS old_rank 
 FROM bigquery-public-data.thelook_ecommerce.users),
 count_table AS
 (SELECT first_name,last_name,gender,age,
 (CASE 
 WHEN young_rank=1 THEN 'youngest'
 WHEN old_rank = 1 THEN 'oldest'
 ELSE NULL END) AS tag
  FROM cte1
 WHERE  (CASE 
 WHEN young_rank=1 THEN 'youngest'
 WHEN old_rank = 1 THEN 'oldest'
 ELSE NULL END)  is not null AND month_year BETWEEN '2019-01' AND '2022-04'
) 
  SELECT COUNT(*) FROM count_table
TRẺ NHẤT THEO MAN LÀ 12 TUỔI, SỐ LƯỢNG 443
TRẺ NHẤT THEO FEMALE LÀ 12 TUỔI, SỐ LƯỢNG 401
GIÀ NHẤT THEO THEO MAN LÀ 70 TUỔI, SỐ LƯỢNG 410
GIÀ NHẤT THEO THEO  female LÀ 70 TUỔI, SỐ LƯỢNG 391
4.Top 5 sản phẩm mỗi tháng.
WITH cte1 AS
(select 
EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at) AS month_year,
product_id,
product_name,
product_retail_price as sales,
cost,
product_retail_price-cost as profit
from bigquery-public-data.thelook_ecommerce.inventory_items),
cte2 AS
(SELECT *,
DENSE_RANK () OVER (PARTITION BY product_id ORDER BY profit DESC) as rank
FROM cte1)
SELECT month_year,product_id,product_name,sales,cost,profit
FROM cte2
where rank <= 5
ORDER BY month_year
5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
product_categories,
SUM (product_retail_price)  as revenue
  from bigquery-public-data.thelook_ecommerce.inventory_items
  GROUP BY dates,product_categories
5. Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
WITH cte1  as 
(select 
EXTRACT (YEAR FROM created_at)||'-'||EXTRACT (MONTH FROM created_at)||'-'||EXTRACT (DAY FROM created_at) AS dates,
product_category, 
SUM(product_retail_price- cost) AS revenue
FROM 
bigquery-public-data.thelook_ecommerce.inventory_items
GROUP BY dates,product_category)
SELECT * FROM cte1
WHERE dates BETWEEN '2022-01-15' AND '2022-4-15' 
order by dates
6. TABLE THEO YÊU CẦU

WITH cte1 AS
(SELECT a.order_id,b.product_id,b.sale_price,c.cost,a.created_at,
EXTRACT (YEAR FROM a.created_at )||'-'||EXTRACT (MONTH FROM a.created_at) AS Month,
EXTRACT (YEAR FROM a.created_at) AS Year,
EXTRACT (MONTH FROM a.created_at) AS order_fix_month,
c.category,
FROM bigquery-public-data.thelook_ecommerce.orders AS a
LEFT JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.order_id =b.order_id
LEFT JOIN bigquery-public-data.thelook_ecommerce.products AS c
ON b.product_id = c.id
),
cte2 AS (
SELECT Month,Year,order_fix_month,category,
SUM (sale_price) AS TPV,
SUM(cost) AS Total_cost,
count (order_id) AS TPO,
FROM cte1
group by Month,Year,order_fix_month,category
order by year,order_fix_month
),
cte3 AS
(select *,
rank () over (order by category,year,order_fix_month) AS r1
 from cte2
),
cte4 AS
(
SELECT * ,
LAG (order_fix_month) OVER (ORDER BY category,year,order_fix_month) AS PRE_MONTH,
LAG (TPV) OVER (ORDER BY category,year,order_fix_month) AS PRE_TPV,
LAG (TPO) OVER (ORDER BY category,year,order_fix_month) AS PRE_TPO
FROM cte3
ORDER BY r1),
FINAL AS
(select Month,Year,category,TPV,TPO,
ROUND((CASE
WHEN order_fix_month-PRE_MONTH =1 THEN (TPV-PRE_TPV)*100/PRE_TPV 
ELSE 0 END),2)||'%' AS Revenue_growth,
ROUND((CASE
WHEN order_fix_month-PRE_MONTH =1 THEN (TPO-PRE_TPO)*100/PRE_TPO
ELSE 0 END),2)||'%' AS Order_growth,
Total_cost,
TPV-Total_cost AS Total_profit,
ROUND((TPV-Total_cost)/Total_cost,2) ||'%' AS Profit_to_cost_ratio
 FROM cte4)
 SELECT
 *
 FROM FINAL
