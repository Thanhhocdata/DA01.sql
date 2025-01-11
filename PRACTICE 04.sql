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
