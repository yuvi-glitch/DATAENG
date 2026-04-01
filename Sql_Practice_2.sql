1) Find the second highest order (by sales) for each customer.

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customerid
               ORDER BY sales DESC
           ) AS rn
    FROM orders
) t
WHERE rn = 2;

2) Find orders where sales are greater than the previous order
SELECT *
FROM (
    SELECT *,
           LAG(sales) OVER (
               PARTITION BY customerid
               ORDER BY orderdate
           ) AS prev_sales
    FROM orders
) t
WHERE sales > prev_sales;

3) List customers who never placed an order
SELECT c.*
FROM customers c
LEFT JOIN orders o 
    ON c.customerid = o.customerid
WHERE o.customerid IS NULL;

4) Find top 3 customers based on total sales

SELECT *
FROM (
    SELECT customerid,
           SUM(sales) AS total_sales,
           DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS rnk
    FROM orders
    GROUP BY customerid
) t
WHERE rnk <= 3;

5) Find orders where the gap between current and previous order is more than 30 days

SELECT *
FROM (
    SELECT *,
           LAG(orderdate) OVER (
               PARTITION BY customerid
               ORDER BY orderdate
           ) AS prev_date
    FROM orders
) t
WHERE DATEDIFF(day, prev_date, orderdate) > 30;
