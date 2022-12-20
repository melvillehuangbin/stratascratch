-- select * from forbes_global_2010_2014;
-- 3 most profitable companies in the world
-- output: company name, profit
-- sort base on profits in descending order

-- 1. select company, profits
-- 2. rank them by profits (order by)
-- 3. get top 3 (limit)

select
    company,
    profits
from forbes_global_2010_2014
order by profits desc
limit 3