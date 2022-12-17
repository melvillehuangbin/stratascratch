with cte as (
    select
        d.department,
        max(e.salary) as salary
    from
        db_employee e
        left join db_dept d on e.department_id = d.id
    group by 1
)

select distinct abs((select salary from cte where department = 'marketing') - (select salary from cte where department = 'engineering')) as salary_difference
from cte