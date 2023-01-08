-- select * from employee;
-- find all employees who are earning more than their managers
-- output: employee's first_name, salary

-- Approach
-- 1. join to get manager's salary (inner join)
-- 2. salary > manager's salary (where)

WITH manager_salary AS (
    SELECT
        e.first_name AS employee_name,
        e.salary,
        m.salary AS manager_salary
    FROM
        employee e
        LEFT JOIN
            employee m
            ON e.manager_id = m.id
)

SELECT
    employee_name,
    salary
FROM manager_salary
WHERE salary > manager_salary