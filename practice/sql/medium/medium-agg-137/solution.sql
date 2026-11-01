-- Xom Data · Investor trade summary
-- Problem: https://xomdata.com/practice/medium-agg-137
-- Solved: 2026-11-01

WITH investor_summary AS (
    SELECT 
        i.id,
        i.full_name,
        i.segment,
        COUNT(t.id) AS total_trades,
        SUM(CASE WHEN t.side = 'buy' THEN t.amount ELSE 0 END) AS total_bought,
        SUM(CASE WHEN t.side = 'sell' THEN t.amount ELSE 0 END) AS total_sold
    FROM investors i
    JOIN trades t ON i.id = t.investor_id
    GROUP BY i.id, i.full_name, i.segment
)
SELECT 
    full_name,
    segment,
    total_trades,
    total_bought,
    total_sold,
    (total_bought - total_sold) AS net_position,
    CASE 
        WHEN total_bought > total_sold THEN 'Bull'
        WHEN total_bought < total_sold THEN 'Bear'
        ELSE 'Neutral'
    END AS stance,
    DENSE_RANK() OVER (
        PARTITION BY segment 
        ORDER BY (total_bought + total_sold) DESC
    ) AS rank_in_segment
FROM investor_summary
ORDER BY 
    (total_bought + total_sold) DESC, 
    full_name ASC;
