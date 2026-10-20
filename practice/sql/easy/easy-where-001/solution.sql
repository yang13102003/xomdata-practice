-- Xom Data · Filter products by category
-- Problem: https://xomdata.com/practice/easy-where-001
-- Solved: 2026-10-20

SELECT name, price, categories
from products
WHERE categories = 'Electronics'
ORDER BY name
