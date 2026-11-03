-- Xom Data · Top 10 most-borrowed books
-- Problem: https://xomdata.com/practice/medium-subquery-198
-- Solved: 2026-11-03

WITH loan_counts AS (
    SELECT 
        book_id, 
        COUNT(id) AS borrow_count
    FROM book_loans
    GROUP BY book_id
),
reservation_counts AS (
    SELECT 
        book_id, 
        COUNT(id) AS pending_reservation
    FROM reservations
    WHERE status = 'ready_pickup'
    GROUP BY book_id
),
book_engagement AS (
    SELECT 
        b.id,
        b.title,
        a.full_name AS authors,
        p.publisher_name,
        g.genre_name,
        lc.borrow_count,
        COALESCE(rc.pending_reservation, 0) AS pending_reservation,
        lc.borrow_count + COALESCE(rc.pending_reservation, 0) AS engagement
    FROM books b
    INNER JOIN loan_counts lc ON b.id = lc.book_id
    INNER JOIN authors a ON b.author_id = a.id
    INNER JOIN publishers p ON b.publisher_id = p.id
    INNER JOIN genres g ON b.genre_id = g.id
    LEFT JOIN reservation_counts rc ON b.id = rc.book_id
)
SELECT 
    title,
    authors,
    publisher_name,
    genre_name,
    borrow_count,
    pending_reservation,
    engagement,
    DENSE_RANK() OVER (ORDER BY engagement DESC) AS overall_rank,
    RANK() OVER (PARTITION BY genre_name ORDER BY engagement DESC) AS rank_in_genre
FROM book_engagement
ORDER BY 
    overall_rank ASC, 
    title ASC
LIMIT 10;
