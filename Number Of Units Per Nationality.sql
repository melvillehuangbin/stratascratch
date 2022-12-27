-- select * from airbnb_hosts;
-- number of apartments per nationality owned by people under 30 years old
-- output: nationality, number_of_apartments
-- sort by apartment count descending

-- we have 2 tables, airbnb_hosts: host level, airbnb_units: unit level
-- take note of columns that impact the outcome you want
-- 1. aggregate the unit_level (sum(unit_id)) to get number of apartments per host
-- 2. join to host level to get nationality
-- 3. get age < 30
-- 4. sort by apartment count descending (order by desc)


with sum_apartments as (
    select distinct
        u.host_id,
        u.unit_id,
        h.nationality,
        h.age
    from airbnb_units u
    left join airbnb_hosts h on u.host_id = h.host_id
    where h.age < 30
    and u.unit_type = 'Apartment'
)

select
    nationality,
    count(unit_id) as apartment_count
from sum_apartments
group by 1
order by 2 desc




