-- Xom Data · Consultation revenue by doctor
-- Problem: https://xomdata.com/practice/medium-join-141
-- Solved: 2026-11-01

WITH doctor_stats AS (
    SELECT 
        d.id AS doctor_id,
        d.faculty_id,
        f.faculty_name,
        d.full_name AS doctor_name,
        COUNT(mv.id) AS visit_count,
        ROUND(AVG(mv.visit_fee), 2) AS avg_exam_fee,
        SUM(mv.visit_fee) AS total_exam_fee
    FROM doctors d
    JOIN faculties f ON d.faculty_id = f.id
    JOIN medical_visits mv ON d.id = mv.doctor_id
    GROUP BY d.id, d.faculty_id, f.faculty_name, d.full_name
)
SELECT 
    faculty_name,
    doctor_name,
    visit_count,
    avg_exam_fee,
    total_exam_fee,
    RANK() OVER (
        ORDER BY total_exam_fee DESC
    ) AS overall_rank,
    DENSE_RANK() OVER (
        PARTITION BY faculty_id 
        ORDER BY total_exam_fee DESC
    ) AS rank_in_faculty
FROM doctor_stats
ORDER BY 
    total_exam_fee DESC, 
    doctor_name ASC
LIMIT 15;
