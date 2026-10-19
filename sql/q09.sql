-- Business question: one order-level fact table with customer, region and rep attached (input to Part B).
SELECT o.order_id,
       o.order_month,
       c.first_name,
       c.last_name,
       c.region,
       r.rep_name,
       o.item,
       o.quantity,
       o.status,
       o.amount
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
INNER JOIN reps AS r ON c.rep_id = r.rep_id
ORDER BY o.order_id;
