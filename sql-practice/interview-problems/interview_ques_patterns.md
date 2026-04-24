Priority Guide — Learn These First
If you have limited time focus on these patterns first. They cover 80% of all medium and hard interview questions.

Rank	Pattern	Why it matters
1	Anti-Join / Exclusion (P8)	Appears in almost every company. Find customers who never did X.
2	Rank and Filter (P1)	Most common window function pattern. Top N per group.
3	LAG and LEAD (P3)	Compare current row to previous. Day over day changes.
4	Gaps and Islands (P10)	Hardest pattern. Consecutive sequences, login streaks.
5	Conditional Aggregation (P17)	CASE WHEN inside SUM or COUNT. Pivot without PIVOT.
6	Double Aggregation (P2)	Aggregate at individual level first then group level second.
7	Chained CTEs (P5)	Multi step complex logic. Readability and reuse.
8	Recursive CTE (P20)	Hierarchy and parent-child. Org charts, category trees.

 
All 20 Patterns

PATTERN 1    PRIORITY 1 ★★★
Rank and Filter
When to use	Find top N or bottom N rows within each group
Keywords	top, highest, lowest, most recent, latest, best performing, first, last
Used for	Top salary per department, latest order per customer, first login per user
SQL example	SELECT firstname, department, salary
FROM employees
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY department
    ORDER BY salary DESC
) = 1;
Key rule: ROW_NUMBER gives exactly 1 result per group. RANK allows ties. QUALIFY filters window function results directly in Snowflake without needing a subquery.

PATTERN 2    PRIORITY 1 ★★★
Double Aggregation
When to use	Aggregate at individual level first then group level second. Never both in one step.
Keywords	average total, total per user then average, sum of sums
Used for	Average total compensation, average order value per customer segment
SQL example	WITH per_employee AS (
    SELECT id, title, sex, salary,
           SUM(bonus) AS total_bonus
    FROM employees
    JOIN bonuses ON id = worker_ref_id
    GROUP BY id, title, sex, salary
)
SELECT title, sex,
       AVG(salary + total_bonus) AS avg_comp
FROM per_employee
GROUP BY title, sex;
Key rule: Always sum bonuses per employee first, then average across title and gender. Trying to do both in one SELECT always breaks.

PATTERN 3    PRIORITY 1 ★★★
LAG and LEAD — Row Comparison
When to use	Compare a row to the previous or next row without a self join
Keywords	previous, consecutive, change between, difference from last, day over day
Used for	Day over day revenue change, consecutive purchase detection, session duration
SQL example	SELECT user_id, date, sales,
    LAG(sales) OVER (
        PARTITION BY user_id
        ORDER BY date
    ) AS prev_sales,
    sales - LAG(sales) OVER (
        PARTITION BY user_id
        ORDER BY date
    ) AS change
FROM orders;
Key rule: LAG looks back one row. LEAD looks forward. First row always returns NULL for LAG. Use LAG(col, 1, 0) to default NULL to 0.

 
PATTERN 4    PRIORITY 1 ★★
CASE WHEN Inside Aggregate — Pivot Rows to Columns
When to use	Turn row values into separate columns using CASE WHEN inside MAX or SUM
Keywords	first and second, side by side, compare two dates per user, before and after
Used for	First and second purchase comparison, before and after metrics, monthly pivot
SQL example	SELECT user_id,
    MAX(CASE WHEN rn = 1 THEN date END) AS first_date,
    MAX(CASE WHEN rn = 2 THEN date END) AS second_date
FROM (
    SELECT user_id, date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id ORDER BY date
        ) AS rn
    FROM purchases
) ranked
GROUP BY user_id;
Key rule: MAX forces one value per group. CASE WHEN selects the correct row. This is the Amazon second purchase pattern. The outer MAX is just a trick to collapse multiple NULLs into one value.

PATTERN 5    PRIORITY 1 ★★
Chained CTEs — Multi Step Logic
When to use	Break complex problems into named steps. Each CTE does one job only.
Keywords	complex filtering, multiple conditions, build on previous result, step by step
Used for	Multi condition business reports, funnel analysis, cohort calculations
SQL example	WITH active_users AS (
    SELECT user_id
    FROM logins
    WHERE login_date >= DATEADD('day',-30,CURRENT_DATE)
),
user_revenue AS (
    SELECT user_id, SUM(amount) AS total
    FROM orders
    WHERE user_id IN (SELECT user_id FROM active_users)
    GROUP BY user_id
)
SELECT user_id, total
FROM user_revenue
WHERE total > 1000;
Key rule: Name CTEs clearly: active_users not cte1. Each CTE should be testable independently. If you can run it alone and it makes sense, it is named correctly.

