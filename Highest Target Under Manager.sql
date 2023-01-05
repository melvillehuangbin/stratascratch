-- select * from salesforce_employees;

-- highest target achieved by the employee or employees who works under the manager id 13
-- first name of employee and target achieved
-- solution should show highest target achieved under manager_id = 13 and which employee receives it

-- input: salesforce_employees
-- output: first_name, target

-- Approach
-- 1. find employees working under manager_id = 13 (where) [cte]
-- 2. use rank to rank targets base on target
-- 3. select rank = 1

WITH manager_13_employees AS (
    SELECT
        first_name,
        target
    FROM salesforce_employees
    WHERE manager_id = 13
)

,

rank_targets AS (
    SELECT
        first_name,
        target,
        RANK() OVER(ORDER BY target DESC) AS rank_target
    FROM manager_13_employees
)

SELECT
    first_name,
    target
FROM rank_targets
WHERE rank_target = 1