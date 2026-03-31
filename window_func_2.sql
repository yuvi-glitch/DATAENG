

/*Problem 10
For each customer show their most recent order details. Only show the latest order per customer — no duplicates.*/

 SELECT  
    t1.customerid,
    t2.orderdate,
    t2.orderstatus,
    t2.sales
FROM customers t1
INNER JOIN orders t2  
    ON t2.customerid = t1.customerid
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY t2.customerid 
    ORDER BY t2.orderdate DESC
) = 1;
/*note
Need latest/first row per group → ✅ ROW_NUMBER()
Need aggregation (sum, max, avg) → ✅ GROUP BY
Need remove exact duplicates only → ✅ DISTINCT*/

/*Problem 11
Show each order's sales and what percentage that order contributes to the total sales of that customer. Round to 2 decimal places.*/

select 
customerid ,
orderid, 
sales,
tot_sales,
round(sales*100.0/tot_sales,2)  sales_perct from(select 
customerid ,
orderid, 
sales,
sum(sales) over(partition by customerid order by customerid ) as tot_sales 
from orders);


/*Problem 12
Find the difference in sales between each order and the very first order ever placed by that same customer. Show customerid, orderid, orderdate, sales and the difference.*/
/*select 
customerid,
orderid,
sales - diff as difference
from (select customerid,
orderid,
orderdate,
(sales)  over(partition by customerid order by orderdate rows between unbounded preceding and current row) as diff from orders)*/
-- learnt about the  first_value function in snowflake and overcame few syntax errosin window functions 
select
customerid,
orderid,
orderdate,
sales,
sales - first_value(sales) over (partition by customerid order by orderdate) diff 
from orders 
order by customerid;
