-- Xom Data · Classify student academic performance
-- Problem: https://xomdata.com/practice/medium-case-124
-- Solved: 2026-10-23

WITH student_score AS(
    SELECT s.full_name, s.student_code, round(AVG(sc.final_score),2) as avg_score
    FROM students s LEFT JOIN scores sc on s.id = sc.student_id
    GROUP BY s.full_name, s.student_code
)
SELECT full_name, student_code, avg_score,
    CASE
        WHEN avg_score >= 9 then 'Excellent'
        WHEN avg_score >= 8 then 'Good'
        WHEN avg_score >= 7 then 'Fair'
        WHEN avg_score >= 5 then 'Average'
        ELSE 'Poor'
    END AS grade,
    DENSE_RANK() OVER(ORDER BY avg_score desc) as class_rank
FROM student_score
ORDER BY avg_score desc, student_code asc NULLS LAST
limit 20
