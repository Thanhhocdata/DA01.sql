EX1
WITH no_of_Dup_job AS
(SELECT company_id,title,description,
COUNT (*) AS count_dumplicate_job
FROM job_listings 
GROUP BY company_id,title,description)
SELECT 
SUM(CASE
WHEN count_dumplicate_job >= 2 THEN 1 ELSE 0
END) AS duplicate_companies
FROM no_of_Dup_job
