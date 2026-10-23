-- Xom Data · 5 cheapest products
-- Problem: https://xomdata.com/practice/easy-limit-001
-- Solved: 2026-10-23

SELECT name, price
FROM products
ORDER BY price asc
LIMIT 5
