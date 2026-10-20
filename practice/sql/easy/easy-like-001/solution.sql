-- Xom Data · Basic-plan subscribers
-- Problem: https://xomdata.com/practice/easy-like-001
-- Solved: 2026-10-20

SELECT phone_number, full_name, plans
from subscribers
where plans ILIKE '%basic%'
order by full_name
