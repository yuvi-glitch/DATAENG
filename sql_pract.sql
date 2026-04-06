/*Level 1 — CTE Basics (Warm Up)
Problem 1
Using a CTE, find all employees whose salary is above the company average. Show firstname, department, salary and the company average salary alongside each row.*/
select  * from (
select firstname,department ,salary ,avg(salary) as avg_s 
from  employees;) 
where salary > avg_s

/*
Problem 2
Using a CTE, find the total sales per customer. Then from that result show only customers whose total sales exceed 50. Show customerid and their total sales.*/
 select * from ( select sum(sales) as tot , customerid from orders group by customerid)  
 where tot > 50 ;
 
/*Problem 3
Using a CTE, find the most expensive product in each category. Show category, product name and price.*/
select * from (select category,product,price from products)
where price = max(price) group by category;

/*Level 2 — Multiple CTEs (Medium)
Problem 4
Write a query using two CTEs:
First CTE: calculate total sales per salesperson
Second CTE: calculate average sales across all salespersons
Then show only salespersons who performed above the average. Show employeeid and their total sales.*/

WITH SalesPerPerson AS (
    SELECT 
        salespersonid,
        SUM(sales) AS total_sales
    FROM orders
    GROUP BY salespersonid
),
AverageSales AS (
    SELECT 
        AVG(total_sales) AS avg_sales
    FROM SalesPerPerson
)
SELECT 
    s.salespersonid,
    s.total_sales
FROM SalesPerPerson s
CROSS JOIN AverageSales a
WHERE s.total_sales > a.avg_sales;

/*Problem 5
Write a query using two CTEs:

First CTE: get the latest order date per customer
Second CTE: join that back to orders to get the full order details
Show customerid, orderid, orderdate, sales for only the most recent order per customer.*/
WITH LatestDates AS (
    SELECT customerid, MAX(orderdate) AS max_date
    FROM orders
    GROUP BY customerid
),
LatestOrders AS (
    SELECT o.customerid, o.orderid, o.orderdate, o.sales
    FROM orders o
    JOIN LatestDates ld
        ON o.customerid = ld.customerid AND o.orderdate = ld.max_date
)
SELECT customerid, orderid, orderdate, sales FROM LatestOrders;

/*Problem 6
Using CTEs find customers who have placed more than one order. Show their firstname, lastname and total number of orders. Join customers and orders tables.*/

WITH customer_orders AS (
    SELECT 
        c.firstname,
        c.lastname,
        COUNT(o.orderid) AS total_orders
    FROM customers c
    JOIN orders o 
        ON c.customerid = o.customerid
    GROUP BY 
        c.firstname, c.lastname
)

SELECT *
FROM customer_orders
WHERE total_orders > 1;
