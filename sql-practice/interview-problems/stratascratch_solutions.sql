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

/*We have a table with employees and their salaries; however, some of the records are old and contain outdated salary information. 
Since there is no timestamp, assume salary is non-decreasing over time. You can consider the current salary for an employee is the largest salary value among their records. 
If multiple records share the same maximum salary, return any one of them. 
Output their id, first name, last name, department ID, and current salary. Order your list by employee ID in ascending order.*/
select id,first_name,last_name,department_id,salary from
(select distinct salary ,id,first_name,last_name,department_id,
row_number() over (partition by id  order by salary DESC ,department_id DESC  ) as rn 
from ms_employee_salary) a where a.rn < 2 

-- Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.
select o.cust_id,c.first_name,sum(o.total_order_cost) from 
customers c inner join  orders o on c.id = o.cust_id
group by c.id
order by c.first_name desc ;

-- Find the average total compensation based on employee titles and gender. Total compensation is calculated by adding both the salary and bonus of each employee. However, not every employee receives a bonus so disregard employees without bonuses in your calculation. Employee can receive more than one bonus.
-- Output the employee title, gender (i.e., sex), along with the average total compensation.

WITH bonus_per_employee AS (
    SELECT 
        se.id,
        se.employee_title,
        se.sex,
        se.salary,
        SUM(sb.bonus) AS total_bonus
    FROM sf_employee se
    INNER JOIN sf_bonus sb ON se.id = sb.worker_ref_id
    GROUP BY se.id, se.employee_title, se.sex, se.salary
),
total_compensation AS (
    SELECT
        employee_title,
        sex,
        salary + total_bonus AS total_comp
    FROM bonus_per_employee
)
SELECT
    employee_title,
    sex,
    AVG(total_comp) AS avg_total_compensation
FROM total_compensation
GROUP BY employee_title, sex;


/*You are given a set of projects and employee data. Each project has a name, a budget, and a specific duration, while each employee has an annual salary and may be assigned to one or more projects for particular periods. 
The task is to identify which projects are overbudget. A project is considered overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.
To solve this, you must prorate each employee's annual salary based on the exact period they work on a given project, relative to a full year. 
For example, if an employee works on a six-month project, only half of their annual salary should be attributed to that project. 
Sum these prorated salary amounts for all employees assigned to a project and compare the total with the project’s budget.
Your output should be a list of overbudget projects, where each entry includes the project’s name, its budget, and the total prorated employee expenses for that project. 
The total expenses should be rounded up to the nearest dollar. Assume all years have 365 days and disregard leap years.*/

SELECT a.title,
  a.budget,
CEILING(DATEDIFF(a.end_date, a.start_date) *  SUM(c.salary) / 365) AS prorated_employee_expense

FROM linkedin_projects a
INNER JOIN linkedin_emp_projects b ON a.id = b.project_id
INNER JOIN linkedin_employees c ON b.emp_id = c.id
GROUP BY a.title,
    a.budget,
    a.end_date,
    a.start_date
HAVING CEILING(DATEDIFF(a.end_date, a.start_date) * 
  SUM(c.salary) / 365) > a.budget
ORDER BY a.title ASC;


