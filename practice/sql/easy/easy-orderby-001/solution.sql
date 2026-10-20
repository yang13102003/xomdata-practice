-- Xom Data · Active menu sorted by price
-- Problem: https://xomdata.com/practice/easy-orderby-001
-- Solved: 2026-10-20

SELECT dish_name, price
from menu
where status = 'Active'
order by price, dish_name asc
