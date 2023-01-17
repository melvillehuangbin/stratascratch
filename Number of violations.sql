-- select * from sf_restaurant_health_violations;
WITH count_inspections AS (
    SELECT
        EXTRACT(YEAR FROM inspection_date) AS year,
        COUNT(CASE WHEN violation_id IS NOT NULL AND business_name = 'Roxanne Cafe' THEN inspection_id END) AS n_inspections
    FROM 
        sf_restaurant_health_violations
    GROUP BY 
        year
    ORDER BY
        year ASC
)
SELECT * FROM count_inspections WHERE n_inspections <> 0