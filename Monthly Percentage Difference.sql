-- month over month percentage change in revenue
-- output include YYYY-MM
-- percentage change (round to 2 dp) = this month revenue - last month revenue / last month revenue * 100
-- sort from beginning of year to end of year
-- populate from 2nd month forward

with cte as (
    select
        TO_CHAR(created_at, 'YYYY-MM') as year_month,
        sum(value) as price
    from sf_transactions
    group by 1
    order by 1 asc
),

cte_2 as (
    select
        *,
        lag(price) over(order by year_month) as previous_price
    from cte
)

select
    year_month,
    round(((price - previous_price) / previous_price) * 100, 2) as revenue_diff_pct
from cte_2
    