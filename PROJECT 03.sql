EX1. Doanh thu theo từng ProductLine, Year_id  và DealSize
SELECT productline,dealsize,year_id,
sum(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean 
group by productline,year_id,dealsize
order by productline,dealsize,year_id
EX2.  tháng có bán tốt nhất mỗi năm
WITH cte1 AS
(SELECT *,
DENSE_RANK() OVER ( ORDER BY MONTH_ID ) AS rank
FROM 
(SELECT MONTH_ID,
count(ordernumber) as total_order,
sum(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean 
group by MONTH_ID) AS t)
select  MONTH_ID, REVENUE, total_order from cte1
where rank =1
EX3. Product line nào được bán nhiều ở tháng 11
SELECT month_id,productline,
SUM(sales) AS revenue
FROM  public.sales_dataset_rfm_prj_clean
group by month_id,productline
having month_id=11
order by revenue desc
limit 1
EX4
SELECT *,
DENSE_RANK () OVER (PARTITION BY YEAR_ID ORDER BY revenue DESC ) AS rank 
FROM 
(SELECT YEAR_ID,productline,
SUM(sales) AS revenue
FROM  public.sales_dataset_rfm_prj_clean
group by YEAR_ID,productline) AS t
EX5
WITH customer_rfm AS
(SELECT customername,
current_date-max(orderdate) AS R,
COUNT(DISTINCT ordernumber) AS F,
sum(sales) AS M
FROM public.sales_dataset_rfm_prj_clean
GROUP BY customername),
rfm_score AS
(SELECT customername,
ntile(5) OVER (ORDER BY R DESC) AS R_score,
ntile(5) OVER (ORDER BY F DESC) AS F_score,
ntile(5) OVER (ORDER BY M DESC) AS M_score
FROM customer_rfm)
SELECT a.customername,b.segment
FROM 
(SELECT customername,
CAST(R_score AS VARCHAR)||CAST(F_score AS VARCHAR)||CAST(M_score AS VARCHAR) AS total_rfm_score
FROM rfm_score) as a
JOIN public.segment_score AS b
ON a.total_rfm_score=b.scores
WHERE b.segment IN ('Champions')
