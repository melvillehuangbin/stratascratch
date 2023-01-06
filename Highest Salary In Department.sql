-- select * from employee;
-- find employee with highest salary per department
-- department_name, employee's first_name

-- approach
-- 1. rank salary, partition by department [dense_rank, rank is fine]
-- 2. select rank = 1

WITH rank_salaries AS (
    SELECT
        department,
        first_name,
        salary,
        RANK() OVER(PARTITION BY DEPARTMENT ORDER BY salary DESC) AS rank_salary
    from employee
)

SELECT
    department,
    first_name,
    salary
FROM rank_salaries
WHERE rank_salary = 1
ORDER BY salary DESC