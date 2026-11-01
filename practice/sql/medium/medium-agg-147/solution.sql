-- Xom Data · Top 10 highest-profit dishes
-- Problem: https://xomdata.com/practice/medium-agg-147
-- Solved: 2026-11-01

WITH dish_sales AS (
    SELECT 
        d.id,
        d.dish_name,
        c.category_name,
        SUM(oi.quantity) AS total_sold,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        SUM(oi.quantity * (oi.unit_price - d.cost_price)) AS profit
    FROM dishes d
    JOIN categories c ON d.category_id = c.id
    JOIN order_items oi ON d.id = oi.dish_id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status = 'Completed'
    GROUP BY d.id, d.dish_name, c.category_name
),
dish_metrics AS (
    SELECT 
        dish_name,
        category_name,
        total_sold,
        revenue,
        profit,
        ROUND(100.0 * profit / NULLIF(revenue, 0), 2) AS margin_pct
    FROM dish_sales
)
SELECT 
    dish_name,
    category_name,
    total_sold,
    revenue,
    profit,
    margin_pct,
    RANK() OVER (ORDER BY profit DESC) AS rank_by_profit,
    RANK() OVER (ORDER BY margin_pct DESC) AS rank_by_margin
FROM dish_metrics
ORDER BY 
    profit DESC, 
    dish_name ASC
LIMIT 10;
