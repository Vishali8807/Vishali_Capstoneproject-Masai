-- Business question: which orders are still pending, so the team can chase them?
SELECT o.order_id, o.customer_id, o.item, o.amount
FROM orders AS o
WHERE o.status = 'pending'
ORDER BY o.order_id ASC;
