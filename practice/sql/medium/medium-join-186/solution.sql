-- Xom Data · Goals and cards by team
-- Problem: https://xomdata.com/practice/medium-join-186
-- Solved: 2026-11-02

WITH player_stats AS (
    SELECT 
        p.id AS player_id,
        p.team_id,
        COALESCE(g.goal_cnt, 0) AS goals,
        COALESCE(pen.penalty_cnt, 0) AS penalties
    FROM players p
    LEFT JOIN (
        SELECT player_id, COUNT(id) AS goal_cnt 
        FROM goals 
        GROUP BY player_id
    ) g ON p.id = g.player_id
    LEFT JOIN (
        SELECT player_id, COUNT(id) AS penalty_cnt 
        FROM penalties 
        GROUP BY player_id
    ) pen ON p.id = pen.player_id
),
team_metrics AS (
    SELECT 
        t.id AS team_id,
        t.team_name,
        t.city,
        COUNT(ps.player_id) AS player_count,
        COALESCE(SUM(ps.goals), 0) AS total_goals_scored,
        COALESCE(SUM(ps.penalties), 0) AS penalty_count,
        ROUND(
            COALESCE(SUM(ps.goals) * 1.0 / NULLIF(COUNT(ps.player_id), 0), 0), 
            2
        ) AS goals_per_player,
        ROUND(
            COALESCE(SUM(ps.penalties) * 1.0 / NULLIF(COUNT(ps.player_id), 0), 0), 
            2
        ) AS cards_per_player
    FROM teams t
    LEFT JOIN player_stats ps 
        ON t.id = ps.team_id
    GROUP BY 
        t.id, 
        t.team_name, 
        t.city
)
SELECT 
    team_name,
    city,
    player_count,
    total_goals_scored,
    penalty_count,
    goals_per_player,
    cards_per_player,
    RANK() OVER (
        ORDER BY total_goals_scored DESC
    ) AS scoring_rank,
    SUM(total_goals_scored) OVER (
        ORDER BY total_goals_scored DESC, team_name ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_goals
FROM team_metrics
ORDER BY 
    scoring_rank ASC,
    team_name ASC;
