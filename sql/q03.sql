-- Business question: what are the five biggest completed orders by amount?
SELECT o.order_id, o.customer_id, o.item, o.amount
FROM orders AS o
WHERE o.status = 'completed'
ORDER BY o.amount DESC, o.order_id ASC
LIMIT 5;
