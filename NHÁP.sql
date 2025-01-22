WITH cte1 AS
(SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) - 1.5*(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) -PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered)) AS MIN,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) +1.5*(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) -PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered)) AS MAX
FROM public.sales_dataset_rfm_prj)
SELECT * FROM public.sales_dataset_rfm_prj
WHERE quantityordered <= (SELECT cte1.min from cte1) OR  quantityordered >= (SELECT cte1.max from cte1)
