-- Business question: how do completed orders, customers and revenue look by region and month?
-- Join type: INNER JOIN, because we only report region-months that have completed orders and every
-- order has a matching customer (a LEFT JOIN would add nothing but empty rows for unused combinations).
-- COUNT(DISTINCT customer_id) is needed because one customer can place several orders in a month;
-- a plain COUNT would count orders again and overstate the number of customers.
SELECT c.region,
       o.order_month,
       COUNT(o.order_id)             AS number_of_orders,
       COUNT(DISTINCT c.customer_id) AS number_of_customers,
       SUM(o.amount)                 AS total_revenue,
       ROUND(AVG(o.amount), 2)       AS average_revenue
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
