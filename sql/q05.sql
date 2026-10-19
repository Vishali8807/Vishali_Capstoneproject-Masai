-- Business question: what are the headline KPIs across completed orders?
SELECT COUNT(o.order_id)           AS total_orders,
       SUM(o.amount)               AS total_revenue,
       ROUND(AVG(o.amount), 2)     AS avg_order_value,
       MIN(o.amount)               AS min_order_value,
       MAX(o.amount)               AS max_order_value
FROM orders AS o
WHERE o.status = 'completed';
