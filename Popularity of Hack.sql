-- select * from facebook_employees

SELECT
    e.location,
    AVG(s.popularity) AS avg_popularity
FROM
    facebook_hack_survey s
    INNER JOIN facebook_employees e on s.employee_id = e.id
GROUP BY e.location