-----VIEW
create or replace view salesdb.public.products_ord  as (
select oa.*, p.* exclude (productid)  from orders_archive oa
join products p on p.productid = oa.productid 
);

select * from products_ord;

------CTE
WITH cte AS (
    SELECT * FROM orders
)
SELECT * FROM cte; 

-----CTA
CREATE TABLE sales_copy AS
SELECT * FROM orders;

| Feature     | CTE        | View        | CTAS               |
| ----------- | ---------- | ----------- | ------------------ |
| Storage     | ❌ No       | ❌ No        | ✅ Yes          
| Scope       | Query only | Permanent   | Permanent          |
| Reusability | ❌ No       | ✅ Yes       | ✅ Yes         |
| Performance | Depends    | Depends     | Fast (precomputed) |
| Use case    | Logic      | Abstraction | Data storage       |