PATTERN 6    PRIORITY 2 ★★
Date Calculations and Time Filtering
When to use	Work with time intervals, date truncation, and period filtering
Keywords	within 7 days, last month, monthly trend, gap between dates, last 30 days
Used for	Monthly revenue trends, users active in last 30 days, purchase within 7 days
SQL example	-- Date difference
DATEDIFF('day', start_date, end_date)

-- Truncate to month
DATE_TRUNC('month', order_date)

-- Add days
DATEADD('day', 7, order_date)

-- Filter last 30 days
WHERE order_date >= DATEADD('day',-30,CURRENT_DATE)

-- Extract month
MONTH(order_date)
Key rule: Snowflake uses DATEDIFF not DATE_DIFF. First argument is the unit string. DATE_TRUNC is the cleanest way to group by month or week.

 
PATTERN 7    PRIORITY 2 ★★
Running Totals and Moving Averages
When to use	Cumulative sums or rolling averages over ordered rows
Keywords	running total, cumulative, rolling average, growth over time, year to date
Used for	Cumulative revenue, year to date sales, rolling 7 day active users
SQL example	-- Running total across all orders
SUM(sales) OVER (
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)

-- 7 day moving average
AVG(sales) OVER (
    ORDER BY date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
)

-- Running total per customer
SUM(sales) OVER (
    PARTITION BY customer_id
    ORDER BY date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
Key rule: No PARTITION BY means one running total across all rows. With PARTITION BY it resets per group. UNBOUNDED PRECEDING means from the very first row.

PATTERN 8    PRIORITY 1 ★★★
Anti-Join — In A But Not B
When to use	Find records that exist in one set but are missing from another
Keywords	never, not in, missing from, did not, customers who never, employees without
Used for	Customers in Jan but not Feb, employees without managers, products never ordered
SQL example	-- Method 1: LEFT JOIN + IS NULL (safest)
SELECT a.user_id
FROM january_users a
LEFT JOIN february_users b
    ON a.user_id = b.user_id
WHERE b.user_id IS NULL;

-- Method 2: NOT EXISTS (best performance)
SELECT user_id FROM january_orders o
WHERE NOT EXISTS (
    SELECT 1 FROM february_orders
    WHERE user_id = o.user_id
);

-- Method 3: EXCEPT
SELECT user_id FROM january_orders
EXCEPT
SELECT user_id FROM february_orders;
Key rule: LEFT JOIN method is safest. NOT IN breaks when subquery contains NULLs. NOT EXISTS is best for performance. EXCEPT is cleanest when both sets are simple.

 
PATTERN 9    PRIORITY 2 ★★
Duplicate Detection
When to use	Find or remove duplicate rows based on one or more columns
Keywords	duplicate, repeated, more than once, same email, deduplication
Used for	Duplicate transactions, repeated emails, multiple entries per user
SQL example	-- Find duplicates
SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Remove duplicates using ROW_NUMBER
SELECT * FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY created_at DESC
        ) AS rn
    FROM users
)
WHERE rn = 1;
Key rule: GROUP BY + HAVING COUNT > 1 finds them. ROW_NUMBER + QUALIFY removes them. Keep the most recent row by ordering by created_at DESC.

PATTERN 10    PRIORITY 1 ★★★ HARDEST
Gaps and Islands
When to use	Find consecutive sequences or breaks in sequences
Keywords	consecutive, streak, continuous, in a row, daily login, uninterrupted
Used for	Login streaks, consecutive transaction days, uninterrupted service periods
SQL example	-- Step 1: Assign row number per user
WITH numbered AS (
    SELECT user_id, login_date,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY login_date
        ) AS rn
    FROM logins
),
-- Step 2: Subtract rn from date to get island group
islands AS (
    SELECT user_id, login_date,
        DATEADD('day', -rn, login_date) AS grp
    FROM numbered
)
-- Step 3: Count each island
SELECT user_id, grp,
    COUNT(*) AS streak_length,
    MIN(login_date) AS streak_start,
    MAX(login_date) AS streak_end
FROM islands
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;
Key rule: The trick: subtract row number from date. Consecutive dates produce the same result. That shared result is the island group key. This pattern is always multi-CTE.

 
PATTERN 11    PRIORITY 2 ★★
Self Join — Compare Rows Within Same Table
When to use	Join a table to itself to compare or relate rows within the same dataset
Keywords	manager, employee hierarchy, pairs, compare within same table
Used for	Employee and manager name in same row, product pairs, friend connections
SQL example	-- Employee with their manager name
SELECT 
    e.firstname AS employee,
    m.firstname AS manager,
    e.department
