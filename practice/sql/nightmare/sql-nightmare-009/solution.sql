-- Xom Data · Conversion rate through a 4-step purchase funnel
-- Problem: https://xomdata.com/practice/sql-nightmare-009
-- Solved: 2026-10-23

WITH funnel_counts AS (
    SELECT 
        event AS step,
        COUNT(DISTINCT user_id) AS users,
        CASE event
            WHEN 'visit' THEN 1
            WHEN 'cart' THEN 2
            WHEN 'checkout' THEN 3
            WHEN 'payment' THEN 4
        END AS step_order
    FROM funnel_events
    WHERE event IN ('visit', 'cart', 'checkout', 'payment')
    GROUP BY event
)
SELECT 
    step,
    users,
    ROUND(
        users * 100.0 / NULLIF(FIRST_VALUE(users) OVER (ORDER BY step_order), 0), 
        2
    ) AS pct_of_total,
    ROUND(
        users * 100.0 / NULLIF(LAG(users) OVER (ORDER BY step_order), 0), 
        2
    ) AS pct_of_prev
FROM funnel_counts
ORDER BY step_order ASC;
