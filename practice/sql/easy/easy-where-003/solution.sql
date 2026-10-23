-- Xom Data · Delivered orders
-- Problem: https://xomdata.com/practice/easy-where-003
-- Solved: 2026-10-23

SELECT order_code, customers, total_amount
from orders
where status = 'Delivered'
ORDER BY id
