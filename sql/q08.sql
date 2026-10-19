-- Business question: what does the customer base look like (size and age) in each region?
SELECT c.region,
       COUNT(c.customer_id)  AS number_of_customers,
       ROUND(AVG(c.age), 2)  AS average_age,
       MIN(c.age)            AS min_age,
       MAX(c.age)            AS max_age
FROM customers AS c
GROUP BY c.region
ORDER BY c.region;
