-- Xom Data · Average score per subject
-- Problem: https://xomdata.com/practice/medium-groupby-027
-- Solved: 2026-10-27

WITH subject_stats AS (
    SELECT 
        s.subject_name,
        s.credits,
        COUNT(g.id) AS student_count,
        ROUND(AVG(g.final_score), 2) AS avg_score,
        ROUND(
            100.0 * COUNT(CASE WHEN g.final_score >= 5 THEN 1 END) / COUNT(g.id), 
            2
        ) AS pass_rate
    FROM subjects s
    JOIN grades g ON s.id = g.subject_id
    GROUP BY s.id, s.subject_name, s.credits
)
SELECT 
    subject_name,
    credits,
    student_count,
    avg_score,
    pass_rate,
    RANK() OVER (ORDER BY avg_score DESC) AS rank_by_avg,
    NTILE(4) OVER (ORDER BY avg_score DESC, subject_name ASC) AS difficulty_quartile
FROM subject_stats
ORDER BY rank_by_avg ASC, subject_name ASC;
