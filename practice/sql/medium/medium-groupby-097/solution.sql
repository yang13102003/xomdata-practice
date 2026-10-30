-- Xom Data · Top 10 most-engaged posts
-- Problem: https://xomdata.com/practice/medium-groupby-097
-- Solved: 2026-10-30

WITH post_metrics AS (
    SELECT 
        p.id,
        p.user_id,
        u.full_name,
        p.post_type,
        p.post_date,
        COALESCE(p.like_count, 0) + COALESCE(p.comment_count, 0) + COALESCE(p.share_count, 0) AS total_interactions
    FROM posts p
    JOIN users u ON p.user_id = u.id
),
ranked_posts AS (
    SELECT 
        full_name,
        post_type,
        post_date,
        total_interactions,
        RANK() OVER (
            ORDER BY total_interactions DESC
        ) AS overall_rank,
        ROW_NUMBER() OVER (
            PARTITION BY user_id 
            ORDER BY total_interactions DESC, post_date::date ASC, id ASC
        ) AS rank_in_author,
        ROUND(
            100.0 * total_interactions / NULLIF(MAX(total_interactions) OVER (), 0), 
            2
        ) AS pct_of_top
    FROM post_metrics
)
SELECT 
    full_name,
    post_type,
    post_date,
    total_interactions,
    overall_rank,
    rank_in_author,
    pct_of_top
FROM ranked_posts
WHERE overall_rank <= 10
ORDER BY 
    overall_rank ASC, 
    full_name ASC, 
    rank_in_author ASC
LIMIT 10;
