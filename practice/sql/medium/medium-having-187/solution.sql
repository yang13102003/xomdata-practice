-- Xom Data · Players with 3 or more goals
-- Problem: https://xomdata.com/practice/medium-having-187
-- Solved: 2026-10-29

WITH goal_stats AS (
    SELECT 
        player_id,
        COUNT(id) AS goal_count,
        COUNT(DISTINCT match_id) AS scoring_matches,
        ROUND(COUNT(id)::NUMERIC / NULLIF(COUNT(DISTINCT match_id), 0), 2) AS goals_per_match
    FROM goals
    GROUP BY player_id
    HAVING COUNT(id) >= 3
),
penalty_stats AS (
    SELECT 
        player_id,
        COUNT(id) AS cards_received
    FROM penalties
    GROUP BY player_id
)
SELECT 
    p.full_name,
    p.positions,
    t.team_name,
    g.goal_count,
    g.scoring_matches,
    COALESCE(pen.cards_received, 0) AS cards_received,
    g.goals_per_match,
    DENSE_RANK() OVER (ORDER BY g.goals_per_match DESC) AS efficiency_rank,
    RANK() OVER (ORDER BY g.goal_count DESC) AS volume_rank
FROM players p
JOIN teams t 
    ON p.team_id = t.id
JOIN goal_stats g 
    ON p.id = g.player_id
LEFT JOIN penalty_stats pen 
    ON p.id = pen.player_id
WHERE COALESCE(pen.cards_received, 0) < 5
ORDER BY 
    efficiency_rank ASC, 
    p.full_name ASC;
