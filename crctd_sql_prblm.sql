-- Rules
-- Problems 1 to 6 use regular CTEs only
-- Problems 7 to 10 use recursive CTEs — these are harder, take your time

/*Level 1 — CTE Basics (Warm Up)
Problem 1
Using a CTE, find all employees whose salary is above the company average. Show firstname, department, salary and the company average salary alongside each row.*/
with cte as (
select * , avg(salary) over() as avgs from employees
) select * from cte where salary > avgs;

/*Problem 2
Using a CTE, find the total sales per customer. Then from that result show only customers whose total sales exceed 50. Show customerid and their total sales.*/

with cte as (
select customerid ,sum(sales) tot from orders
group by customerid
) select * from cte where tot >50;

/*Problem 3
Using a CTE, find the most expensive product in each category. Show category, product name and price.*/
with cte as (
select category,product,price, rank() over(partition by category order by price desc) as rn
from products
) select category,product,price from cte where rn = 1;


/*Level 2 — Multiple CTEs (Medium)
Problem 4
Write a query using two CTEs:
First CTE: calculate total sales per salesperson
Second CTE: calculate average sales across all salespersons
Then show only salespersons who performed above the average. Show employeeid and their total sales.*/

with cte as (
select sum(sales) over ( partition by salespersonid) as tot , avg(sales) over ( partition by salespersonid) as avgs,sales,salespersonid  from orders
) select salespersonid,tot from cte where sales >avgs ;

with total_sales as (
select salespersonid, sum(sales) as totsale from orders
group by salespersonid 
),
average_sales as(
select avg(totsale) as avgs from total_sales
) select * from total_sales where totsale >(select avgs from average_sales);

/*Problem 5
Write a query using two CTEs:
First CTE: get the latest order date per customer
Second CTE: join that back to orders to get the full order details
Show customerid, orderid, orderdate, sales for only the most recent order per customer.*/

with latest as (
select customerid, max(orderdate) as maxd from orders
group by 1) , 
tot as(
select * from orders
) select l.customerid, orderid, orderdate, sales from tot t  
join latest l  on t.customerid= l.customerid  and t.orderdate = l.maxd ;  

/*Problem 6
Using CTEs find customers who have placed more than one order. Show their firstname, lastname and total number of orders. Join customers and orders tables.*/

with ord as (
select customerid, count(orderid) as cnt from orders 
group by customerid) ,
customers_info as (
select * from customers)  select c.firstname, c.lastname ,o.cnt from customers_info c join ord o on c.customerid = o.customerid where o.cnt > 1 ;

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
select employeeid , firstname , lastname , 1 as lvl from employees  where managerid is NULL
union all 
select e.employeeid , e.firstname , e.lastname , c.lvl +1  from employees e join cte c on e.managerid = c.employeeid)
select concat(firstname,' ',lastname) as name, lvl from cte;

/*Problem 8
Extend Problem 7 to show the full management chain for each employee as a string. Like:
Carol Baker — Frank Lee > Mary > Carol Baker*/

with recursive cte as (
select employeeid,firstname,lastname,1 as lvl,concat(firstname,' ',coalesce(lastname,'')) as path from employees where managerid is null
union all 
select e.employeeid,e.firstname,e.lastname, lvl + 1 , concat(coalesce(c.path,''),'>', coalesce(e.firstname,' '),' ',coalesce(e.lastname,' '))from employees e join cte c on e.managerid = c.employeeid
) select * from cte ;
