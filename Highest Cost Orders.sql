-- select * from customers;
-- find customer with highest daily total order cost between 2019-02-01 to 2019-05-01
-- if customer > 1 order on day, sum order cost on daily basis
-- output: customer first name, total cost of items, date

-- we have a table with customer information and atable with orders made by customer by date granularity
-- we assume that each customer can make multiple orders and total_order_cost can tie in ranking

-- approach
-- 1. sum total order cost (sum, group by, cust_id & order_date)
-- 2. get dates between 2019-02-01 and 2019-05-01 (where)
-- 3. get first name of customer (inner join)
-- 4. get highest daily total order cost (where, max subquery)

with sum_total_cost as (
    select
        cust_id,
        order_date,
        sum(total_order_cost) as total_order_cost
    from orders
    where order_date between '2019-02-01' and '2019-05-01'
    group by 1,2
)

select
    c.first_name,
    t.total_order_cost,
    t.order_date
from sum_total_cost t
inner join customers c on t.cust_id = c.id
where t.total_order_cost = (select max(total_order_cost) from sum_total_cost)