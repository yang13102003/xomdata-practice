-- Xom Data · High-rated sellers with many orders
-- Problem: https://xomdata.com/practice/medium-having-019
-- Solved: 2026-10-28

WITH details as (
    SELECT s.store_name, s.reputation_score, count(o.id) as order_count, DENSE_RANK() OVER(ORDER BY count(o.id) desc) as rank_by_orders
    FROM sellers s JOIN orders o on s.id = o.seller_id
    WHERE s.reputation_score >= 4.5
    GROUP BY s.store_name, s.reputation_score, s.id
    HAVING count(o.id) >= 3
)
SELECT store_name, reputation_score, order_count, rank_by_orders, sum(order_count) over(order by order_count desc, store_name asc) as cumulative_orders
FROM details
ORDER BY rank_by_orders asc, store_name asc
