-- Xom Data · Suppliers that deliver late frequently
-- Problem: https://xomdata.com/practice/medium-having-162
-- Solved: 2026-10-29

WITH details as(
    SELECT s.supplier_name, s.material_type, count(p.id) as purchase_count, sum(p.total_value) as total_purchase_value, round(avg(p.actual_receipt::date - p.expected_receipt::date), 2) as avg_late_days, sum(CASE WHEN p.actual_receipt::date - p.expected_receipt::date <= 0 then 1 else 0 end) as on_time
    FROM suppliers s JOIN purchase_orders p on s.id = p.supplier_id
    GROUP BY s.supplier_name, s.material_type
    HAVING count(p.id) >= 3 and avg(p.actual_receipt::date - p.expected_receipt::date) > 0
)
SELECT supplier_name, material_type, purchase_count, total_purchase_value, avg_late_days, COALESCE(round(100.0 * on_time / purchase_count, 2),0) as on_time_rate, RANK() OVER(ORDER BY avg_late_days desc) as late_rank, NTILE(4) OVER(ORDER BY avg_late_days desc) as risk_tier
FROM details
ORDER BY late_rank asc, supplier_name asc
