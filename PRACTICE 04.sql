EX1
SELECT 
COUNT(CASE
WHEN device_type ='laptop' THEN device_type
ELSE NULL END) AS laptop_views,
COUNT(CASE
WHEN device_type IN ('tablet','phone') THEN device_type
ELSE NULL END) AS mobile_views 
FROM viewership;
EX2
SELECT x,y,z,
(CASE
WHEN ABS(x) + ABS(y) > ABS(z) AND ABS(x) + ABS(z) > ABS(y) AND ABS(z) + ABS(y) > ABS(x) THEN 'Yes'
ELSE 'No' END ) AS triangle
FROM TRIANGLE
EX3
SELECT
ROUND(
CAST(sum(
CASE
WHEN call_category is null or call_category = 'n/a' then 1
else 0 end) AS DECIMAL(10,2))
/CAST(count(*) AS DECIMAL (10,2))
*100,1) AS uncategorised_call_pct
FROM callers
EX4
SELECT NAME
FROM Customer 
WHERE COALESCE (referee_id,1) !=2
EX5
SELECT 
pclass,
CASE 
WHEN pclass = 1 THEN 'first_class' 
WHEN pclass = 2 THEN 'second_classs'
WHEN pclass = 3 THEN 'third_class'
END AS passenger_class,
COUNT(
CASE
WHEN survived = 0 THEN 1 ELSE NULL END) AS non_survivors,
COUNT(
CASE
WHEN survived = 1 THEN 1 ELSE NULL END) AS survivors
FROM titanic
GROUP BY pclass
ORDER BY pclass
