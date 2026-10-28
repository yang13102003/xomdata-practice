-- Xom Data · Employees averaging over 5 overtime hours
-- Problem: https://xomdata.com/practice/medium-having-128
-- Solved: 2026-10-28

WITH
  details AS (
    SELECT
      e.full_name,
      e.employee_code,
      AVG(a.work_days) AS avg_work_days,
      AVG(a.overtime_hours) AS avg_overtime_hours,
      AVG(p.net_salary) as avg_salary,
      round(AVG(a.overtime_hours) / AVG(a.work_days), 4) as overtime_intensity
      FROM employees e JOIN attendance a on e.id = a.employee_id
      JOIN payroll p on e.id = p.employee_id
      GROUP BY e.full_name, e.employee_code
      HAVING AVG(a.work_days) >= 18 and AVG(a.overtime_hours) > 5
  )
  SELECT full_name, employee_code, avg_work_days, avg_overtime_hours, avg_salary, overtime_intensity, RANK() over(ORDER BY overtime_intensity desc, employee_code asc) as intensity_rank, NTILE(4) over(ORDER BY overtime_intensity desc) as workload_quartile
  FROM details
  ORDER BY intensity_rank asc, employee_code asc
