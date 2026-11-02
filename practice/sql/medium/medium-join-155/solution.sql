-- Xom Data · Rank hotels by room price within each destination
-- Problem: https://xomdata.com/practice/medium-join-155
-- Solved: 2026-11-02

WITH hotel_metrics AS (
    SELECT 
        h.id AS hotel_id,
        h.hotel_name,
        h.star_class,
        d.id AS destination_id,
        d.destination_name,
        COUNT(r.id) AS room_count,
        MIN(r.nightly_rate) AS min_price,
        MAX(r.nightly_rate) AS max_price,
        ROUND(AVG(r.nightly_rate), 2) AS avg_price,
        MAX(r.nightly_rate) - MIN(r.nightly_rate) AS price_spread
    FROM hotels h
    INNER JOIN destinations d 
        ON h.destination_id = d.id
    INNER JOIN hotel_rooms r 
        ON h.id = r.hotel_id
    GROUP BY 
        h.id, 
        h.hotel_name, 
        h.star_class, 
        d.id, 
        d.destination_name
    HAVING COUNT(r.id) >= 2
)
SELECT 
    hotel_name,
    star_class,
    destination_name,
    room_count,
    min_price,
    max_price,
    avg_price,
    price_spread,
    RANK() OVER (
        PARTITION BY destination_id 
        ORDER BY avg_price DESC
    ) AS rank_in_destination
FROM hotel_metrics
ORDER BY 
    destination_name ASC,
    rank_in_destination ASC,
    hotel_name ASC;
