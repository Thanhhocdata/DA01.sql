NHÁP Phân loại trước group sau
SELECT
CASE
WHEN length > 120 then 'long'
WHEN length BETWEEN 60 AND 120  then 'medium'
ELSE 'short'
END AS category,
CASE
WHEN rating = 'R' THEN 1 ELSE 0
END AS r
FROM film
