-- Xom Data · Top 5 highest-paid employees
-- Problem: https://xomdata.com/practice/easy-limit-004
-- Solved: 2026-10-23

SELECT full_name, salaries
FROM employees
ORDER BY salaries DESC NULLS LAST
LIMIT 5
