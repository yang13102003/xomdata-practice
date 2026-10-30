-- Xom Data · Stock-in history by supplier
-- Problem: https://xomdata.com/practice/medium-join-014
-- Solved: 2026-10-30

WITH warehouse_stats AS (
    SELECT 
        w.id,
        w.warehouse_name,
        COUNT(si.id) AS import_count,
        COUNT(DISTINCT si.product_id) AS distinct_product_count,
        COUNT(DISTINCT si.suppliers) AS distinct_supplier_count,
        MAX(si.import_date::date) AS last_import_date
    FROM warehouses w
    JOIN stock_imports si ON w.id = si.warehouse_id
    GROUP BY w.id, w.warehouse_name
)
SELECT 
    warehouse_name,
    import_count,
    distinct_product_count,
    distinct_supplier_count,
    last_import_date,
    RANK() OVER (
        ORDER BY import_count DESC
    ) AS activity_rank,
    LAG(warehouse_name) OVER (
        ORDER BY import_count DESC, warehouse_name ASC
    ) AS prev_warehouse
FROM warehouse_stats
ORDER BY 
    activity_rank ASC, 
    warehouse_name ASC;