FROM employees e
LEFT JOIN employees m
    ON e.managerid = m.employeeid;
Key rule: Always alias the table twice with different names. Use LEFT JOIN so employees without managers still appear. Self joins are the non-recursive way to handle one level of hierarchy.

PATTERN 12    PRIORITY 2 ★★
Subquery Filter
When to use	Filter rows based on an aggregate or value calculated from another query
Keywords	above average, greater than company average, threshold based on data
Used for	Above average salary, orders above customer average, products above category average
SQL example	-- Employees above company average salary
SELECT firstname, department, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- Same result using window function (cleaner)
SELECT firstname, department, salary
FROM employees
QUALIFY salary > AVG(salary) OVER ();
Key rule: Scalar subquery returns one value. Correlated subquery references the outer query and runs once per row. Window function approach is usually cleaner in Snowflake.

 
PATTERN 13    PRIORITY 2 ★
Median and Nth Value
When to use	Find the middle value or a specific positional value in a dataset
Keywords	median, middle value, 50th percentile, Nth highest
Used for	Median salary, second highest value, 90th percentile response time
SQL example	-- Median using PERCENTILE_CONT
SELECT 
    PERCENTILE_CONT(0.5) WITHIN GROUP (
        ORDER BY salary
    ) AS median_salary
FROM employees;

-- Nth highest using ROW_NUMBER
SELECT salary FROM (
    SELECT salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
)
WHERE rnk = 2;
Key rule: PERCENTILE_CONT(0.5) is the cleanest median. For Nth highest use DENSE_RANK so ties are handled correctly. ROW_NUMBER gives Nth distinct row not Nth distinct value.

PATTERN 14    PRIORITY 3 ★
String Manipulation
When to use	Extract, clean, or transform text values
Keywords	extract, clean, split, trim, replace, domain from email, initials
Used for	Extract email domain, clean phone numbers, get first word from name
SQL example	-- Extract domain from email
SELECT email,
    SPLIT_PART(email, '@', 2) AS domain
FROM users;

-- Clean whitespace
SELECT TRIM(firstname) AS firstname FROM employees;

-- Extract substring
SELECT SUBSTRING(phone, 1, 3) AS area_code FROM contacts;

-- Replace characters
SELECT REPLACE(phone_number, '-', '') AS clean_phone
FROM contacts;
Key rule: SPLIT_PART is Snowflake specific and very useful. TRIM removes leading and trailing spaces. SUBSTRING(string, start, length) not SUBSTRING(string, start, end).

 
PATTERN 15    PRIORITY 2 ★★
Set Operations
When to use	Combine or compare results from two separate queries
Keywords	combine, merge, all records from both, in either, union, intersect
Used for	Combine old and new records, find common users, identify missing records
SQL example	-- All users from both tables no duplicates
SELECT user_id FROM table_a
UNION
SELECT user_id FROM table_b;

-- All users including duplicates
SELECT user_id FROM table_a
UNION ALL
SELECT user_id FROM table_b;

-- Users in both tables
SELECT user_id FROM table_a
INTERSECT
SELECT user_id FROM table_b;

-- Users in A but not B
SELECT user_id FROM table_a
EXCEPT
SELECT user_id FROM table_b;
Key rule: UNION removes duplicates. UNION ALL keeps all rows and is faster. Both queries must have same number of columns and compatible types. EXCEPT is the cleanest anti-join for simple cases.

PATTERN 16    PRIORITY 2 ★★
Filtering Groups with HAVING
When to use	Filter aggregated results after GROUP BY
Keywords	more than, at least, only groups where, departments with, customers who ordered more than
Used for	Active customers by order count, high revenue departments, products with low sales
SQL example	-- Customers with more than 2 orders
SELECT customerid, COUNT(*) AS order_count
FROM orders
GROUP BY customerid
HAVING COUNT(*) > 2;

-- Departments with average salary above 60000
SELECT department, AVG(salary) AS avg_sal
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;
Key rule: WHERE filters individual rows before aggregation. HAVING filters groups after aggregation. You cannot use WHERE on an aggregate function result. That is what HAVING is for.

 
PATTERN 17    PRIORITY 1 ★★★
Conditional Aggregation
When to use	Aggregate different subsets of data in the same query using CASE WHEN
Keywords	count of active vs inactive, sales by category in one row, breakdown by type
Used for	Gender breakdown, active vs inactive users, revenue by category in one row
SQL example	SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    AVG(CASE WHEN department = 'Sales' THEN salary END) AS sales_avg,
    AVG(CASE WHEN department = 'Marketing' THEN salary END) AS mkt_avg
