-- Xom Data · Types of bank accounts
-- Problem: https://xomdata.com/practice/easy-distinct-006
-- Solved: 2026-10-20

SELECT DISTINCT(account_type)
from accounts
order by account_type asc
