-- Xom Data · Showtime count and average ticket price per film
-- Problem: https://xomdata.com/practice/medium-join-076
-- Solved: 2026-10-31

WITH movie_stats AS (
    SELECT 
        m.id,
        m.movie_name,
        m.genres,
        COUNT(s.id) AS showtime_count,
        ROUND(AVG(s.ticket_price), 0) AS avg_ticket_price
    FROM movies m
    JOIN showtimes s ON m.id = s.movie_id
    GROUP BY m.id, m.movie_name, m.genres
)
SELECT 
    movie_name,
    genres,
    showtime_count,
    avg_ticket_price,
    DENSE_RANK() OVER (
        PARTITION BY genres 
        ORDER BY avg_ticket_price DESC
    ) AS rank_in_genre,
    FIRST_VALUE(movie_name) OVER (
        PARTITION BY genres 
        ORDER BY avg_ticket_price DESC, movie_name ASC
    ) AS top_movie_in_genre
FROM movie_stats
ORDER BY 
    genres ASC, 
    rank_in_genre ASC, 
    movie_name ASC;
