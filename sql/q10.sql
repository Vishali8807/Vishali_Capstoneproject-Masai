-- Business question: which customers have never placed an order (re-engagement list)?
SELECT c.customer_id, c.first_name, c.last_name, c.region
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL   -- unmatched side of the LEFT JOIN = no order exists
ORDER BY c.customer_id;
