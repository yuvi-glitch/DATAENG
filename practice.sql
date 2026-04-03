/*🔢 RANK FUNCTIONS
1. ROW_NUMBER Assign a row number to each order per customer, ordered by orderdate.*/

select
customerid,orderid,orderdate,
row_number() over( partition by customerid order by orderdate) rownum 
from orders 
;

-- 2. Rank orders within each customer based on sales DESC.

select  
customerid,
orderid
SALES,
RANK () over(partition by customerid order by sales DESC) as rank
from orders ;

-- 3. DENSE_RANK Same as above, but no gaps in ranking.
select  
customerid,
orderid
SALES,
DENSE_RANK () over(partition by customerid order by sales DESC) as rank
from orders ;

-- 4. CUME_DIST Find cumulative distribution of sales within each customer.
select 
customerid,
sales , 
CUME_DIST() over (partition by sales order by customerid )  
from orders;

-- 5. PERCENT_RANK Calculate percent rank of orders within each customer based on sales.

select 
customerid,
sales,
percent_rank() over( partition by customerid order by sales)
from orders;


-- 6. NTILE(4) Divide orders into 4 buckets per customer based on sales.

select
customerid,
NTILE(4) over(partition by customerid order by sales) as ntile
from orders;

-- 7. LAG Get previous order sales for each customer based on orderdate.

 select
 customerid,
 orderid,
 sales,
 LAG(sales,1,0)  over(partition by customerid order by orderdate ) prev_sales   
 from orders;
 
-- 8. LEAD Get next order sales for each customer based on orderdate.

select 
customerid,
sales,
LEAD(sales,1,NULL) over(partition by customerid order by orderdate) as LAG
from orders;

-- 9. FIRST_VALUE Get the first order sales for each customer.
select
sales,
customerid,
first_value( sales) over(partition by customerid order by sales ) first
from orders;

-- 10. Sales Difference Find difference between current order and previous order:

SELECT 
    customerid,
    orderid,
    sales,
    LAG(sales) OVER (
        PARTITION BY customerid 
        ORDER BY orderdate
    ) AS prev_sales,
    
    sales - LAG(sales) OVER (
        PARTITION BY customerid 
        ORDER BY orderdate
    ) AS sales_diff
FROM orders;

-- 11. First Order Only return only the first order per customer.

select 
orderdate,
customerid,
orderid,
from orders
qualify row_number() over(partition by customerid order by orderdate)  =1  ;

-- 12. Highest Sales per Customer Return orders which have maximum sales per customer.

with max_data as
(
select customerid,
orderid, 
max(sales) over(partition by customerid) as max_sales,sales 
from orders
)
select * from max_data
where sales = max_sales;


-- alternate

with ranked as (
select *,
row_number() over(partition by customerid order by sales desc) as rn 
from orders
) select * from ranked where rn = 1;



/*💣 BONUS (VERY IMPORTANT FOR REAL INTERVIEWS)
13. Latest Order per Customer*/
with data as (
select * , row_number() over(partition by customerid order by orderdate DESC) as rnk  from orders)
select * from data where rnk =1 ;

-- 14. Second Highest Sale per Customer
with data as (
select * ,
row_number() over(partition by customerid order by sales DESC) as rnk 
from orders)
select *  from data where rnk = 2  ;

👉 Trick question — test your ranking understanding.

-- 15. Running Total of Sales Calculate cumulative sales per customer ordered by date.
