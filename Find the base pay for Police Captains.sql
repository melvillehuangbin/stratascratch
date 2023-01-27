-- select * from sf_public_salaries;
SELECT
    employeename,
    basepay
FROM sf_public_salaries
WHERE LOWER(jobtitle) LIKE '%captain%'