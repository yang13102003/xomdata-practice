-- Xom Data · Instructor teaching load
-- Problem: https://xomdata.com/practice/medium-join-029
-- Solved: 2026-10-31

WITH lecturer_workload AS (
    SELECT 
        l.id,
        l.full_name,
        l.academic_degree,
        COUNT(s.id) AS subjects_taught
    FROM lecturers l
    LEFT JOIN subjects s ON l.id = s.lecturer_id
    GROUP BY l.id, l.full_name, l.academic_degree
)
SELECT 
    full_name,
    academic_degree,
    subjects_taught,
    RANK() OVER (
        ORDER BY subjects_taught DESC
    ) AS workload_rank,
    SUM(subjects_taught) OVER (
        ORDER BY subjects_taught DESC, full_name ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_subjects
FROM lecturer_workload
ORDER BY 
    workload_rank ASC, 
    full_name ASC;
