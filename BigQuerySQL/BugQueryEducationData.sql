-- INNER JOIN: Returns only the rows where the target appears in both tables. 

-- OUTER LEFT JOIN: Returns every row from the left table, as well as any rows from the right table with matching keys found in the left table. 

SELECT * 
FROM table_1 
JOIN table_2 
ON table_1.key = table_2.key;


SELECT * 
FROM table_2 
JOIN table_1 
ON table_2.key = table_1.key

-- This basic query joins the tables on the country_code foreign key, and returns the country name, country code, and value column.
SELECT a.country_name, b.country_code, a.value
FROM `bigquery-public-data.world_bank_intl_education.international_education` a
JOIN `bigquery-public-data.world_bank_intl_education.country_summary` b ON a.country_code =b.country_code

--  What is the average amount of money spent per region on education?
SELECT AVG(a.value) average_value, b.region
FROM `bigquery-public-data.world_bank_intl_education.international_education` a
JOIN `bigquery-public-data.world_bank_intl_education.country_summary` b ON a.country_code = b.country_code
WHERE b.region IS NOT null
GROUP BY b.region
ORDER BY average_value DESC

