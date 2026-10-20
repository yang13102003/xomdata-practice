-- Xom Data · Top 3 highest-value orders
-- Problem: https://xomdata.com/practice/easy-limit-002
-- Solved: 2026-10-20

SELECT order_code, customers, total_amount
from orders
order by total_amount desc
limit 3
