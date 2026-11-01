-- Xom Data · Salary by department and title
-- Problem: https://xomdata.com/practice/medium-join-126
-- Solved: 2026-11-01

WITH dept_pos_stats AS (
    SELECT 
        d.id AS dept_id,
        d.department_name,
        p.position_name,
        COUNT(DISTINCT e.id) AS employee_count,
        ROUND(AVG(pr.net_salary), 2) AS avg_salary,
        MIN(pr.net_salary) AS min_salary,
        MAX(pr.net_salary) AS max_salary
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    JOIN positions p ON e.position_id = p.id
    JOIN payroll pr ON e.id = pr.employee_id
    GROUP BY d.id, d.department_name, p.id, p.position_name
)
SELECT 
    department_name,
    position_name,
    employee_count,
    avg_salary,
    min_salary,
    max_salary,
    (max_salary - min_salary) AS salary_spread,
    RANK() OVER (
        PARTITION BY dept_id 
        ORDER BY avg_salary DESC
    ) AS rank_in_dept
FROM dept_pos_stats
ORDER BY 
    department_name ASC, 
    rank_in_dept ASC, 
    position_name ASC;
