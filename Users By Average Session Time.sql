-- select * from facebook_web_log;
-- caclculate each user's average session time
-- session = page_exit - page_load
-- user only has 1 session per day and if multiple of same events on that day, consider only latest page_load and earliest page_exit
-- output: user_id, average session time

-- 1. get only page_load and page_exit action (where), two tables
-- 2. rank the actions based on timestamp desc (dense_rank over)
-- 3. get the differences of earliest page exit (min) - latest page_load (max) (inner join)
-- 4. average the differences (avg, group by), per day

with pe as (
    select
        t.user_id,
        t.date,
        t.timestamp
    from (
        select
            user_id,
            timestamp,
            date(timestamp) as date,
            action,
            dense_rank() over (partition by action, date(timestamp), user_id order by timestamp asc) as rank_timestamp
        from facebook_web_log
        where action = 'page_exit'
    ) t
    where rank_timestamp = 1
),

pl as (
    select
        t.user_id,
        t.date,
        t.timestamp
    from (
        select
            user_id,
            timestamp,
            date(timestamp) as date,
            action,
            dense_rank() over (partition by action, date(timestamp) , user_id order by timestamp desc) as rank_timestamp
        from facebook_web_log
        where action = 'page_load'
    ) t
    where rank_timestamp = 1
)

select
    pe.user_id,
    avg(pe.timestamp - pl.timestamp) as avg
from pe
inner join pl on pe.user_id = pl.user_id and pe.date = pl.date
group by 1






