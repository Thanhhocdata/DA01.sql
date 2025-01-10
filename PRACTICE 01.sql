--EX1
SELECT NAME FROM CITY
WHERE COUNTRYCODE = "USA" AND (POPULATION > 120000)
--EX2
SELECT * FROM CITY
WHERE COUNTRYCODE ='JPN'
--EX3
SELECT CITY, STATE FROM STATION
--EX4 anh ơi, cái này có kết hợp dùng in được ko ạ
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%'
EX5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u'
EX6
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'a%' AND CITY NOT LIKE 'e%' AND CITY NOT LIKE 'i%' AND CITY NOT LIKE 'o%' AND CITY NOT LIKE 'u%'
EX7
SELECT NAME FROM Employee
ORDER BY NAME
EX8
SELECT NAME FROM Employee
WHERE salary > 2000 AND months < 10
ORDER BY Employee_id ASC
EX9
SELECT product_id FROM PRODUCTS
WHERE low_fats ='Y' AND recyclable = 'Y'
EX10
SELECT NAME FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL
EX11
SELECT name, population, area FROM World
WHERE area >= 3000000 OR population >= 25000000
EX12
SELECT DISTINCT author_id AS id FROM Views
WHERE Author_id = Viewer_id
ORDER BY author_id
EX13
SELECT part,assembly_step FROM parts_assembly
WHERE finish_date IS NULL
EX14 
select * from lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000
EX15
SELECT advertising_channel FROM uber_advertising
Where year = 2019 AND money_spent > 100000