FROM employees;
Key rule: SUM(CASE WHEN condition THEN 1 ELSE 0 END) counts matching rows. AVG(CASE WHEN condition THEN value END) averages only matching rows because NULL values are ignored by AVG.

PATTERN 18    PRIORITY 2 ★★
CASE WHEN Business Logic
When to use	Apply conditional business rules to categorise or transform values
Keywords	categorise, label, bucket, tier, classify, if this then that
Used for	Salary bands, customer tiers, order status labels, age groups
SQL example	SELECT firstname, salary,
    CASE 
        WHEN salary >= 80000 THEN 'High'
        WHEN salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_band,
    CASE department
        WHEN 'Sales' THEN 'Revenue'
        WHEN 'Marketing' THEN 'Growth'
        ELSE 'Operations'
    END AS team_type
FROM employees;
Key rule: Conditions are evaluated in order. First match wins. Always include ELSE to handle unexpected values. CASE column WHEN value is cleaner than CASE WHEN column = value for equality checks.

 
PATTERN 19    PRIORITY 2 ★★
EXISTS vs IN
When to use	Filter rows based on existence of related records in another table
Keywords	has at least one, exists in, linked to, associated with
Used for	Customers who placed orders, products with reviews, users with active sessions
SQL example	-- IN: simple, readable
SELECT * FROM customers
WHERE customerid IN (
    SELECT customerid FROM orders
);

-- EXISTS: better performance for large datasets
SELECT * FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customerid = c.customerid
);

-- NOT EXISTS: anti-join equivalent
SELECT * FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customerid = c.customerid
);
Key rule: EXISTS stops at first match making it faster. IN evaluates the whole subquery. NOT IN breaks with NULLs in subquery so prefer NOT EXISTS for anti-join. SELECT 1 in EXISTS is a convention not a requirement.

PATTERN 20    PRIORITY 1 ★★★
Recursive CTE — Hierarchy
When to use	Traverse parent-child relationships of unknown depth
Keywords	hierarchy, org chart, manager chain, parent category, tree structure, levels deep
Used for	Employee org chart, category trees, bill of materials, folder structures
SQL example	WITH RECURSIVE hierarchy AS (
    -- Anchor: start from top
    SELECT employeeid, firstname,
           managerid, 1 AS level
    FROM employees
    WHERE managerid IS NULL

    UNION ALL

    -- Recursive: add each child
    SELECT e.employeeid, e.firstname,
           e.managerid, h.level + 1
    FROM employees e
    JOIN hierarchy h
        ON e.managerid = h.employeeid
)
SELECT * FROM hierarchy
ORDER BY level;
Key rule: Anchor query runs once and gets the root rows. Recursive part joins back to the CTE itself and runs repeatedly until no new rows are found. Level counter tracks depth. Always test with your employees table first.

 
Quick Reference — All 20 Patterns
Use this table to identify which pattern a problem needs before writing any SQL.

Top N per group	Pattern 1	Average of sums	Pattern 2
Previous row compare	Pattern 3	Rows to columns	Pattern 4
Multi step logic	Pattern 5	Time gaps and ranges	Pattern 6
Running totals	Pattern 7	In A but not B	Pattern 8
Duplicate detection	Pattern 9	Gaps and islands	Pattern 10
Self join / hierarchy	Pattern 11	Subquery filter	Pattern 12
Median / Nth value	Pattern 13	String manipulation	Pattern 14
Set operations	Pattern 15	Filtering groups	Pattern 16
Conditional aggregation	Pattern 17	Case based logic	Pattern 18
Exists vs IN	Pattern 19	Recursive CTE	Pattern 20

Key Rules to Remember

Before writing any SQL: identify which pattern the problem needs. Then the solution becomes mechanical.

1	WHERE filters rows. HAVING filters groups. QUALIFY filters window function results.
2	UNION removes duplicates. UNION ALL keeps all rows and is faster.
3	NOT IN breaks with NULLs in subquery. Use NOT EXISTS or LEFT JOIN IS NULL instead.
4	ROW_NUMBER gives unique ranks. RANK skips numbers after ties. DENSE_RANK never skips.
5	Aggregate at individual level first before aggregating at group level.
6	CTE lives for one query only. Temp table persists for the entire session.
7	PARTITION BY resets calculation per group. No PARTITION BY means whole table.
8	Gaps and islands trick: subtract row number from date. Same result equals same island.
9	PERCENTILE_CONT(0.5) is the cleanest way to get median in Snowflake.
10	QUALIFY is Snowflake specific. It replaces the need for a subquery to filter window results.

