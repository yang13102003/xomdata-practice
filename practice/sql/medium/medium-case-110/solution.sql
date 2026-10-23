-- Xom Data · Classify products by sales velocity
-- Problem: https://xomdata.com/practice/medium-case-110
-- Solved: 2026-10-23

WITH product_sales as(
    SELECT p.id, p.categories, p.name,
    COALESCE(sum(t.quantity),0) as total_sold
    FROM products p LEFT JOIN transactions t on p.id = t.product_id
    GROUP BY p.id, p.categories, p.name
)
SELECT name, categories, total_sold,
    CASE
        WHEN total_sold >= 100 then 'Best Seller'
        WHEN total_sold >= 50 then 'Average'
        ELSE 'Slow Mover'
    END AS classification,
    DENSE_RANK() OVER(PARTITION BY categories ORDER BY total_sold DESC) as rank_in_cat,
    ROUND(
        total_sold * 100.0 / NULLIF(SUM(total_sold) OVER (PARTITION BY categories), 0), 
        2
    ) as pct_of_cat_total
FROM product_sales
ORDER BY categories asc, rank_in_cat asc, name ASC
