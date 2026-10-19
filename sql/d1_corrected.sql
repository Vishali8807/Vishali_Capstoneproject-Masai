-- Corrected D1: regions whose completed-order revenue exceeds 80000, highest first.
SELECT c.region, SUM(o.amount) AS sales
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
