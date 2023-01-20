-- select * from olympics_athletes_events;
WITH count_athletes AS (
    SELECT DISTINCT
        games,
        COUNT(DISTINCT id) AS athletes_count
    FROM 
        olympics_athletes_events
    GROUP BY    
        games
)

SELECT
    games,
    athletes_count
FROM
    count_athletes
WHERE
    athletes_count = (SELECT MAX(athletes_count) FROM count_athletes)