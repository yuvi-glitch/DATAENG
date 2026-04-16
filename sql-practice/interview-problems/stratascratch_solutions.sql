-- =====================================================
-- Problem: Most Engaged Airbnb Guests
-- Platform: StrataScratch | Company: Airbnb | Difficulty: Medium
-- Concepts: CTE, SUM aggregation, DENSE_RANK
-- Status: Solved with correction
-- Mistake made: Used COUNT instead of SUM for n_messages
-- =====================================================

-- solution 
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



-- 2nd problem 
-- Number Of Units Per Nationality
-- Write a query that returns how many different apartment-type units (counted by distinct unit_id) are owned by people under 30,
-- grouped by their nationality. Sort the results by the number of apartments in descending order.

-- solution 
select count(distinct unit_id),h.nationality from  
airbnb_units u join airbnb_hosts h on h.host_id = u.host_id
where age < 30 AND u.unit_type = 'Apartment'
group by h.nationality
order by count(unit_id) desc
