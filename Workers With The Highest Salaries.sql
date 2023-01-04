-- select * from worker;
-- titles of workers that earn the highest salary
-- highest-paid or multiple titles that share highest salary

### 1st approach: window function ###
-- 1. rank their salaries (rank, order by salary desc) to keep ranking
-- 2. get title of worker (join)

### 2nd approach: max (tried) updated###
-- 1. check salary = max(salary) (subquery + where) 
select distinct
    t.worker_title
from (
    select
        rank() over(order by w.salary desc) as salary_rank,
        ti.worker_title
    from worker w
    inner join title ti on w.worker_id = ti.worker_ref_id
) t
where t.salary_rank = 1