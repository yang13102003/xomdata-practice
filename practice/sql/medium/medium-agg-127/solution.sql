-- Xom Data · Top 10 highest-paid employees and their leave days
-- Problem: https://xomdata.com/practice/medium-agg-127
-- Solved: 2026-11-03

WITH emp_payroll AS (
    SELECT 
        employee_id,
        SUM(net_salary) AS total_received_salary
    FROM payroll
    GROUP BY employee_id
),
emp_leaves AS (
    SELECT 
        employee_id,
        COUNT(id) AS leave_count
    FROM leaves
    WHERE status = 'approved'
    GROUP BY employee_id
),
emp_metrics AS (
    SELECT 
        e.id,
        e.full_name,
        e.employee_code,
        e.department_id,
        d.department_name,
        COALESCE(ep.total_received_salary, 0) AS total_received_salary,
        COALESCE(el.leave_count, 0) AS leave_count,
        AVG(COALESCE(ep.total_received_salary, 0)) OVER (PARTITION BY e.department_id) AS dept_avg_salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.id
    LEFT JOIN emp_payroll ep ON e.id = ep.employee_id
    LEFT JOIN emp_leaves el ON e.id = el.employee_id
)
SELECT 
    full_name,
    employee_code,
    department_name,
    total_received_salary,
    leave_count,
    ROUND(
        (total_received_salary - dept_avg_salary) * 100.0 / NULLIF(dept_avg_salary, 0), 
        2
    ) AS pct_above_dept_avg
FROM emp_metrics
ORDER BY 
    total_received_salary DESC, 
    employee_code ASC
LIMIT 10;
