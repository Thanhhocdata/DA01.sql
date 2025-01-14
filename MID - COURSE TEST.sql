EX1
SELECT film_id,title, replacement_cost
FROM public.film
ORDER BY replacement_cost
EX2
SELECT 
SUM(CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0
END) AS low,
SUM(CASE
WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0
END) AS medium,
SUM(CASE
WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0
END) AS high
FROM public.film
EX3
SELECT 
a.title, a.length, c.name
FROM public.film AS a
LEFT JOIN public.film_category AS b
ON a.film_id = b.film_id
LEFT JOIN public.category AS c
ON b.category_id = c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY a.length DESC
EX4
SELECT 
SUM(CASE 
WHEN c.name = 'Family' THEN 1 ELSE 0
END) AS Family,
SUM(CASE 
WHEN c.name = 'Games' THEN 1 ELSE 0
END) AS Games,
SUM(CASE 
WHEN c.name = 'Animation' THEN 1 ELSE 0
END) AS Animation,
SUM(CASE 
WHEN c.name = 'Classics' THEN 1 ELSE 0
END) AS Classics,
SUM(CASE 
WHEN c.name = 'Documentary' THEN 1 ELSE 0
END) AS Documentary,
SUM(CASE 
WHEN c.name = 'New' THEN 1 ELSE 0
END) AS New,
SUM(CASE 
WHEN c.name = 'Sports' THEN 1 ELSE 0
END) AS Sports,
SUM(CASE 
WHEN c.name = 'Children' THEN 1 ELSE 0
END) AS Children,
SUM(CASE 
WHEN c.name = 'Music' THEN 1 ELSE 0
END) AS Music,
SUM(CASE 
WHEN c.name = 'Travel' THEN 1 ELSE 0
END) AS Travel
FROM public.film AS a
LEFT JOIN public.film_category AS b
ON a.film_id = b.film_id
LEFT JOIN public.category AS c
ON b.category_id = c.category_id
EX5
SELECT first_name,last_name,
COUNT(b.film_id) AS So_Luong_Phim
FROM public.actor AS a
LEFT JOIN public.film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY first_name,last_name
ORDER BY COUNT(b.film_id) DESC
EX6
SELECT
count(*)
FROM public.customer AS a
RIGHT JOIN public.address AS b 
ON a.address_id = b.address_id
WHERE customer_id IS NULL
EX7
SELECT
a.city,
SUM(d.amount) AS Total_revenue
FROM public.city AS a
LEFT JOIN public.address AS b
ON a.city_id =b.city_id
LEFT JOIN public.customer AS c
ON b.address_id=c.address_id
LEFT JOIN public.payment AS d
ON c.customer_id =d.customer_id
GROUP BY a.city
HAVING SUM(d.amount) IS NOT NULL
ORDER BY Total_revenue DESC
EX8
SELECT
e.country||','|| a.city AS Country_and_city,
SUM(d.amount) AS Total_revenue
FROM public.city AS a
LEFT JOIN public.address AS b
ON a.city_id =b.city_id
LEFT JOIN public.customer AS c
ON b.address_id=c.address_id
LEFT JOIN public.payment AS d
ON c.customer_id =d.customer_id
LEFT JOIN public.country AS e
ON a.country_id = e.country_id
GROUP BY e.country, a.city
HAVING SUM(d.amount) IS NOT NULL
ORDER BY Total_revenue 
