/*Level 3 — Recursive CTEs (Hard)
Problem 7
Write a recursive CTE to build the employee hierarchy. Start from the top level manager (managerid is NULL) and show each employee with their level in the hierarchy.
Expected output:
Frank Lee    — Level 1 (top manager)
Kevin Brown  — Level 2 (reports to Frank)
Mary         — Level 2 (reports to Frank)
Michael Ray  — Level 3 (reports to Kevin)
Carol Baker  — Level 3 (reports to Mary)*/

with recursive cte as (
select employeeid, firstname, lastname, department, birthdate, gender, salary, managerid, 1 as lvl
from employees where managerid is null 
union all 
select e.employeeid, e.firstname, e.lastname, e.department, e.birthdate, e.gender, e.salary, e.managerid, c.lvl + 1
from employees e join cte c on e.managerid = c.employeeid
) select concat(firstname,' ',lastname) as name, lvl from cte ;

/*Problem 8
Extend Problem 7 to show the full management chain for each employee as a string. Like:
Carol Baker — Frank Lee > Mary > Carol Baker*/

with recursive cte as (
select employeeid, firstname, lastname, department, birthdate, gender, salary, managerid, 1 as lvl , concat ( firstname, ' ' ,lastname) as path 
from employees where managerid is null 
union all 
select e.employeeid, e.firstname, e.lastname, e.department, e.birthdate, e.gender, e.salary, e.managerid, c.lvl + 1, concat(c.path ,'>' ,e.firstname,' ',e.lastname) as path 
from employees e join cte c on e.managerid = c.employeeid
) select path from cte;

/*Problem 9
Using a recursive CTE generate a sequence of numbers from 1 to 10 without using any table. Just the recursive CTE itself.*/

WITH RECURSIVE cte AS (
    -- Anchor
    SELECT 0 AS num
    UNION ALL
    -- Recursive par
    SELECT num +1
    FROM cte
    WHERE num < 10 
)
SELECT * FROM cte;
