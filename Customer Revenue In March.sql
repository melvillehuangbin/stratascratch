-- select * from orders;
SELECT
    cust_id,
    SUM(CASE WHEN order_date BETWEEN '2019-03-01' AND '2019-03-31' THEN total_order_cost ELSE 0 END) AS revenue
FROM
    orders
GROUP BY
    cust_id
HAVING 
    SUM(CASE WHEN order_date BETWEEN '2019-03-01' AND '2019-03-31' THEN total_order_cost ELSE 0 END) <> 0
ORDER BY
    revenue DESC
