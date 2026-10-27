-- Xom Data · Transaction count and amount by month
-- Problem: https://xomdata.com/practice/medium-datefunction-045
-- Solved: 2026-10-27

WITH trans_m as(
SELECT DATE_TRUNC('month', transaction_date::date)::date as trans_month, id, amount
FROM transactions
)
SELECT TO_CHAR(trans_month,'YYYY-MM') as month, count(id) as transaction_count, sum(amount) as total_amount, sum(amount) - NULLIF(LAG(sum(amount)) OVER(ORDER BY trans_month asc),0) as mom_delta
FROM trans_m
GROUP BY trans_month
