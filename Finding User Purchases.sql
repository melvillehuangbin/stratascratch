-- select * from amazon_transactions;
-- 1. this uses lag(created_at) over (partition by user_id order by created_at),  lag() goes over user_ids ordered by created_at, take note that order by will order the table on created_at asc
-- 2. datediff to check if any closest date has difference <= 7

select distinct
    t.user_id
from (
    select
        *,
        datediff(
            created_at,
            lag(created_at) over(partition by user_id order by created_at)
        ) as diff
    from amazon_transactions
) t
where t.diff <= 7