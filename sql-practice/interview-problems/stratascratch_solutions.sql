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

-- Finding User Purchases
-- Identify returning active users by finding users who made a second purchase within 1 to 7 days after their first purchase. 
-- Ignore same-day purchases. Output a list of these user_ids.
select user_id from (select user_id, purchase_date,
row_number () over ( partition by user_id order by date(purchase_date)) as rn from 
(
select distinct user_id ,
date(created_at) as purchase_date 
from amazon_transactions 
) as distinct_dates)  as numbered 
group by user_id 
HAVING 
    COUNT(*) >= 2
    AND DATEDIFF(
      MAX(CASE WHEN rn = 2 THEN purchase_date END),
      MIN(CASE WHEN rn = 1 THEN purchase_date END)
    ) BETWEEN 1 AND 7


 -- Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.
select distinct fp.post_date,fp.post_id,fp.post_keywords,fp.post_text,fp.poster from facebook_post fp 
inner join facebook_reactions fr on fp.post_id = fr.post_id
where fr.reaction = 'Heart' ;
