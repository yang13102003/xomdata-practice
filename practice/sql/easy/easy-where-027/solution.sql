-- Xom Data · Top-scoring players
-- Problem: https://xomdata.com/practice/easy-where-027
-- Solved: 2026-10-23

SELECT full_name, goals_scored
FROM players
WHERE goals_scored > 10
ORDER BY goals_scored desc
