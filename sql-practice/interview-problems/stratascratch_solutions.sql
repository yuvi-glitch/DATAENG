-- =====================================================
-- Problem: Most Engaged Airbnb Guests
-- Platform: StrataScratch | Company: Airbnb | Difficulty: Medium
-- Concepts: CTE, SUM aggregation, DENSE_RANK
-- Status: Solved with correction
-- Mistake made: Used COUNT instead of SUM for n_messages
-- =====================================================

WITH cte AS (
    SELECT 
        id_guest,
        SUM(n_messages) AS total_messages
    FROM airbnb_contacts
    GROUP BY id_guest
)
SELECT 
    DENSE_RANK() OVER (ORDER BY total_messages DESC) AS rnk,
    id_guest,
    total_messages
FROM cte
ORDER BY rnk;
