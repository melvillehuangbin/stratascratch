-- we want to find the titles of workers that earn highest salary
-- output highest-paid title or multiplt titltes that share highest salary
-- 1. get title by joining worker to title table (inner join)
-- 2. use rank to keep the ranking (rank) of salaries
-- 3. select the number 1 rank salary (where)

select
    t1.worker_title as best_paid_title
from (
    select
        t.worker_title,
        rank() over(order by w.salary desc) as rank_salary
    from worker w
    inner join title t on w.worker_id = t.worker_ref_id
) t1
where t1.rank_salary = 1

